#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale

# Politeness and formality tagger for English -> Japanese translation.
"""
import Mykytea
import os
import sys
import argparse
import re

###############################################################################
#
# Main
#
###############################################################################

parser = argparse.ArgumentParser(description='Tool to extract bitext from the WikiMatrix')
parser.add_argument('--corpus', type=str, required=True,
    help='path to corpus with mined bitexts')
parser.add_argument('--nb_sents', type=int, default=9999999999,
    help='Maximal number of sentences')
args = parser.parse_args()

# You can pass arguments KyTea style like following
opt = "-deftag UNKNOWN!!"
# You can also set your own model
#opt = "-model /usr/local/share/kytea/model.bin"
mk = Mykytea.Mykytea(opt)

politeness_formality_mappings = {
        'polite':[
            'です',
            'ます',
            'でした',
            'ました'
            'まして',
            'ません',
            'でしょう',
            'ましょう',
            'なさい',
            'ください',
            'くださいませ',
            ],
        'plain': [
            'だ',     # N and na-adj endings
            'だった',
            'だろう',
            'そうだ',
            'ようだ',
            'じゃない',
            'ではない',
            'じゃなかった'
            'くて',     # i-adj endings
            'くない',
            'くなかった',
            'かった',
            'かろう',
            'かったろう',
            'ない',  # might be risky?
            'なかった',
            'こない',
            'こい',
            'こよう',
            'する',   # suru endings
            'しない',
            'しろ',
            'しよう',
            'できる',
            'たろう',
            'しまう',
            'られる',
            'される',
            'させる',
            'させられる',
            'られた',
            'された',
            'させた',
            'させられた',
            'ている',
            'いる',
            'ていた',
            ],
        'formal': [
            'である',
            'であろう',
            'であるだろう',
            'であった',
            'であったろう',
            'であっただろう',
            'であっている',
            'であっていた',
            'であれる',
            'であらせる',
            'であられる',
            'であらない',
            'であらないだろう',
            'であらなかった',
            'であらなかっただろう',
            'であれない',
            'であらせない',
            'であられない',
            ]
        }

verb_and_tail_tags = set(['動詞','語尾', '助動', '助動詞'])
punc_tag = '補助記号'

def clean_up(line_ja):
    line_ja = line_ja.replace('\\ /補助記号/UNK', '') # remove spaces
    line_ja = line_ja.replace('。/補助記号/。','') # remove final punctuation
    return line_ja

def extract_verb_ending(line_ja):
    nb_tokens = len(mk.getTagsToString(line_ja).strip().split())
    index = nb_tokens-1
    verb_ending = ''
    for token in mk.getTagsToString(line_ja).strip().split()[::-1]:
        try:
            if (token.split('/')[1] == '動詞' and token.split('/')[0] == 'あ' and mk.getTagsToString(line_ja).strip().split()[index-1].split('/')[0] =='で'):
                verb_ending = ''.join(token for triples in mk.getTagsToString(line_ja).strip().split()[index-1::] for token in triples.split('/')[0] if triples.split('/')[1] in verb_and_tail_tags)
                return verb_ending
            elif (token.split('/')[1] == '動詞' and token.split('/')[0] != 'あ'):
                verb_ending =  ''.join(token for triples in mk.getTagsToString(line_ja).strip().split()[index::] for token in triples.split('/')[0] if triples.split('/')[1] in verb_and_tail_tags)
                return verb_ending
            else:
                index -= 1
        except IndexError:
            pass
    return verb_ending

def write_tags(verb_ending, politeness_formality_mappings, line_en, out_en):
    tagged = False
    for key, endings in politeness_formality_mappings.items():
        for ending in endings:
            if verb_ending.endswith(ending):
                out_en.write(re.sub('^', '<' + key + '> ', line_en).strip() + '\n')
                tagged = True
                print(key + verb_ending)
                break
        break
    if tagged == False:
        out_en.write(line_en.strip() + '\n')
    return tagged

nl = 0
count = 0
with open(args.corpus + '-pofo-tagged.en', 'wt') as out_en:
    with open(args.corpus + '.en', 'rt') as f_en:
        with open(args.corpus + '.ja', 'rt') as f_ja:
            while nl < args.nb_sents:
                line_en = f_en.readline()
                line_ja = f_ja.readline()
                line_ja = clean_up(line_ja)
                verb_ending = extract_verb_ending(line_ja)
                count += write_tags(verb_ending, politeness_formality_mappings, line_en, out_en)
                nl += 1
print('Number of lines tagged: ' + str(count))
                
                                
                                



