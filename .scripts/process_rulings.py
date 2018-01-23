"""
Reads a textfile with card rulings and outputs a json file.
Format
[Card 1]:
[Rule 1]
[Rule 2]
[Card 2]:
[Rule 1]
[Rule 2]

If the data is dirty id_by_name might fail. Maybe we should use string scoring.
"""
import unicodedata
import json
import sys
import string
import re

from Levenshtein import distance


def remove_accents(data):
    data = unicodedata.normalize('NFKD', data).lower()
    return re.sub(r'[^\x00-\x7F]+','', data)


def is_rule(line):
    return line.strip().endswith(']')


def id_by_name(name, cards):
    for card in cards:
        s1 = card['name'].lower().replace(', the', '')
        s2 = name.lower().replace('the ', '')

        if s1 == s2:
            return card['card_id']

        if card['norm_name'] == remove_accents(name):
            return card['card_id']

        # fallback to Levenshtein
        if distance(s1, s2) <= 1:
            print('Levenshtein match: %s -> %s' %  (card['name'], name))
            return card['card_id']

    print('error while finding id of %s' % name)
    return -1


if len(sys.argv) != 4:
    print("Usage: [in file] [cards.json] [out file]")
    exit()

with open(sys.argv[1]) as infile:
    data = infile.readlines()

with open(sys.argv[2]) as infile:
    cards = json.load(infile)

rulings = []
i = 0
while i < len(data):
    card = data[i].strip()[:-1]

    i += 2
    rules = []
    while i < len(data) and is_rule(data[i]):
        rules.append(data[i].strip())
        i += 1

    cardid = id_by_name(card, cards)
    rulings.append({'name': card, 'rulings': rules, 'id': cardid})

with open(sys.argv[3], 'w') as outfile:
    json.dump(rulings, outfile, indent=2)
