"""
A very old and messy script for downloading
tournament winning decks.
"""

from urllib.request import urlopen
import io
import json
import traceback
import re
import unicodedata
import sys

from bs4 import BeautifulSoup
from Levenshtein import distance


def find(text, regs):
    best_find = -1
    for reg in regs:
        match = re.search(reg, text)
        if match and best_find != -1:
            best_find = min(best_find, match.start())
        elif match and best_find == -1:
            best_find = match.start()
    return best_find


def parse_vampire(line):
    count_split = line.split(None, 1)
    count = int(count_split[0].replace('x', '').replace('X', ''))
    rline = count_split[1].strip()

    # common splitters between name and rest
    regs = ['\t', '\d', '  ', ' abo ', ' ani ', ' aus ', ' cel ', ' chi ',
            ' dai ', ' dem ', ' dom ', ' for ', ' mel ', ' myt ', ' nec ',
            ' obe ', ' obf ', ' obt ', ' pot ', ' pre ', ' pro ', ' qui ',
            ' san ', ' ser ', ' spi ', ' tem ', ' thn ', ' tha ', ' val ',
            ' vic ', ' vis ', ' mal ', ' str ', ' ABO ', ' ANI ', ' AUS ',
            ' CEL ', ' CHI ', ' DAI ', ' DEM ', ' DOM ', ' FOR ', ' MEL ',
            ' MYT ', ' NEC ', ' OBE ', ' OBF ', ' OBT ', ' POT ', ' PRE ',
            ' PRO ', ' QUI ', ' SAN ', ' SER ', ' SPI ', ' TEM ', ' THN ',
            ' THA ', ' VAL ', ' VIC ', ' VIS ', ' MAL ', ' STR ', '\(']
    res = find(rline, regs)
    if res == -1:
        raise Exception("Could't parse character: %s" % line)

    name = rline[:res].strip()
    lline = line.lower()
    if ' adv' in lline:
        pos = name.lower().find(' adv')
        if(pos != -1):
            name = name[:pos]
        name += ' (ADV)'
    elif '(adv)' in lline:
        pos = name.lower().find('(adv)')
        if(pos != -1):
            name = name[:pos]
        name += ' (ADV)'

    return (count, name)


def remove_accents(data):
    data = unicodedata.normalize('NFKD', data).lower()
    return re.sub(r'[^\x00-\x7F]+', '', data)


def id_from_name(name, cards):

    id_proposal = remove_accents(name).lower().replace('the ', '').strip()
    #print("Trying to match %s" % id_proposal)

    for card in cards:
        s1 = card['norm_name'].replace('the ', '').strip()

        if s1 == id_proposal:
            return card['card_id']

        # fallback to Levenshtein
        #if distance(s1, id_proposal) <= 1:
        #    print('Levenshtein match: %s -> %s' %  (card['name'], name))
        #    return card['card_id']

    print('Error while finding id of %s' % name)
    return None


def extract_deck(text, carddb):
    vamps = {}
    lib = {}
    description = ''

    lines = text.splitlines()
    lines = map(str.strip, lines)   # strip lines
    lines = [k for k in lines if not k.startswith('-')]
    lines = [k for k in lines if not k.startswith('=')]
    lines.reverse()

    # read description
    line = lines.pop()
    deck_name = ''
    while(not line.startswith('Crypt')):
        description += '%s\n' % line

        # Search for deck name
        name_search = re.search(r'deck name\s?:\s*([^\n]*)', line, re.IGNORECASE)
        if name_search:
            deck_name = name_search.group(1)

        line = lines.pop()
    description = description.strip()

    deck_name = deck_name.strip()

    if deck_name == '':
        raise Exception("Deck name not found")

    line = lines.pop() # skip crypt line

    # read vamps
    while(line != ''):
        (count, name) = parse_vampire(line)
        vamp_set.add(name)
        vamps[name] = count
        line = lines.pop()

    if not len(vamps):
        raise Exception("No vampires parsed!")

    # skip library line
    while(not line.startswith('Library')):
        line = lines.pop()
    line = lines.pop()

    # read library sections
    while(len(lines)):
        if(line == ''):
            # empty line, remove and restart
            line = lines.pop()
            continue

        # remove section header
        line = lines.pop()

        # read cards until end of section
        while(line != ''):
            elements = line.split(None, 1)

            count = int(elements[0].replace('x', ''))
            name = elements[1].strip()
            lib_set.add(name)

            lib[name] = count
            if(len(lines)):
                line = lines.pop()
            else:
                break

    if not len(lib):
        raise Exception("No library cards parsed!")

    cards = {}
    for key in vamps:
        card_id = id_from_name(key, carddb)
        if card_id is None:
            raise Exception("Failed to match card %s" % key)
        cards[card_id] = vamps[key]

    for key in lib:
        card_id = id_from_name(key, carddb)
        if card_id is None:
            raise Exception("Failed to match card %s" % key)
        cards[card_id] = lib[key]

    return {'description': description, 'crypt':  vamps, 'library': lib, 'cards': cards, 'name': deck_name}


with open(sys.argv[1], "r") as text_file:
    carddb = json.load(text_file)

response = urlopen('http://www.vekn.fr/decks/twd.htm')
html = response.read()

soup = BeautifulSoup(html)
pres = soup.find_all('pre')

vamp_set = set()
lib_set = set()
tries = 0
fails = 0
decks = []
failed_decks = []
for pre in pres:
    s = pre.string
    tries += 1
    try:
        deck = extract_deck(s, carddb)
        decks.append(deck)
    except:
        failed_decks.append(s)
        fails += 1

json_string = json.dumps(decks, sort_keys=True, indent=4, separators=(',', ': '))
with open("decks.json", "w") as text_file:
    text_file.write(json_string)

json_string = json.dumps(failed_decks, sort_keys=True, indent=4, separators=(',', ': '))
with open("failed.json", "w") as text_file:
    text_file.write(json_string)

print('Done!\nCount: %i, fails %i. Unique vamps: %i, libs: %i' %
      (tries-fails, fails, len(vamp_set), len(lib_set)))
