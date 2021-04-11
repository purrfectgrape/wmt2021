#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale

# Politeness and formality tagger for English -> Japanese translation.
"""
from __future__ import division
import Mykytea
import os
import sys
import argparse
import re
import difflib


###############################################################################
#
# Main
#
###############################################################################

parser = argparse.ArgumentParser(description='Tool to tag formality and politeness levels to Japanese/English data.')
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
            'ました',
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
          #  'い',  # risky?
            'くて',     # i-adj endings
            'くない',
            'くなかった',
            'かった',
            'かろう',
            'かったろう',
            'ない',  # might be risky?
            'なかった',
            'こない', # kuru endings
            'こい',
            'こよう',
            'する',   # suru endings
            'しない',
            'しろ',
            'しよう',
          #  'した',   # caused double tagging with ました
            'できる',
            'たろう',
            'しまう',
            'しまった',
            'られる',
            'される',
            'させる',
            'させられる',
            'られた',
            'された',
            'させた',
            'させられた',
            'われる',
            'ている',
            'いる',
            'いた',
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

verb_and_tail_tags = set(['動詞', '語尾', '助動', '助動詞'])
adj_and_tail_tags = set(['形容詞','語尾'])
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
            elif (token.split('/')[1] == '形容詞' and token.split('/')[0] != 'あ'):
                verb_ending =  ''.join(token for triples in mk.getTagsToString(line_ja).strip().split()[index::] for token in triples.split('/')[0] if triples.split('/')[1] in adj_and_tail_tags)
                return verb_ending
            else:
                index -= 1
        except IndexError:
            pass
    return verb_ending

# This is to eliminate the possiblity of double tagging. Find the longest match between the extracted ending and verb endings.

def longest_match(verb_ending, politeness_formality_mappings, line_ja):
    matches_dict = {}
    for key, endings in politeness_formality_mappings.items():
        for ending in endings:
            s = difflib.SequenceMatcher(None, ending, verb_ending)
            size_of_match = s.find_longest_match(0, len(ending), 0, len(verb_ending))[2]
            if size_of_match != 0:
                matches_dict[line_ja] = (verb_ending, ending, size_of_match)
    print(matches_dict)
    return matches_dict

def revised_write_tags(verb_ending, ending, line_ja, line_en, out_en):
    tagged = False
    matches = longest_match(verb_ending, politeness_formality_mappings)
    for match in matches:
        print(match)

def write_tags(verb_ending, politeness_formality_mappings, line_ja, line_en, out_en):
    tagged = False
    tag = ''
    for key, endings in politeness_formality_mappings.items():
        for ending in endings:
            if verb_ending.endswith(ending):
                out_en.write(re.sub('^', '<' + key + '> ', line_en).strip() + '\n')
                tagged = True
                tag = key
                print('TAGGED AS ' + key + ' || ' +  verb_ending + ' || ' + line_ja)
                break
        else:
            continue
    if tagged == False:
        print('NO TAG || ' + verb_ending + ' || ' + line_ja) 
        out_en.write(line_en.strip() + '\n')
    return (tagged, tag)

nl = 0
counts = ()
count_tagged = 0
count_untagged = 0
count_plain = 0
count_polite = 0
count_formal = 0
with open(args.corpus + '-pofo-tagged.en', 'wt') as out_en:
    with open(args.corpus + '.en', 'rt') as f_en:
        with open(args.corpus + '.ja', 'rt') as f_ja:
            while nl < args.nb_sents:
                line_en = f_en.readline()
                line_ja = f_ja.readline()
                if not line_ja:
                    break
                line_ja = clean_up(line_ja)
                verb_ending = extract_verb_ending(line_ja)
                counts += write_tags(verb_ending, politeness_formality_mappings, line_ja, line_en, out_en)
                nl += 1

for i in counts:
    if i == True:
        count_tagged += 1
    elif i == 'plain':
        count_plain += 1
    elif i == 'polite':
        count_polite += 1
    elif i == 'formal':
        count_formal += 1
    elif i == False:
        count_untagged += 1

print('Number of lines tagged: ' + str(count_tagged))
print('Percentage of lines tagged: ' + '{0:.2f}%'.format(count_tagged/args.nb_sents * 100))
print('Number of lines untagged: ' + str(count_untagged))
print('Percentage of lines untagged: ' + '{0:.2f}%'.format(count_untagged/args.nb_sents * 100))
print('Percentage of lines tagged plain: ' + '{0:.2f}%'.format(count_plain/args.nb_sents * 100))
print('Percentage of lines tagged polite: ' + '{0:.2f}%'.format(count_polite/args.nb_sents * 100))
print('Percentage of lines tagged formal: ' + '{0:.2f}%'.format(count_formal/args.nb_sents * 100))

if sum(1 for line in open(args.corpus + '-pofo-tagged.en')) != args.nb_sents:
    print('WARNING!!! Lines count in ' +  args.corpus + '-pofo-tagged.en' + ' is not equal to args.nb_sents!!. Likely due to double tagging.')
else:
    print('Line count as expected! Check file ' + args.corpus + '-pofo-tagged.en')

