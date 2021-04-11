#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
"""
import pykakasi
import re
import os
import sys
import ipadic
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser(description='Tool to convert Japanese mixed orthography to hiragana or romaji')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--infile', type=str, required=True,
    help='input file in mixed Japanese orthography')
parser.add_argument('--outfile', type=str, required=True,
    help='output file')
parser.add_argument('--to_type', type=str, required=True,
    help='orthographic type in the outfile, either hira or hepburn(romaji)')
parser.add_argument('--nb_sents', type=int, default=9999999999,
    help='Maximal number of sentences')

args = parser.parse_args()

print('Tool to convert Japanese mixed orthography to hiragana or romaji')

def create_lines(file):
    lines = []
    with open(file, "r", encoding=args.encoding) as infile:
        lines = [line for line in infile.readlines() if line.strip()]
    return lines
    
kks = pykakasi.kakasi()
def convert(lines):
    sents_dict = defaultdict(list)
    for i, line in enumerate(lines):
        converted = kks.convert(line)
        for token in converted:
            sents_dict[i].append(token)
    return(sents_dict)

def write_to_file(sents, file, type):
    with open(file, "w") as outfile:
        for v in sents.values():
            for token in v:
                outfile.write(token[type])

# Transform the raw data to different script types (romaji or hiragana)
nl = 0
with open(args.infile, 'rt', encoding=args.encoding) as infile:
    with open(args.outfile, 'wt', encoding=args.encoding) as outfile:
        while nl < args.nb_sents:
            line = infile.readline()
            if not line:
                break
            converted = kks.convert(line)
            sents_list = []
            for token in converted:
                sents_list.append(token[args.to_type].strip())
            outfile.write(''.join(sents_list) + '\n')
            nl += 1
            if nl % 100000 == 0:
                print('\r - {:d} lines read'.format(nl), end='')

print('\r - wrote {:d} lines'.format(nl))

#ja_lines = create_lines(args.infile)
#sents = convert(ja_lines)
#if args.to_type == 'hiragana':
#    write_to_file(sents, args.outfile, 'hira')
#elif args.to_type == 'romaji':
#    write_to_file(sents, args.outfile, 'hepburn')
#else:
#    print('Wrong type choices')