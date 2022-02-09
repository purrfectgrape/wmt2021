# This script finds the most likely translation of a list of words based on frequency from a dictionary
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Giang Le

import pickle
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser(description='Look up possible translation of a word')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input', type=str, required=True,
    help='Infile for annotation')
parser.add_argument('--output', type=str, required=True,
    help='Phrase table output')
args = parser.parse_args()

with open(args.input, 'rb') as infile:
    ner_dict = pickle.load(infile)

# create a set of src words from ner_dict keys.
words_set = set()
for value in ner_dict.values():
    for tup in value:
        words_set.add(tup[0])

print(len(words_set))

def count(mylist):
    freq = {}
    for item in mylist:
        if item in freq:
            freq[item] += 1
        else:
            freq[item] = 1
    return freq

#translations = defaultdict(list)
#for word in list(words_set)[:args.nb_words]:
#    for value in ner_dict.values():
#        for tup in value:
#            if word.lower() == tup[0].lower():
#                translations[word].append(tup[1])

translations = defaultdict(list)
for value in ner_dict.values():
    for tup in value:
        translations[tup[0]].append(tup[1])
print(translations)

with open(args.output, 'wt', encoding='utf8') as out:
    for word in translations.keys():
        best = max(count(translations[word]), key = lambda x : count(translations[word])[x])
        print(word + ' ||| ' + best + '\n')
        out.write(word + ' ||| ' + best + '\n')

