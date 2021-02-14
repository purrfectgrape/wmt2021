#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
Script to reoder Japanese.
"""
import pykakasi
import re
import os
import sys
import ipadic
import spacy
from collections import defaultdict

current = os.getcwd()
data_dir = os.getcwd() + "/data/"

if not len(sys.argv) == 2:
    raise SystemExit("Usage: {} type".format(sys.argv[0]))

if not ("train" in sys.argv[1] or "test" in sys.argv[1] or "dev" in sys.argv[1] or "train-para" in sys.argv[1] or "test-para" in sys.argv[1] or "dev-para" in sys.argv[1]):
    raise SystemExit("Type of file must be train, dev, test, or train-para, dev-para, test-para")
    
# Apply MeCab morphological analyzer

def get_lines(file):
    with open(file, "r") as infile:
        lines = infile.readlines()
    return(lines)

def get_dependencies(text):
    nlp = spacy.load('ja_ginza')
    dep_dict = defaultdict(list)
    for line in text:
        doc = nlp(line)
        for sent in doc.sents:
            for token in sent:
                print(token)
                dep_dict[token.head].append(token.orth_)
    return(dep_dict)

# Simple rewrite that brings the head to the beginning of the phrase.
def rewrite(dep_dict, file):
    with open(file, "w") as outfile:
        for k, v in dep_dict.items():
            outfile.write(str(k) + "".join(v))
        
text = get_lines(data_dir + sys.argv[1] + "-ja-raw.txt")
dep = get_dependencies(text)
rewrite(dep, data_dir + sys.argv[1] + "-ja-reordered.txt")
