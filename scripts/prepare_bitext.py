#!/usr/bin/env python3
# -*- coding: utf-8 -*-

nl = 0
with open('data/alignment/fast_align_sample.en', 'rt', encoding='utf8') as file_en:
    with open('data/alignment/fast_align_sample.ja', 'rt', encoding='utf8') as file_ja:
        with open('data/alignment/fast_align_sample.bitext', 'wt') as out:
            while nl < 4000000:
                line_en = file_en.readline()
                line_ja = file_ja.readline()
                out.write(line_en.strip() + ' ||| ' + line_ja.strip() + '\n')
                nl+=1
print('Done!')
