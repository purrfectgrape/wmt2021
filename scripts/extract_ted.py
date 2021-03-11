#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: Giang Le
Date: Mar 10, 2021
Script to extract text from TED's XML files
"""
import tarfile
import os
import sys
import argparse
from bs4 import BeautifulSoup

parser = argparse.ArgumentParser(description='Tool to extract bitext from TED')
parser.add_argument('--enja', type=str, required=True,
    help='zipped file of en-ja bitext')
parser.add_argument('--jaen', type=str, required=True,
    help='zipped file of ja-en bitext')

args = parser.parse_args()

print('Tool to extract bitext from Ted Talks')

with tarfile.open(args.enja)) as tar:
    tar.extractall(path='data/wmt2021/ted')

with tarfile.open(args.jaen) as tar:
    tar.extractall(path='data/wmt2021/ted')
