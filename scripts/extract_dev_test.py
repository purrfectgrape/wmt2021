#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: Giang Le
Date: Mar 15, 2021
Script to extract text from WMT2020's dev and set.
"""
import tarfile
import os
import sys
import glob
import argparse
from bs4 import BeautifulSoup
import bs4

parser = argparse.ArgumentParser(description='Tool to extract text from WMT2020 devset')
parser.add_argument('--input_dir', type=str, required=True,
    help='input directory, such as data/wmt2021/dev/dev or data/wmt2021/test/sgm')
parser.add_argument('--direction', type=str, required=True,
    help='translation direction jaen or enja')
parser.add_argument('--src', action='store_true',
    help='whether the data being handled is the source or target language')
parser.add_argument('--tgt', action='store_true',
    help='whether the data being handled is the source or target language')
parser.add_argument('--out_dir', type=str, required=True,
    help='directory of the cleaned data')
parser.add_argument('--type', type=str, required=True,
    help='dev or test')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
args = parser.parse_args()

print('Tool to extract text from the WMT2020 dev and test set.')

if __name__ == "__main__":
    sents_list = []
    if args.src:
        with open(os.path.join(args.input_dir, 'news' + args.type + '2020-' + args.direction + '-src.' + ''.join(list(args.direction)[:2]) + '.sgm'), encoding=args.encoding) as infile:
            soup = BeautifulSoup(infile.read())
            seg = soup.find_all('seg')
            for sent in seg:
                sents_list.append(sent.text)
        with open(os.path.join(args.out_dir, 'news' + args.type + '2020-' + args.direction + '.' + ''.join(list(args.direction)[:2]) + '.sgm'), 'wt', encoding=args.encoding) as outfile:
            for sent in sents_list:
                outfile.write(sent + '\n')
        print('Done. Check the data in ' + args.out_dir)
    elif args.tgt:
        with open(os.path.join(args.input_dir, 'news' + args.type + '2020-' + args.direction + '-ref.' + ''.join(list(args.direction)[2:]) + '.sgm'), encoding=args.encoding) as infile:
            soup = BeautifulSoup(infile.read())
            seg = soup.find_all('seg')
            for sent in seg:
                sents_list.append(sent.text)
        with open(os.path.join(args.out_dir, 'news' + args.type + '2020-' + args.direction + '.' + ''.join(list(args.direction)[2:]) + '.sgm'), 'wt', encoding=args.encoding) as outfile:
            for sent in sents_list:
                outfile.write(sent + '\n')
        print('Done. Check the data in ' + args.out_dir)
