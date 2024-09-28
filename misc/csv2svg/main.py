#!/usr/bin/env python3

"""
Generate svg table from csv file
"""
import csv
import argparse


class SvgConf:
    """
    Configuration for svg table
    """

    def __init__(self, font_size=12, font_family='Arial', stroke_width=2,
                 padding_x=5, padding_y=4, color_gen_func=None):

        def gen_bg_color(_row: int, _col: int, _content: str) -> tuple[int, int, int]:
            if _row % 2 == 0:
                return 255, 255, 255
            return 220, 220, 220
        self.font_size = font_size
        self.font_family = font_family
        self.stroke_width = stroke_width
        self.padding_x = padding_x
        self.padding_y = padding_y
        self.color_gen_func = gen_bg_color if color_gen_func is None else color_gen_func


def calculate_size(conf: SvgConf, head, data):
    """
    ret: (row_height,  col_width[])
    """
    row_height = 20 * conf.font_size / 12 + 2 * conf.padding_y  # 2 is padding
    col_max_width = [0] * len(head)
    for idx, i in enumerate(head):
        # As the head is blod, so the width is larger, with a factor multiplier
        col_max_width[idx] = max(col_max_width[idx], len(i) * 1.1)
    for row in data:
        for idx, i in enumerate(row):
            col_max_width[idx] = max(col_max_width[idx], len(i))
    col_width = [
        10 * conf.font_size / 12 * max_width + 2 * conf.padding_x  # 10 is padding
        for max_width in col_max_width
    ]
    return row_height, col_width


class SvgNode:
    def __init__(self, begin_content='', end_content=''):
        self.begin_content = begin_content
        self.end_content = end_content
        self.children = []

    def add_child(self, child):
        self.children.append(child)

    def __str__(self):
        return self.begin_content + ''.join(map(str, self.children)) + self.end_content


