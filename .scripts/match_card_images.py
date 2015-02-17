"""
Renames images in a folder to the id in a vteslib json.
Requires all images to end with .jpg.
"""

import json
import sys
from os import walk
import os.path
import shutil
import re
import unicodedata

if len(sys.argv) < 3:
    print("Usage: [folder] [json files..]")
    exit()

imgfolder = sys.argv[1].rstrip("/")
outfolder = 'renamed_images/'
data = []
for i in range(2, len(sys.argv)):
    with open(sys.argv[i]) as infile:
        data = data + json.load(infile)

f = []
for (dirpath, dirnames, filenames) in walk(imgfolder):
    f.extend(filenames)
    break

if os.path.exists(outfolder):
    shutil.rmtree(outfolder)
os.mkdir(outfolder)

failed = 0
success = 0
for card in data:
    name = card['Name']
    card_id = card['id']
    vtes_set = card['Set']

    normalized_name = re.sub(r'\W+', '', name).lower()
    normalized_name = ''.join((c for c in unicodedata.normalize('NFD', normalized_name) if unicodedata.category(c) != 'Mn'))

    if 'Adv' in card and len(card['Adv']) > 0:
        normalized_name = normalized_name + 'adv'

    filename = imgfolder + '/' + normalized_name + '.jpg'

    if not os.path.isfile(filename):
        print('File %s for %s (%s) didn\'t exist! Id = %s' % (filename, name, vtes_set, card_id))
        failed = failed + 1
        continue

    shutil.copy2(filename, outfolder + card_id + '.jpg')
    success = success + 1

print('Done, %d/%d' % (success, failed + success))
