#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: Giang Le (gianghl2@illinois.edu)
This script tokenizes Japanese using fugashi, a wrapper for MeCab Japanese morphological analyzer.
This script needs to be refactored later.
"""
import re
import os
import sys
import fugashi
import ipadic
import argparse

parser = argparse.ArgumentParser(description='Tool to tokenize Japanese data using fugashi.')
parser.add_argument('--input', type=str, required=True,
    help='File with Japanese text')
parser.add_argument('--output', type=str, required=True,
    help='Destination file')
args = parser.parse_args()


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
            
print("Tokenizing Japanese " + args.input + " data")
lines_list = create_lines(args.input)
lines_to_write = tokenize(lines_list)
for l in lines_to_write:
    print(l)
write_lines(lines_to_write, args.output)
print("Done!")
