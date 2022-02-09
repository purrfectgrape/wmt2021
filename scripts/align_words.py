#!/usr/bin/env python3
# A script to align words from fast_align result
# Author: Giang Le (Jan 17, 2022)
# -*- coding: utf-8 -*-

import argparse
import json
from collections import defaultdict
import pickle

parser = argparse.ArgumentParser(description='Tool to align words from fast_align results.')

parser.add_argument('--encoding', default='utf-8',
            help='character encoding for input/output')
parser.add_argument('--input', type=str, required=True,
            help='path to input file')
parser.add_argument('--align_file', type=str, required=True,
            help='path to alignment file')
parser.add_argument('--nl', type=int, required=True,
            help='the number of lines to process')
parser.add_argument('--output', type=str, required=True,
            help='Ouput file for annotation')
args = parser.parse_args()

list_one = []
list_two = []
with open(args.input, 'r') as infile:
    for line in infile.readlines():
        list_one.append(line.split(' ||| ')[0].split())
        list_two.append(line.split(' ||| ')[1].split())

print('Done creating two lists')
word_pairs = defaultdict(list)
i = 0
j = 0
with open(args.align_file, 'r') as align_file:
    lines_in_align = align_file.readlines()
    while i < args.nl:
        nw = len(lines_in_align[i].split())
        while j < nw:
            en_index = int(lines_in_align[i].split()[j].split('-')[0])
            vi_index = int(lines_in_align[i].split()[j].split('-')[1])
            word_pairs[list_one[i][en_index].lower()].append(list_two[i][vi_index].lower())
            j+=1
        i+=1
        j = 0
        print('Processing line' + str(i))

# Count the occurrences of vi translations in the list:
word_pair_count = defaultdict()
for k, v_list in word_pairs.items():
    word_pair_count[k] = defaultdict()
    for item in v_list:
        word_pair_count[k][item] = v_list.count(item)
    
# Write to file
#with open(args.output, 'w', encoding=args.encoding) as outfile:
#    json.dump(word_pair_count, outfile, ensure_ascii=False)

with open(args.output, 'wb') as handle:
    pickle.dump(word_pair_count, handle, protocol=pickle.HIGHEST_PROTOCOL)
