#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: Giang Le
Date: Mar 13, 2021
Script to concatenate files from kftt directory
"""
import tarfile
import os
import sys
import glob
import argparse

parser = argparse.ArgumentParser(description='Tool to concatenate kftt files')
parser.add_argument('--in_dir', type=str, required=True,
    help='directory of kftt files')
parser.add_argument('--type', type=str,
    help='orig or tok files', default='orig')
parser.add_argument('--out_dir', type=str, required=True,
    help='directory of concatenated data')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
args = parser.parse_args()

print('Tool to concatenate kftt files')


if __name__ == "__main__":
    out_ja = args.out_dir + '/kftt.ja'
    out_en = args.out_dir + '/kftt.en'
    if os.path.exists(out_ja):
        os.remove(out_ja)
    if os.path.exists(out_en):
        os.remove(out_en)
    print('Processing {} kftt'.format(args.type))
    corpora = ['kyoto-train', 'kyoto-tune', 'kyoto-dev', 'kyoto-test']
    langs = ['ja', 'en']
    for corpus in corpora:
        for lang in langs:
            with open(args.out_dir + '/kftt.' + lang, 'at', encoding=args.encoding) as outfile:
                with open(os.path.join(args.in_dir + '/' + args.type, corpus + '.' + lang), 'rt', encoding=args.encoding) as infile:
                    for line in infile:
                        outfile.write(line)