def gen_svg_table(conf: SvgConf, head: list[str], data: list[list[str]]) -> SvgNode:
    def strip_head(head):
        return [i.strip() for i in head]

    def strip_data(data):
        return [[j.strip() for j in i] for i in data]
    head = strip_head(head)
    data = strip_data(data)
    row_height, row_width = calculate_size(conf, head, data)
    row_cnt = len(data) + 1
    col_cnt = len(head)

    doc = SvgNode('<?xml version="1.0" encoding="UTF-8" standalone="no"?>', '')

    # left and right and top and bottom is 2x
    svg_width = sum(row_width) + conf.stroke_width * (col_cnt + 5)
    svg_height = row_height * row_cnt + conf.stroke_width * (row_cnt + 5)
    svg = SvgNode(
        f'<svg xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" id="svg-chart" font-family="{
            conf.font_family}" height="{svg_height}" width="{svg_width}" style="font-size: {conf.font_size}pt;">',
        '</svg>'
    )

    table_height = row_height * row_cnt + conf.stroke_width * (row_cnt + 1)
    table_width = sum(row_width) + conf.stroke_width * (col_cnt + 1)

    # table background
    table_bg = SvgNode(
        f'<rect id="table-bg" x="0" y="0" width="{svg_width}" height="{
            svg_height}" style="fill: rgb(255, 255, 255);"/>',
        ''
    )
    svg.add_child(table_bg)

    ypos = conf.stroke_width * 2
    # table head
    table_head = SvgNode('<g>', '</g>')
    xpos = conf.stroke_width * 2
    head_bg = SvgNode(
        f'<rect x="0" y="{ypos}" width="{table_width}" height="{
            row_height}" style="fill: rgb(200,200,200);"/>',
        ''
    )
    table_head.add_child(head_bg)
    for idx, i in enumerate(head):
        text = SvgNode(
            f'{i}',
            ''
        )
        item = SvgNode(
            f'<text x="{xpos + conf.padding_x}" y="{ypos +
                                                    row_height / 2}" font-weight="bold" class="table-head" width="{row_width[idx]}">',
            '</text>'
        )
        item.add_child(text)
        table_head.add_child(item)
        xpos += row_width[idx] + conf.stroke_width
    svg.add_child(table_head)
    ypos += row_height

    # table data
    for (row_idx, row) in enumerate(data):
        xpos = conf.stroke_width * 2
        table_row = SvgNode('<g>', '</g>')

        # upper line
        line = SvgNode(
            f'<line x1="0" y1="{ypos}" x2="{table_width}" y2="{
                ypos}" style="stroke:rgb(128,128,128);stroke-width:{conf.stroke_width}"/>',
            ''
        )
        svg.add_child(line)
        ypos += conf.stroke_width
        for idx, i in enumerate(row):
            text = SvgNode(
                f'{i}',
                ''
            )
            text_node = SvgNode(
                f'<text x="{xpos + conf.padding_x}" y="{ypos + row_height /
                                                        2}" class="table-data" height="{row_height}" width="{row_width[idx]}">',
                '</text>'
            )
            text_node.add_child(text)
            table_row.add_child(text_node)
            back_color = conf.color_gen_func(row_idx, idx, i)
            back_color = f'rgb({back_color[0]},{
                back_color[1]},{back_color[2]})'
            text_bg = SvgNode(
                f'<rect x="{xpos}" y="{ypos}" width="{row_width[idx]}" height="{
                    row_height}" style="fill: {back_color};"/>',
                ''
            )
            svg.add_child(text_bg)
            xpos += row_width[idx] + conf.stroke_width
        ypos += row_height
        svg.add_child(table_row)

    # item vertical line
    xpos = conf.stroke_width * 2
    for idx in range(len(head) - 1):
        xpos += row_width[idx]
        line = SvgNode(
            f'<line x1="{xpos}" y1="0" x2="{xpos}" y2="{
                table_height}" style="stroke:rgb(128,128,128);stroke-width:{conf.stroke_width}"/>',
            ''
        )
        svg.add_child(line)
        xpos += conf.stroke_width

    # table border
    border_top = SvgNode(
        f'<line x1="0" y1="{conf.stroke_width}" x2="{
            table_width}" y2="{conf.stroke_width}" style="stroke:rgb(0,0,0);stroke-width:{conf.stroke_width * 2}"/>',
        ''
    )
    svg.add_child(border_top)
    border_bottom = SvgNode(
        f'<line x1="0" y1="{table_height}" x2="{table_width}" y2="{
            table_height}" style="stroke:rgb(0,0,0);stroke-width:{conf.stroke_width * 2}"/>',
        ''
    )
    svg.add_child(border_bottom)
    border_left = SvgNode(
        f'<line x1="0" y1="0" x2="0" y2="{
            table_height}" style="stroke:rgb(0,0,0);stroke-width:{conf.stroke_width * 2}"/>',
        ''
    )
    svg.add_child(border_left)
    border_right = SvgNode(
        f'<line x1="{table_width}" y1="0" x2="{table_width}" y2="{
            table_height}" style="stroke:rgb(0,0,0);stroke-width:{conf.stroke_width * 2}"/>',
        ''
    )
    svg.add_child(border_right)

    doc.add_child(svg)
    return doc


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', dest='csv_file', help='csv file path')
    parser.add_argument('-o', '--output', dest='output',
                        help='output file path')

    options = parser.parse_args()
    csv_file = options.csv_file
    csv_content = csv.reader(open(csv_file, 'r', encoding="utf-8"))
    head = next(csv_content)
    data = []
    for row in csv_content:
        data.append(row)

    def f(row, col, content):
        white = (255, 255, 255)
        gray = (220, 220, 220)
        green = (203, 255, 203)
        yellow = (255, 255, 203)
        red = (255, 203, 203)
        if col < 3:
            return white
        if "Good" in content or "Basic" in content:
            return green
        if "CFT" in content:
            return yellow
        if "WIP" in content or "CFH" in content:
            return red
        return gray
    conf = SvgConf(color_gen_func=f)
    res = gen_svg_table(conf, head, data)
    with open(options.output, 'w', encoding="utf-8") as f:
        f.write(str(res))


if __name__ == '__main__':
    main()
