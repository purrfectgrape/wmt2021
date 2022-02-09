import os
import regex as re
import numpy as np
import operator
from collections import Counter
import argparse

parser = argparse.ArgumentParser(description='Tool for simple n best reranking')
parser.add_argument('--input_file', default='utf-8',
    help='file to rank')
parser.add_argument('--n_best', type=int, default=5,
    help='number of candidate sentences per source sentence')
parser.add_argument('--output_file', default='utf-8',
    help='file to write output to')

args = parser.parse_args()

with open(args.input_file, 'r') as file:
    lines = file.readlines()
    
splitter = lambda lines, n=args.n_best: [lines[i:i+n] for i in range(0, len(lines), n)]
sentences = splitter(lines)

best = []
tok = '｠|｟|▁|\n|。|、|？|！'
for chunk in sentences:
    score = {}
    for line in chunk:
        clean_line = re.sub(tok, '', line).split()
        d = len(set(clean_line))
        freq = list(Counter(clean_line).values())
        freq = np.prod(freq)
        score[line] = d/freq
        # print(d/freq)
    best_score = max(score.items(), key=operator.itemgetter(1))[0]
    best.append(best_score)
    
with open(args.output_file, 'w') as out:
    out.writelines(best)


