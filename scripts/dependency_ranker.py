# Tool for sanity check on dependency relations of the hypotheses
# -*- coding: utf-8 -*-
# Author: Giang Le

import argparse
from collections import defaultdict
import sys
from supar import Parser
#sys.path.insert(0, '//nas/models/experiment/ja-en/wmt2021/libraries/parser/supar')
#import Parser

parser = argparse.ArgumentParser(description='Sanity check tool on dependency relations of the hypotheses.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--input', type=str, required=True,
    help='In file consisting of translations for scoring')
parser.add_argument('--n_best', type=int, required=True,
    help='The number of hypotheses per line.')
parser.add_argument('--output', type=str, required=True,
    help='Dependency output')
parser.add_argument('--lang', type=str, required=True,
    help='Language')
args = parser.parse_args()

parses = []
if args.lang == 'en':
    parser = Parser.load('biaffine-dep-en')
    with open(args.input, 'rt', encoding=args.encoding) as infile:
        lines = infile.readlines()
    for line in lines:
        parses.append(parser.predict(line, lang=args.lang, prob=True, verbose=False))
    print('Done parsing')
    with open(args.output, 'wt', encoding=args.encoding) as outfile:
        for parse in parses:
            outfile.write(str(parse[0]))
else:
    pass
            
