"""
Reads a json array with dicts. Adds the norm-name key.
"""
import unicodedata
import json
import sys
import string
import re

def remove_accents(data):
    data = unicodedata.normalize('NFKD', data).lower()
    return re.sub(r'[^\x00-\x7F]+','', data)

if len(sys.argv) != 3:
    print("Usage: [in file] [out file]")
    exit()

with open(sys.argv[1]) as infile:
    data = json.load(infile)

for arr in data:
    arr['Norm-Name'] = remove_accents(arr['Name'])

with open(sys.argv[2], 'w') as outfile:
    json.dump(data, outfile)
