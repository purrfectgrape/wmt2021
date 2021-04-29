#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import spacy

nlp = spacy.load('en_core_web_sm')

nl = 0
with open('data/alignment/fast_align_sample.en', 'rt', encoding='utf8') as file_en:
    with open('data/alignment/fast_align_sample.ja', 'rt', encoding='utf8') as file_ja:
        with open('data/alignment/forward.enja.align', 'rt') as file_align:
            ij_dict = {}
            while nl < 100000:
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
