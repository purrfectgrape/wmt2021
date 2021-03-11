#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Date: Mar 10, 2021
Adapted from https://github.com/facebookresearch/LASER/blob/master/tasks/WikiMatrix/extract.py
"""

import re
import os
import sys
import argparse

parser = argparse.ArgumentParser(description='Tool to extract bitext from paracrawl')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--txt', type=str, required=True,
    help='File with paracrawl bitext')
parser.add_argument('--bitext', type=str, required=True,
    help='Text file after sentence splitting')
parser.add_argument('--threshold', type=float, default=0.7,
    help='Threshold of alignment score')
parser.add_argument('--nb-sents', type=int, default=999999999,
    help='Maximal number of sentences')
parser.add_argument('--nb-words-en', type=int, default=999999999,
    help='Maxmimal numer of total words in en')
parser.add_argument('--nb-words-ja', type=int, default=999999999,
    help='Maxmimal numer of total words in ja')
args = parser.parse_args()

print('Tool to extract bitext from Paracrawl')

# The paracrawl raw corpus contains 4 columns of text
# Column 1: Name of website
# Column 2: Alignment confidence score
# Column 3: English sentences
# Column 4: Japanese sentences.

#TODO(gianghl2): Fuzzy deduplicate patterns in this dataset.
if __name__ == "__main__":
    nl = 0
    nw_en = 0
    nw_ja = 0
    print('Processing {}'.format(args.txt))
    with open(args.txt, 'rt', encoding=args.encoding) as txt:
        with open(args.bitext + '.en' , 'wt', encoding=args.encoding) as file_en:
            with open(args.bitext + '.ja', 'wt', encoding=args.encoding) as file_ja:
                while nl < args.nb_sents:
                    line = txt.readline()
                    if not line:
                        break
                    fields = line.split('\t')
                    curr_nw_en = len(fields[2].split())
                    curr_nw_ja = len(fields[3].split())
                    if float(fields[1]) < args.threshold:
                        break
                    if nw_en + curr_nw_en > args.nb_words_en:
                        break
                    if nw_ja + curr_nw_ja > args.nb_words_ja:
                        break
                    file_en.write(fields[2].strip() + '\n')
                    file_ja.write(fields[3].strip() + '\n')
                    nw_en += curr_nw_en
                    nw_ja += curr_nw_ja
                    nl += 1
                    if nl % 100000 == 0:
                        print('\r - {:d} lines read'.format(nl), end='')

print('\r - wrote {:d} lines'.format(nl))
print(' - with {:d} source and {:d} target words'.format(nw_en, nw_ja))
print(' - last threshold is {:.4f}'.format(float(fields[1])))
