"""

"""
import unicodedata
import json
import sys
import string
import re


def remove_accents(data):
    data = unicodedata.normalize('NFKD', data).lower()
    data = re.sub(r'[^\x00-\x7F]+','', data)
    return re.sub(r'[\W]*', '', data)


if len(sys.argv) != 4:
    print("Usage: [in file] [out file]")
    exit()


with open(sys.argv[1]) as infile:
    data = json.load(infile)

with open(sys.argv[2]) as infile:
    data.extend(json.load(infile))

mapping = {}
for arr in data:
    mapping[arr['id']] = remove_accents(arr['Name'])

with open(sys.argv[3], 'w') as outfile:
    json.dump(mapping, outfile, sort_keys=True, indent=2)
