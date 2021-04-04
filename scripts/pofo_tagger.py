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
nl = 0
with open(args.corpus + '-pofo-tagged.en', 'wt') as out_en:
    with open(args.corpus + '.en', 'rt') as f_en:
        with open(args.corpus + '.ja', 'rt') as f_ja:
            while nl < args.nb_sents:
                line_en = f_en.readline()
                line_ja = f_ja.readline()
                line_ja = line_ja.replace('\\ /補助記号/UNK', '') # remove spaces
                # Going through the line token by token in backward order.
                nb_tokens = len(mk.getTagsToString(line_ja).strip().split())
                index = nb_tokens-1
                for token in mk.getTagsToString(line_ja).strip().split()[::-1]:
                    try:
                        # である case. Here で is tagged as 助動詞.
                        if (token.split('/')[1] == '動詞' and
                                token.split('/')[0] == 'あ' and
                                mk.getTagsToString(line_ja).strip().split()[index-1].split('/')[0] =='で'):
                            verb_endings = ''.join(token for triples in mk.getTagsToString(line_ja).strip().split()[index-1::] for token in triples.split('/')[0] if triples.split('/')[1] != punc_tag)
                            for key, endings in politeness_formality_mappings.items():
                                for ending in endings:
                                    if verb_endings.endswith(ending):
                                        print(key + ' || ' + verb_endings + ' || ' + line_ja.strip())
                                        out_en.write(re.sub('^', '<' + key + '> ', line_en).strip() + '\n')
                                        nl += 1
                                        break
                            index -= 1
                            break
                        # The other cases. Need to refactor for readability.
                        elif token.split('/')[1] == '動詞' and token.split('/')[0] != 'あ':
                            verb_endings = ''.join(token for triples in mk.getTagsToString(line_ja).strip().split()[index::] for token in triples.split('/')[0] if triples.split('/')[1] != punc_tag)
                            for key, endings in politeness_formality_mappings.items():
                                for ending in endings:
                                    if verb_endings.endswith(ending):
                                        print(key + ' || ' + verb_endings + ' || ' + line_ja.strip())
                                        out_en.write(re.sub('^', '<' + key + '> ', line_en).strip() + '\n')
                                        nl += 1
                                        break
                            index -= 1
                            break
                    except (IndexError):
                        pass
                    index -= 1
                out_en.write(line_en.strip() + '\n')
                nl += 1
                



