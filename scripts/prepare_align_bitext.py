#!/usr/bin/env python3
# -*- coding: utf-8 -*-

num_lines = sum(1 for line in open('data/alignment/fast_align.en.sp'))
nl = 0
with open('data/alignment/fast_align.en.sp', 'rt', encoding='utf8') as file_en:
    with open('data/alignment/fast_align.ja.sp', 'rt', encoding='utf8') as file_ja:
        with open('data/alignment/fast_align.bitext.sp', 'wt', encoding='utf8') as out:
            while nl < num_lines:
                line_en = file_en.readline()
                line_ja = file_ja.readline()
                out.write(line_en.strip() + ' ||| ' + line_ja.strip() + '\n')
                nl+=1
print('Done!')
