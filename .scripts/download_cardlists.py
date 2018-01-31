"""
This script downloads the card list from LackeyCCG.

Uses Python 3.5.
"""
import os
import csv
import json
import unicodedata
import re

import requests


LISTING = 'http://www.lackeyccg.com/vtes/common/allsets.txt'


def create_normalized_name(name):
    name = unicodedata.normalize('NFKD', name).lower()
    return re.sub(r'[^\x00-\x7F]+', '', name)


def download_card_list():
    r = requests.get(LISTING)
    if r.status_code != 200:
        print('Error while downloading file list.')
        exit(-1)

    data = []
    for row in csv.DictReader(r.text.splitlines(), delimiter='\t',
                              quoting=csv.QUOTE_NONE):
        if row['Type'] == 'Token':
            continue
        data.append({
            'name': row['Name'],
            'norm_name': create_normalized_name(row['Name']),
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
    return data


def main():
    data = download_card_list()
    with open('cards.json', 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)


if __name__ == '__main__':
    main()
