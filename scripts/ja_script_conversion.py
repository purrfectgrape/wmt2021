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
from collections import defaultdict

current = os.getcwd()
data_dir = os.getcwd() + "/data/"

if not len(sys.argv) == 2:
    raise SystemExit("Usage: {} type".format(sys.argv[0]))

if not ("train-bl" in sys.argv[1] or "test-bl" in sys.argv[1] or "dev-bl" in sys.argv[1] or "train-exp" in sys.argv[1] or "test-exp" in sys.argv[1] or "dev-exp" in sys.argv[1]
    or "train-para-bl" in sys.argv[1] or "test-para-bl" in sys.argv[1] or "dev-para-bl" in sys.argv[1] or "train-para-exp" in sys.argv[1] or "test-para-exp" in sys.argv[1] or "dev-para-exp" in sys.argv[1]):
    raise SystemExit("Type of file must be train-bl, dev-bl, test-bl, train-exp, dev-exp, or test-exp, and para equivalents")

def create_lines(file):
    lines = []
    with open(file, "r", encoding='utf-8') as infile:
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
# This step is performed after tokenization has been applied.
ja_lines = create_lines(data_dir + sys.argv[1] + "-ja-tok.txt")
sents = convert(ja_lines)
write_to_file(sents,data_dir + sys.argv[1] + "-ja-romaji.txt", "hepburn")
write_to_file(sents,data_dir + sys.argv[1] + "-ja-hiragana.txt", "hira")
