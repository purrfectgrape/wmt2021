#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: Giang Le
"""

import re
import os
import sys

#os.chdir("..")
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
            if float(k[1]) > 0.730:
                out.write("{}\t{}\n".format(k[0], sents_dict[k]))

# Create a list of Japanese sentences and English sentences
def create_sent_lists(filename):
    ja_sents = []
    en_sents = []
    with open(filename) as infile:
        for line in infile:
            # Skip blank lines.
            if line.rstrip():
                en_sents.append(line.strip().split("\t")[0])
                ja_sents.append(line.strip().split("\t")[1])
        return ja_sents, en_sents

def write_to_separate(filename, sent_list):
    with open(filename, "w") as outfile:
        for sent in sent_list:
            outfile.write(sent + "\n")

if __name__ == "__main__":
    ja_outfile = sys.argv[2]
    en_outfile = sys.argv[3]
    mydict = create_dict(sys.argv[1])
    tmp_file = data_dir + "/tmp"
    write_to_file(tmp_file, mydict)
    ja_sents, en_sents = create_sent_lists(tmp_file)
    write_to_separate(ja_outfile, ja_sents)
    write_to_separate(en_outfile, en_sents)
    os.remove(tmp_file)
