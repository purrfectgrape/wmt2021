# This script finds the most likely translation of a list of words based on frequency from a dictionary
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Giang Le

import pickle
import argparse

parser = argparse.ArgumentParser(description='Tool to annotate NERs using SpaCy.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input', type=str, required=True,
    help='Infile for annotation')
parser.add_argument('--output', type=str, required=True,
    help='Ouput file for annotation')
args = parser.parse_args()

with open(args.input, 'rb') as infile:
    ner_dict = pickle.load(infile)

def count(mylist):
    freq = {}
    for item in mylist:
        if item in freq:
            freq[item] += 1
        else:
            freq[item] = 1
    return freq

translations = []
for key in ner_dict.keys():
    if key == 'LOC':
        for value in ner_dict[key]:
            if value[0] == 'Tokyo':
                    translations.append(value[1])

print(count(translations))
