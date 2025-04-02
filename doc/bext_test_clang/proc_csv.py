#! python3

import sys
import csv

def read_csv(file):
    with open(file, 'r') as f:
        reader = csv.reader(f)
        res = []
        for row in reader:
            res.append(row)

    return res[5:]

def main():
    args = sys.argv[1:]
    s = read_csv(args[0])
    len_sum = 0
    for row in s:
        len_sum += int(row[2])
    print("Total length of all codes: ", len_sum)
    avg_len = len_sum / len(s)
    print("Average length of all codes: ", avg_len)
    print("Max length of all codes: ", max([int(row[2]) for row in s]))

    # give 10% - 90% percent numbers
    s = sorted([int(row[2]) for row in s])
    for i in range(0, 100, 10):
        print(f"{i}%: {s[int(len(s) * i / 100)]}")
    print("100%: ", s[-1])

if __name__ == '__main__':
    main()
