"""
This script downloads all high-res card images from LackeyCCG.

Uses Python 3.5.
"""
import os

from bs4 import BeautifulSoup
import requests


BASE_URL = 'http://www.lackeyccg.com'
LISTING = BASE_URL + '/vtes/high/cards/'


def url2filename(url):
    if url.find('/'):
        return url.rsplit('/', 1)[1]
    return 'unknown_file_name'


def main():
    r = requests.get(LISTING)
    if r.status_code != 200:
        print('Error while listing file dir.')
        exit(-1)

    soup = BeautifulSoup(r.text, 'html.parser')
    links = soup.find_all('a')

    # First link is a link to top level, not pictures
    links = links[1:]

    os.mkdir('downloads')
    for link in links:
        url = LISTING + link['href']
        r = requests.get(url, allow_redirects=True)
        filename = 'downloads/%s' % url2filename(url)
        with open(filename, 'wb') as f:
            print('Writing %s to %s' % (url, filename))
            f.write(r.content)


if __name__ == '__main__':
    main()
