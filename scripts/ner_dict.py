#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Giang Le
# This script matches annotated named entities from bitext data.

import argparse
import re
from collections import defaultdict
import pickle

parser = argparse.ArgumentParser(description='Tool to annotate NERs using SpaCy.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input_en', type=str, required=True,
    help='Infile for annotation')
parser.add_argument('--input_ja', type=str, required=True,
    help='Infile for annotation')
parser.add_argument('--output', type=str, required=True,
    help='Ouput file for annotation')
parser.add_argument('--nb_sents', type=int, default=999999999,
    help='Maximal number of sentences')
args = parser.parse_args()

nl = 0
ner_dict = defaultdict(list)
with open(args.input_en, 'rt', encoding=args.encoding) as file_en:
    with open(args.input_ja, 'rt', encoding=args.encoding) as file_ja:
        while nl < args.nb_sents:
            line_en = file_en.readline()
            line_ja = file_ja.readline()
            ner_list_en = re.findall(r'｟(.*?)｠', line_en)
            ner_list_ja = re.findall(r'｟(.*?)｠', line_ja)
            for ner_en in ner_list_en:
                for ner_ja in ner_list_ja:
                    if ner_en.split('：')[0] == ner_ja.split('：')[0]:
                        ner_dict[ner_en.split('：')[0]].append((ner_en.split('：')[1],ner_ja.split('：')[1]))
            nl+=1

with open(args.output, 'wb') as outfile:
    pickle.dump(ner_dict, outfile)
