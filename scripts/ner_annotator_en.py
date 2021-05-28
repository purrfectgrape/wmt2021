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
parser.add_argument('--nb-sents', type=int, default=999999999,
    help='Maximal number of sentences')
args = parser.parse_args()
nlp = spacy.load('en_core_web_sm')

def annotate_ner(doc):
    ents_dict = {}
    for ent in doc.ents:
        ents_dict[ent.text] = (ent.start_char, ent.end_char, ent.label_)
    return ents_dict

nl = 0
with open(args.input, 'rt', encoding=args.encoding) as file_in:
    with open(args.output, 'wt', encoding=args.encoding) as file_out:
        while nl < args.nb_sents:
            doc = nlp(file_in.readline())
            i = 0
            str_list = []
            try:
                while i < len(doc.text):
                    for value in annotate_ner(doc).values():
                        if i == value[0]:
                            str_list.append('｟'+value[2]+'：'+doc.text[i:value[1]]+'｠')
                            i+=int(value[1])-int(value[0])
                            continue
                    str_list.append(doc.text[i])
                    i+=1
                file_out.write(''.join(str_list))
                nl+=1
            # The error below happens in extreme edge cases where the span is very short and near the end of the line. I decide to throw an error and fix these cases individually later.
            except IndexError:
                file_out.write(''.join(str_list))
                with open(args.input + '.errors', 'a', encoding=args.encoding) as file_err:
                    file_err.write('IndexError found in :' + ''.join(str_list))
print('\r - processed {:d} lines'.format(nl))
print("Done annotation. Check file in " + args.output)
        

