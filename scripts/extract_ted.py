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
import glob
import argparse
from bs4 import BeautifulSoup
import bs4

parser = argparse.ArgumentParser(description='Tool to extract bitext from TED')
parser.add_argument('--enja', type=str, required=True,
    help='zipped file of en-ja bitext')
parser.add_argument('--jaen', type=str, required=True,
    help='zipped file of ja-en bitext')
parser.add_argument('--out_dir', type=str, required=True,
    help='directory of the unzipped data')
parser.add_argument('--encoding', default='utf-8',
    help='character encoding for input/output')
args = parser.parse_args()

print('Tool to extract bitext from Ted Talks')

with tarfile.open(args.enja) as tar:
    def is_within_directory(directory, target):
        
        abs_directory = os.path.abspath(directory)
        abs_target = os.path.abspath(target)
    
        prefix = os.path.commonprefix([abs_directory, abs_target])
        
        return prefix == abs_directory
    
    def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
    
        for member in tar.getmembers():
            member_path = os.path.join(path, member.name)
            if not is_within_directory(path, member_path):
                raise Exception("Attempted Path Traversal in Tar File")
    
        tar.extractall(path, members, numeric_owner=numeric_owner) 
        
    
    safe_extract(tar, path=args.out_dir)

with tarfile.open(args.jaen) as tar:
    def is_within_directory(directory, target):
        
        abs_directory = os.path.abspath(directory)
        abs_target = os.path.abspath(target)
    
        prefix = os.path.commonprefix([abs_directory, abs_target])
        
        return prefix == abs_directory
    
    def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
    
        for member in tar.getmembers():
            member_path = os.path.join(path, member.name)
            if not is_within_directory(path, member_path):
                raise Exception("Attempted Path Traversal in Tar File")
    
        tar.extractall(path, members, numeric_owner=numeric_owner) 
        
    
    safe_extract(tar, path=args.out_dir)

# Get text from files in the en-ja/ director
def create_docs_list(directory, lang):
    docs_list = []
    for infile in glob.glob(os.path.join(directory, '*/train.tags*' + lang)):
        soup = BeautifulSoup(open(infile, 'r').read())
        for content in soup.contents:
            if isinstance(content, bs4.element.Tag):
                docs_list.append(content.findAll(text=True,recursive=False))
    return docs_list

def write_lines(directory, docs, lang):
    with open(directory + '/ted.' + lang, 'wt', encoding=args.encoding) as outfile:
        for doc in docs:
            for sent in doc:
                if sent != '\n':
                    outfile.write(sent.strip() + '\n')

if __name__ == "__main__":
    langs = ['en', 'ja']
    for lang in langs:
        docs = create_docs_list(args.out_dir, lang)
        write_lines(args.out_dir, docs, lang)

    print('Done. Check your extracted data in ' + args.out_dir)



