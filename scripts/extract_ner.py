#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import spacy

nlp = spacy.load('en_core_web_sm')

parser = argparse.ArgumentParser(description='Tool to annotate NERs using SpaCy.')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
parser.add_argument('--file_en', type=str, required=True,
    help='English file with entities already annotated.')
parser.add_argument('--file_ja', type=str, required=True,
    help='Japanese file that have to be annotated for entities.')
parser.add_argument('--file_align', type=str, required=True,
    help='Alignment file between English and Japanese.')
parser.add_argument('--output', type=str, required=True,
    help='Ouput file for annotation')
parser.add_argument('--nb_sents', type=int, default=999999999,
    help='Maximal number of sentences')
args = parser.parse_args()

nl = 0
with open(args.file_en, 'rt', encoding='utf8') as file_en:
    with open(args.file_ja, 'rt', encoding='utf8') as file_ja:
        with open(args.file_align, 'rt') as file_align:
            ij_dict = {}
            while nl < args.nb_sents:
                line_en = file_en.readline()
                line_ja = file_ja.readline()
                line_align = file_align.readline()
                tokens_ja = line_ja.split()
                align = line_align.split()
                for ij in align:
                    ij_dict[ij.split('-')[0]] = ij.split('-')[1]
                doc = nlp(line_en)
                for ent in doc.ents:
                    for chunk in ent.noun_chunks:
                        chunk_len = chunk.end - chunk.start
                        try:
                            if chunk_len == 1:
                                print(chunk.text + '|' + tokens_ja[int(ij_dict[str(chunk.start)])])
                            elif chunk_len > 1:
                                s = ''
                                start = chunk.start
                                while chunk.end - start != 1:
                                    s += tokens_ja[int(ij_dict[str(start)])]
                                    start += 1
                        except KeyError:
                            print('\n')
                        except IndexError:
                            print('\n')
                nl+=1
