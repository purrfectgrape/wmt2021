#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import spacy

nlp = spacy.load('en_core_web_sm')

def annotate_ner(doc):
    ents_dict = {}
    for ent in doc.ents:
        ents_dict[ent.text] = (ent.start_char, ent.end_char, ent.label_)
    return ents_dict

nl = 0
with open('data/train/preprocessed/wmt2021-bitext-shuffled.en', 'rt', encoding='utf8') as file_en:
    with open('data/train/preprocessed/wmt2021-bitext-shuffled-annotated.en', 'wt', encoding='utf8') as file_out:
        while nl < 100:
            doc = nlp(file_en.readline())
            i = 0
            str_list = []
            while i < len(doc.text):
                for value in annotate_ner(doc).values():
                    if i == value[0]:
                        str_list.append('『'+doc.text[i:value[1]]+'』_'+value[2])
                        i+=int(value[1])-int(value[0])
                        continue
                str_list.append(doc.text[i])
                i+=1
            file_out.write(''.join(str_list))
            nl+=1

        

