#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Giang Le

import spacy
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
parser.add_argument('--lang', type=str, required=True,
    help='Language for annotation')
args = parser.parse_args()

if args.lang == 'en':
    nlp = spacy.load('en_core_web_sm')
elif args.lang == 'ja':
    nlp = spacy.load('ja_core_news_sm')
    
def annotate_ner(doc):
    ents_dict = {}
    for ent in doc.ents:
        ents_dict[ent.text] = (ent.start_char, ent.end_char, ent.label_)
    return ents_dict

nl = 0
with open(args.input, 'rt', encoding=args.encoding) as file_in:
    with open(args.output, 'wt', encoding=args.encoding) as file_out:
        with open(args.output + '.full', 'wt', encoding=args.encoding) as file_out_full:
            while nl < args.nb_sents:
                doc = nlp(file_in.readline())
                i = 0
                str_list = []
                str_list_without_ents = []
                try:
                    while i < len(doc.text):
                        for value in annotate_ner(doc).values():
                            if i == value[0] and (value[2] == 'PERSON' or value[2] == 'DATE' or value[2] == 'TIME' or value[2] == 'MONEY' or value[2] == 'ORG'):
                                str_list.append('｟'+value[2]+'：'+doc.text[i:value[1]]+'｠')
                                str_list_without_ents.append('｟'+value[2]+'｠')
                                i+=int(value[1])-int(value[0])
                                continue
                            elif i == value[0] and (value[2] == 'LOC' or value[2] == 'GPE'):
                                str_list.append('｟'+'LOC'+'：'+doc.text[i:value[1]]+'｠')
                                str_list_without_ents.append('｟LOC｠')
                                i+=int(value[1])-int(value[0])
                                continue
                        str_list.append(doc.text[i])
                        str_list_without_ents.append(doc.text[i])
                        i+=1
                    file_out_full.write(''.join(str_list))
                    file_out.write(''.join(str_list_without_ents))
                    nl+=1
            # The error below happens in extreme edge cases where the span is very short and near the end of the line. I decide to throw an error and fix these cases individually later.
                except IndexError:
                    file_out_full.write(''.join(str_list))
                    file_out.write(''.join(str_list_without_ents))
                    with open(args.input + '.errors', 'a', encoding=args.encoding) as file_err:
                        file_err.write('IndexError found in :' + ''.join(str_list_without_ents) + '\n')
print('\r - processed {:d} lines'.format(nl))
print("Done annotation. Check file in " + args.output)
        
