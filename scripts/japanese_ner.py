import argparse
from pororo import Pororo
import pickle

parser = argparse.ArgumentParser(description='NER tagger for Japanese')
parser.add_argument('--corpus', type=str, required=True,
    help='Japanese corpus to tag')
parser.add_argument('--output', type=str, required=True,
    help='Output file name')
parser.add_argument('--output_raw', type=str, required=False,
    help='Raw tageged output file name')
parser.add_argument('--dictionary', type=str, required=False,
    help='Dictionary file name')
parser.add_argument('--num_sentences', type=int, required=False,
help='Number of sentences to tag')
args = parser.parse_args()

ner = Pororo(task="ner", lang="ja")

tag_map = {'PERSON' :'PERSON', 'LOCATION':'LOC', 'TIME':'TIME', 'DATE':'DATE', 'ORGANIZATION':'ORG', 'MONEY':'MONEY'}#pororo -> spacy
with open(args.corpus, 'r') as f:
    text = f.readlines()

text = text[:args.num_sentences]
sentences = []
sentences2 = []
dictionary = {}
for line in text:
    pred = ner.predict(line)
    sentence = []
    sentence2 = []
    for p in pred:
        if p[1] !=  'O':
            if p[1] in tag_map:
                sentence.append('｟' + tag_map[p[1]] + '｠')
                sentence2.append('｟' + p[0] + ' : ' + tag_map[p[1]] + '｠')
                if p[0] not in dictionary:
                    dictionary[p[0]] = tag_map[p[1]]
        else:
            sentence.append(p[0])
            sentence2.append(p[0])
    sentences.append(' '.join(sentence))
    sentences2.append(' '.join(sentence2))
with open(args.output,  mode='wt', encoding='utf-8') as f:
    f.write('\n'.join(sentences))

with open(args.output_raw,  mode='wt', encoding='utf-8') as f:
    f.write('\n'.join(sentences2))
# print(dictionary.keys())
# print(dictionary.values())

with open(args.dictionary, 'wb') as handle:
    pickle.dump(dictionary, handle, protocol=pickle.HIGHEST_PROTOCOL)

print('DONE!')

