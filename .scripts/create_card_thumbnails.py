"""
Creates thumbnails of the artwork in the images.
Requires imagemagick installed.
"""
import sys
import json
import subprocess
from os import path


CRYPT_COMMAND = 'convert "%s" -crop "240x240+92+100" -resize "150x150" +repage "%s"'
LIB_COMMAND = 'convert "%s" -crop "240x240+85+50" -resize "150x150" +repage "%s"'

# Read cards.json
with open(sys.argv[1]) as infile:
    cards = json.load(infile)

in_folder = sys.argv[2]
out_folder = sys.argv[3]

for card in cards:
    name = card['card_id'] + '.jpg'

    if card['type'] == 'Vampire' or card['type'] == 'Imbued':
        cmd = CRYPT_COMMAND % (path.join(in_folder, name), path.join(out_folder, name))
    else:
        cmd = LIB_COMMAND % (path.join(in_folder, name), path.join(out_folder, name))

    print(cmd)
    subprocess.run(cmd, shell=True, check=True)
