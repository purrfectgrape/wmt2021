#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: Giang Le
Date: Mar 10, 2021
Script to extract text from TED's XML files
"""
import tarfile
import os
import sys
import glob
import argparse
from bs4 import BeautifulSoup
import bs4

parser = argparse.ArgumentParser(description='Tool to extract bitext from TED')
parser.add_argument('--enja', type=str, required=True,
    help='zipped file of en-ja bitext')
parser.add_argument('--jaen', type=str, required=True,
    help='zipped file of ja-en bitext')
parser.add_argument('--out_dir', type=str, required=True,
    help='directory of the unzipped data')
args = parser.parse_args()

print('Tool to extract bitext from Ted Talks')

with tarfile.open(args.enja) as tar:
    tar.extractall(path=args.out_dir)

with tarfile.open(args.jaen) as tar:
    tar.extractall(path=args.out_dir)

# Get text from files in the en-ja/ director
def create_docs_list(directory, lang):
    docs_list = []
    for infile in glob.glob(os.path.join(directory, '*/train.tags*' + lang)):
        soup = BeautifulSoup(open(infile, 'r').read())
        for content in soup.contents:
            if isinstance(content, bs4.element.Tag):
                docs_list.append(content.findAll(text=True,recursive=False))
    return docs_list

def write_lines(directory, docs, lang):
    with open(directory + '/ted.' + lang, 'wt') as outfile:
        for doc in docs:
            for sent in doc:
                if sent != '\n':
                    outfile.write(sent.strip() + '\n')

if __name__ == "__main__":
    langs = ['en', 'ja']
    for lang in langs:
        docs = create_docs_list(args.out_dir, lang)
        write_lines(args.out_dir, docs, lang)

    print('Done. Check your extracted data in ' + args.out_dir)



