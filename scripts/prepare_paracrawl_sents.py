#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
"""

import re
import os
import sys

data_dir = os.getcwd() + "/data"

if not len(sys.argv) == 4:
    raise SystemExit("Usage: {} input_file ja_outfile en_outfile".format(sys.argv[0]))

if not "paracrawl-en-ja.txt" in sys.argv[1]:
    raise SystemExit("The first parameter contains paracrawl-en-ja.txt")

# The paracrawl raw corpus contains 4 columns of text
# Column 1: Name of website
# Column 2: Alignment confidence score
# Column 3: English sentences
# Column 4: Japanese sentences.

# Create a dictionary, using the English as key.
def create_sent_lists(filename):
    ja_sents = []
    en_sents = []
    with open(filename) as infile:
        for line in infile:
            ja_sents.append(re.findall(r"<J>(.*?)</J>", line))
            en_sents.append(re.findall(r"<E>(.*?)</E>", line))
        return ja_sents, en_sents

def write_to_file(filename, sent_list):
    with open(filename, "w") as outfile:
        for sent in sent_list:
            for s in sent:
                outfile.write(s + "\n")
    
ja_outfile = sys.argv[2]
en_outfile = sys.argv[3]
ja_sents, en_sents = create_sent_lists(sys.argv[1])
write_to_file(ja_outfile, ja_sents)
write_to_file(en_outfile, en_sents)
