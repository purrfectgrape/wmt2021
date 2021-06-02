#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse

parser = argparse.ArgumentParser(description='Tool to annotate NERs using SpaCy.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input_en', type=str, required=True,
    help='en-file')
parser.add_argument('--input_ja', type=str, required=True,
    help='ja-file')
parser.add_argument('--output', type=str, required=True,
    help='Ouput file for annotation')
args = parser.parse_args()

num_lines = sum(1 for line in open(args.input_en))
nl = 0
with open(args.input_en, 'rt', encoding='utf8') as file_en:
    with open(args.input_ja, 'rt', encoding='utf8') as file_ja:
        with open(args.output, 'wt', encoding='utf8') as out:
            while nl < num_lines:
                line_en = file_en.readline()
                line_ja = file_ja.readline()
                out.write(line_en.strip() + ' ||| ' + line_ja.strip() + '\n')
                nl+=1
print('Done!')
