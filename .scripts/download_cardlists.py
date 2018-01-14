"""
This script downloads the card list from LackeyCCG.

Uses Python 3.5.
"""
import os
import csv
import json

import requests


LISTING = 'http://www.lackeyccg.com/vtes/common/allsets.txt'


def main():
    r = requests.get(LISTING)
    if r.status_code != 200:
        print('Error while downloading file list.')
        exit(-1)

    data = []
    for row in csv.DictReader(r.text.splitlines(), delimiter='\t',
                              quoting=csv.QUOTE_NONE):
        data.append({
            'name': row['Name'],
            'set': row['Set'],
            'card_id': row['ImageFile'].split(',')[0],
            'expansion': row['Expansion'],
            'rarity': row['Rarity'],
            'type': row['Type'],
            'clan': row['Clan'],
            'group': row['Group'],
            'capacity': row['Capacity'],
            'disciplines': row['Discipline'].split(),
            'pool': row['PCost'],
            'blood': row['BCost'],
            'text': row['Text'],
            'artist': row['Artist'],
        })

    with open('cards.json', 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)


if __name__ == '__main__':
    main()
