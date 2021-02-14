#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: gianghale
This script adds voice information to Japanese text via regular expression heuristics.
"""
# Passive morphemes in Japanese are written in hiragana rather than kanji, and it has the form -rare for ichidan verb, or -are or godan verbs.

import re
import os
import sys

current = os.getcwd()
data_dir = os.getcwd() + "/data/"

if not len(sys.argv) == 2:
    raise SystemExit("Usage: {} type".format(sys.argv[0]))

if not ("train-exp" in sys.argv[1] or "test-exp" in sys.argv[1] or "dev-exp" in sys.argv[1] or "train-para-exp" in sys.argv[1] or "test-para-exp" in sys.argv[1] or "dev-para-exp" in sys.argv[1]):
    raise SystemExit("Type of file must be train-exp, dev-exp, or test-exp")
    
def create_lines(file):
    lines = []
    with open(file, "r") as infile:
        lines = infile.readlines()
    return lines

def match(lines):
    new_lines = []
    for i, line in enumerate(lines):
        if ("される。" in line or "されている。" in line or "されてる。" in line or # する do verb
        "された。" in line or "されていた。" in line or "されてた。" in line or # する do verb, past tense
        "られる。" in line or "られている。" in line or "られてる。" in line or # 五段動詞 godan verb
        "られた。" in line or "られていた。" in line or "られてた。" in line or # 五段動詞 godan verb, past tense
        "あれる。" in line or "あれている。" in line or "あれてる。" in line or
        "あれた。" in line or "あれていた。" in line or "あれてた。" in line or
        "かれる。" in line or "かれている。" in line or "かれてる。" in line or
        "かれた。" in line or "かれていた。" in line or "かれてた。" in line or
        "がれる。" in line or "がれている。" in line or "がれてる。" in line or
        "がれた。" in line or "がれていた。" in line or "がれてた。" in line or
        "ざれる。" in line or "ざれている。" in line or "ざれてる。" in line or
        "ざれた。" in line or "ざれていた。" in line or "ざれてた。" in line or
        "たれる。" in line or "たれている。" in line or "たれてる。" in line or
        "たれた。" in line or "たれていた。" in line or "たれてた。" in line or
        "だれる。" in line or "だれている。" in line or "だれてる。" in line or
        "だれた。" in line or "だれていた。" in line or "だれてた。" in line or
        "なれる。" in line or "なれている。" in line or "なれてる。" in line or
        "なれた。" in line or "なれていた。" in line or "なれてた。" in line or
        "はれる。" in line or "はれている。" in line or "はれてる。" in line or
        "はれた。" in line or "はれていた。" in line or "はれてた。" in line or
        "ばれる。" in line or "ばれている。" in line or "ばれてる。" in line or
        "ばれた。" in line or "ばれていた。" in line or "ばれてた。" in line or
        "ぱれる。" in line or "ぱれている。" in line or "ぱれてる。" in line or
        "ぱれた。" in line or "ぱれていた。" in line or "ぱれてた。" in line or
        "まれる。" in line or "まれている。" in line or "まれてる。" in line or
        "まれた。" in line or "まれていた。" in line or "まれてた。" in line or
        "やれる。" in line or "やれている。" in line or "やれてる。" in line or
        "やれた。" in line or "やれていた。" in line or "やれてた。" in line or
        "われる。" in line or "われている。" in line or "われてる。" in line or
        "われた。" in line or "われていた。" in line or "われてた。" in line):
            lines[i] = line.strip("\n") + "<Passive>"
    return lines

def write_lines(lines, file):
    with open(file, "w") as outfile:
        for line in lines:
            outfile.write(line + "\n")
    
print("Adding voice info to " + sys.argv[1] + " data")
lines = create_lines(data_dir + sys.argv[1] + "-ja-raw.txt")
lines_to_write = []
lines_to_write = match(lines)
write_lines(lines_to_write, data_dir + sys.argv[1] + "-ja-with-voice.txt")
print("Done!")
