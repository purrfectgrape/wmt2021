#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import regex as re
import glob
import os
import pandas as pd
import glob
import sudachipy as su
from sudachipy import tokenizer
from sudachipy import dictionary
import argparse

parser = argparse.ArgumentParser(description='Tool to normalize Japanese text from WMT2021 data')
parser.add_argument('--input', type=str, required=True,
    help='input file, such as /nas/models/experiment/ja-en/wmt2021/data/train/raw/wmt2021-bitext-langid-filtered.ja')
parser.add_argument('--output', type=str, required=True,
    help='output file, where the normalized texts are written to')
args = parser.parse_args()

def remove_parens(line):
    reg = ' ?\([a-zA-Z ]*\) ?| ?\（[a-zA-Z ]*\） ?| ?「[a-zA-Z ]*」 ?| ?『[a-zA-Z ]*』 ?'
    new_line = re.sub(reg, '', line)
    return new_line

"""
Takes in a list of strings and normalizes katakna
"""
def normalize_katakana(line):
    tokenizer_obj = dictionary.Dictionary().create()
    mode = tokenizer.Tokenizer.SplitMode.A
    tokens = [m for m in tokenizer_obj.tokenize(line, mode)]
    new_tokens = []
    for token in tokens:
        if '名詞' in token.part_of_speech() and re.match(r'\p{Katakana}', str(token)):
            new_tokens.append(token.normalized_form())
        else:
            new_tokens.append(token.surface())
    new_line = ''.join(new_tokens)
    return new_line

with open(args.output, 'w') as output:
    with open(args.input) as input:
        for line in input.readlines():
            output.write(remove_parens(line.strip()) + '\n')

print('Done normalizing Japanese!')

