"""
This script downloads the card list from LackeyCCG.

Uses Python 3.5.
"""
import os
import csv
import json
import unicodedata
import re
import copy

import requests
from Levenshtein import distance


LISTING = 'https://lackeyccg.com/vtes/common/sets/allsets.txt'


def create_normalized_name(name):
    name = unicodedata.normalize('NFKD', name).lower()
    return re.sub(r'[^\x00-\x7F]+', '', name)


def try_int(val):
    try:
        return int(val)
    except ValueError:
        return val


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
            'set': row['SET'],
            'card_id': row['ImageFile'].split(',')[0],
            'expansion': row['Expansion'],
            'rarity': row['Rarity'],
            'type': row['Type'],
            'clan': row['Clan'],
            'group': row['Group'],
            'capacity': try_int(row['Capacity']),
            'disciplines': row['Discipline'].split(),
            'pool': try_int(row['PoolCost']),
            'blood': try_int(row['BloodCost']),
            'text': row['Text'],
            'artist': row['Artist'],
            'new_card_id': row['ImageFile'].split(',')[0],
        })
    return data


def upgrade_list(new_data, old_data):
    # Convert to dictionaries
    new_data = {d['card_id']: d for d in new_data}
    old_data = {d['card_id']: d for d in old_data}

    # Copy perfect matching
    perfect_matches = set(new_data.keys()).intersection(old_data.keys())
    merged_data = [new_data.pop(k) for k in perfect_matches]
    [old_data.pop(k) for k in perfect_matches]

    # Match remaining keys in old
    for card_id, card in old_data.items():
        closests = [(prop, distance(card_id, prop)) for prop in new_data]
        closests.sort(key=lambda x: x[1], reverse=False)
        new_key, best_score = closests[0]

        print(f"[{best_score}] Matching {card['name']} => {new_data[new_key]['name']}", end='')
        if best_score > 10:
            print('. Not a good match!')
            continue
        else:
            print(' Ok!')

        # Add new data with old key
        d = new_data.pop(new_key)
        d['card_id'] = card_id
        merged_data.append(d)

    # Add remaining new
    merged_data.extend(new_data.values())
    print(len(merged_data))
    return merged_data


def main():
    data = download_card_list()

    with open('../private/cards.json', 'r') as f:
        old_data = json.load(f)

    data = upgrade_list(data, old_data)

    with open('cards.json', 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)


if __name__ == '__main__':
    main()
