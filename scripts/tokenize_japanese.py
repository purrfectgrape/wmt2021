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

def tokenize(lines):
    tagger = fugashi.GenericTagger(ipadic.MECAB_ARGS + ' -Owakati')
    #lines_tokenized = []
    for i, line in enumerate(lines):
        lines[i] = tagger(line) # tagger(line) is a list of fugashi nodes
        print(lines[i])
        #lines_tokenized.append(token.surface for token in tagger(line))
    #print(lines_tokenized)
    return lines
    
def write_lines(lines, file):
    with open(file, "w") as outfile:
        lines_tokenized = []
        new_line = ""
        for line in lines:
            outfile.write(" ".join([token.surface for token in line]) + "\n")
            
            #for token in line:
            
                #new_line += token.surface
                #print(new_line)
            
print("Tokenizing Japanese " + sys.argv[1] + " data")
if ("exp" in sys.argv[1]):
    lines_list = create_lines(data_dir + sys.argv[1] + "-ja-with-voice.txt")
    lines_to_write = tokenize(lines_list)
    for l in lines_to_write:
        print(l)
    write_lines(lines_to_write, data_dir + sys.argv[1] + "-ja-tok.txt")
elif ("bl" in sys.argv[1]):
    lines_list = create_lines(data_dir + sys.argv[1] + "-ja-raw.txt")
    lines_to_write = tokenize(lines_list)
    for l in lines_to_write:
        print(l)
    write_lines(lines_to_write, data_dir + sys.argv[1] + "-ja-tok.txt")
print("Done!")
