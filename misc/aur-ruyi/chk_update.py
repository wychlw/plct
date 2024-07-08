import bs4
import requests
import os

def ver_gt(ver1: str, ver2: str):
    ver1 = tuple(map(int, ver1.split('.')))
    ver2 = tuple(map(int, ver2.split('.')))
    return ver1 > ver2

def sort_ver(ver_list: list[str]):
    def ver_key(ver: str):
        return tuple(map(int, ver.split('.')))
    ver_list.sort(key=ver_key)

def get_last_ver():
    pkgbuild_url  = 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=ruyi-bin'
    pkgbuild_content = requests.get(pkgbuild_url).text
    pkgconf = pkgbuild_content.split('\n')
    for line in pkgconf:
        if 'pkgver=' in line:
            return line.split('=')[1].strip().strip('"')
    return '0.0.0'

def get_current_ver():
    mirror_base_url = 'https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/'
    mirror_page = requests.get(mirror_base_url).text
    soup = bs4.BeautifulSoup(mirror_page, 'html.parser')
    selector = '#list > tbody > tr > td.link > a'
    links = soup.select(selector)
    ver_list = []
    for link in links:
        href = link.get('href')
        if '..' in href:
            continue
        title = link.get('title')
        ver_list.append(title)

    sort_ver(ver_list)
    return ver_list[-1]

last_ver = get_last_ver()
cur_ver = get_current_ver()

print(f"Last version: {last_ver}, Current version: {cur_ver}")

if ver_gt(cur_ver, last_ver):
    exit(0)
else:
    exit(1)