
import json
import numpy as np
import argparse

parser = argparse.ArgumentParser(description='Tool to extract best sentence from n best sentences')

# num_sentence = 10
# filedir = '/home/shinkam2/ewstest2020-jaen.test.en.hyp_10/test_results.json'
# nbest = '/nas/models/experiment/ja-en/wmt2021/bert_lang_test/newstest2020-jaen.test.en.hyp_10.en'
# output = 'ewstest2020-jaen.test.en.hyp_10_nbest.en'

parser.add_argument('--input_file', default='utf-8', type=str,required=True,
    help='n best sentences to score and rank')
parser.add_argument('--nbest_sentences', default='utf-8', type=str,required=True,
    help='json file with scored n best sentences')
parser.add_argument('--nbest', type=int, required=False, default=10,
    help='number of n best sentences per sentence')
parser.add_argument('--output_file', type=str, required=True, 
    help='name of file to write output')
# %%
args = parser.parse_args()

# Opening JSON file
f = open(args.nbest_sentences,)
  
# returns JSON object as 
# a dictionary
data = json.load(f)

ppl = [d['ppl'] for d in data]
splitter = lambda lines, n=args.nbest: [lines[i:i+n] for i in range(0, len(lines), n)]
ppl_scores = splitter(ppl)

idx = 0
best_sentence_score = []
for score in ppl_scores:
    index_min = np.argmin(score)
    best_sentence_score.append(index_min+idx)
    idx += args.nbest
    
with open(args.input_file, 'r') as file:
    sentences = file.readlines()
best_sentences = [sentences[i] for i in best_sentence_score]

with open(args.output_file, 'w') as filehandle:
    for sentence in best_sentences:
        filehandle.write(str(sentence))



