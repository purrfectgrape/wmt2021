#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Giang Le

import re
import argparse

parser = argparse.ArgumentParser(description='Tool to annotate NERs using SpaCy.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input', type=str, required=True,
    help='Infile for annotation')
parser.add_argument('--output', type=str, required=True,
    help='Ouput file for annotation')
parser.add_argument('--nb_sents', type=int, default=999999999,
    help='Maximal number of sentences')
args = parser.parse_args()
nl = 0
with open(args.input, 'rt', encoding=args.encoding) as infile:
    with open(args.output, 'wt', encoding=args.encoding) as outfile:
        while nl < args.nb_sents:
            line = infile.readline()
            outfile.write(re.sub(r'(｟[A-Z]{3,6})：(\s|[^ ｠])*(｠)', r'\1\3', line))
            nl+=1
print("Done normalizing!")
