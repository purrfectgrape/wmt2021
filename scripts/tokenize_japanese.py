#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
This script tokenizes Japanese using fugashi, a wrapper for MeCab Japanese morphological analyzer.
"""
import re
import os
import sys
import fugashi
import ipadic

current = os.getcwd()
data_dir = os.getcwd() + "/data/raw/"

if not len(sys.argv) == 2:
    raise SystemExit("Usage: {} type".format(sys.argv[0]))

if not ("dev/newsdev2020-filtered" in sys.argv[1] or "reuters" in sys.argv[1] or "paracrawl" in sys.argv[1] or "wikimatrix" in sys.argv[1] or "newscommentary" in sys.argv[1] or "corpus_mid" in sys.argv[1]):
    raise SystemExit("Type of file must be dev/newsdev2020-filtered, reuters, wikimatrix, newscommentary, paracrawl, or corpus_mid")

def create_lines(file):
    lines = []
    with open(file, "r", encoding='utf-8') as infile:
        lines = [line for line in infile.readlines() if line.strip()]
    return lines

def tokenize(lines):
    tagger = fugashi.GenericTagger(ipadic.MECAB_ARGS + ' -Owakati')
    for i, line in enumerate(lines):
        lines[i] = tagger(line) # tagger(line) is a list of fugashi nodes
        print(lines[i])
    return lines
    
def write_lines(lines, file):
    with open(file, "w") as outfile:
        lines_tokenized = []
        new_line = ""
        for line in lines:
            outfile.write(" ".join([token.surface for token in line]) + "\n")
            
            
print("Tokenizing Japanese " + sys.argv[1] + " data")
lines_list = create_lines(data_dir + sys.argv[1] + ".ja")
lines_to_write = tokenize(lines_list)
for l in lines_to_write:
    print(l)
write_lines(lines_to_write, data_dir + sys.argv[1] + "-tok.ja")
print("Done!")
