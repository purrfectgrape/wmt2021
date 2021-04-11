#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Date: Mar 10, 2021
Adapted from https://github.com/facebookresearch/LASER/blob/master/tasks/WikiMatrix/extract.py
This script samples a subset of sentence pairs from two parallel corpora.
Usage: python3 scripts/sample_train_corpus.py
"""

import re
import os
import sys
import argparse

parser = argparse.ArgumentParser(description='Tool to sample a subset of sentence pairs from two parallel corpora.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--txt', type=str, required=True,
    help='Filename of one corpus in a parallel corpus, excluding language extension')
parser.add_argument('--bitext', type=str, required=True,
    help='Text file after sentence splitting')
parser.add_argument('--nb-sents', type=int, default=999999999,
    help='Maximal number of sentences')
args = parser.parse_args()

print('Tool to sample a subset of sentence pairs from two parallel corpora.')

if __name__ == "__main__":
    nl = 0
    print('Processing {}'.format(args.txt))
    with open(args.txt + '.en', 'rt', encoding=args.encoding) as txt_en:
        with open(args.txt + '.ja', 'rt', encoding=args.encoding) as txt_ja:
            with open(args.bitext + '.en' , 'wt', encoding=args.encoding) as file_en:
                with open(args.bitext + '.ja', 'wt', encoding=args.encoding) as file_ja:
                    while nl < args.nb_sents:
                        line_en = txt_en.readline()
                        line_ja = txt_ja.readline()
                        if not line_ja or not line_en:
                            break
                        if nl % 2 == 0:
                            file_en.write(line_en.strip() + '\n')
                            file_ja.write(line_ja.strip() + '\n')
                        nl += 1
                        if nl % 100000 == 0:
                            print('\r - {:d} lines read'.format(nl), end='')

print('\r - wrote {:d} lines'.format(nl))
