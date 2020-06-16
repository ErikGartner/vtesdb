"""
This script downloads all high-res card images from LackeyCCG.

Uses Python 3.5.
"""
import os
from multiprocessing import Pool
import json

from bs4 import BeautifulSoup
import requests


LISTING = 'https://lackeyccg.com/vtes/high/cards/'


def url2filename(url):
    if url.find('/'):
        return url.rsplit('/', 1)[1]
    return 'unknown_file_name'


def download(args):
    url, cards = args
    r = requests.get(url, allow_redirects=True)
    filename = url2filename(url)

    # Use legacy card id if different for current id
    new_card_id = filename.replace('.jpg', '')

    if new_card_id not in cards:
        print('Card missing in card list: %s' % url)
        return

    filename = cards[new_card_id]['card_id'] + '.jpg'
    path = 'downloads/%s' % filename
    with open(path, 'wb') as f:
        print('Writing %s to %s' % (url, path))
        f.write(r.content)


def main():
    r = requests.get(LISTING)
    if r.status_code != 200:
        print('Error while listing file dir.')
        exit(-1)

    soup = BeautifulSoup(r.text, 'html.parser')
    links = soup.find_all('a')

    # First link is a link to top level, not pictures
    links = links[1:]

    with open('../private/cards.json', 'r') as f:
        cards = json.load(f)
        cards = {card['new_card_id']: card for card in cards}

    os.mkdir('downloads')
    urls = [(LISTING + link['href'], cards) for link in links]
    with Pool(4) as p:
        p.map(download, urls)


if __name__ == '__main__':
    main()
