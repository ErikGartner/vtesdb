"""
Reads a json array with dicts.
Adds an incrementing integer id in each.
"""

import json
import sys

if len(sys.argv) != 4:
    print("Usage: [in file] [out file] [start index]")
    exit()

with open(sys.argv[1]) as infile:
    data = json.load(infile)

index = int(sys.argv[3])
for arr in data:
    arr['id'] = str(index)
    index = index + 1

print('Next index should be %d' % index)

with open(sys.argv[2], 'w') as outfile:
    json.dump(data, outfile)
