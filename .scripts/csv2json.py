"""
Reads a csv file and outputs a json file.
Only reads certain columns from the csv file.
""""

import json
import csv
import sys

if len(sys.argv) < 3:
    print("Usage: [csv file] [json file] [keys..]")
    exit()

with open(sys.argv[1]) as csvfile:
    reader = csv.DictReader(csvfile)

    data = []
    for row in reader:
        line = {}
        for i in range(3, len(sys.argv)):
            key = sys.argv[i]
            value = row[key].encode('utf-8', 'ignore')
            value = value.decode('utf-8', 'ignore')      # due to b''
            line[key] = value
        if(len(line) > 0):
            data.append(line)

with open(sys.argv[2], 'w') as outfile:
    json.dump(data, outfile)
