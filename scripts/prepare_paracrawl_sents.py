#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
"""

import re
import os
import sys

data_dir = os.getcwd() + "/data"

if not len(sys.argv) == 3:
    raise SystemExit("Usage: {} input_file output_file".format(sys.argv[0]))

if not "paracrawl-en-ja.txt" in sys.argv[1]:
    raise SystemExit("The first parameter contains paracrawl-en-ja.txt")

# The paracrawl raw corpus contains 4 columns of text
# Column 1: Name of website
# Column 2: Alignment confidence score
# Column 3: English sentences
# Column 4: Japanese sentences.

# Create a dictionary, using the English and score as key, the value will the Japanese counterpart.
def create_dict(filename):
    d = {}
    with open(filename) as infile:
        for line in infile:
            (web, score, en, ja) = line.split("\t")
            d[(en, score, web)] = ja
    return d

# Choose only the best aligned sentence pairs to write to file.
def write_to_file(outfile, sents_dict):
    with open(outfile,"w") as out:
        for k in sents_dict.keys():
            if float(k[1]) > 0.790:
                out.write(k[0] + "\t" + sents_dict[k] + "\n")
    
if __name__ == "__main__":
    outfile = sys.argv[2]
    mydict = create_dict(sys.argv[1])
    write_to_file(outfile, mydict)
