#! /bin/bash
# Author: Giang Le
# Bash script to apply processing steps to datasets.
# This file needs to be refactored later.

DIR=`dirname "$0"`
BASE=$DIR/..
SRC=ja
TRG=en

BPE_NUM_OPS=25000
BPE_VOCAB_THRES=50


while getopts ":c:" opt; do
  case $opt in
    c)
      echo "Processing $OPTARG data for Japanese" >&2
      python3 $BASE/scripts/add_voice.py $OPTARG
      echo "Tokenizing Japanese..." >&2
      python3 $BASE/scripts/tokenize_japanese.py $OPTARG
      echo "Script conversion for Japanese..." >&2
      python3 $BASE/scripts/ja_script_conversion.py $OPTARG

      echo "Learn byte pair encoding for Japanese"
      # Not sure if I can use the same input file for learn-bpe and apply-bpe?
      # For mixed script:
      subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/$OPTARG-ja-tok.txt > $BASE/data/$OPTARG-ja-bpe.txt
      subword-nmt apply-bpe -c $BASE/data/$OPTARG-ja-bpe.txt < $BASE/data/$OPTARG-ja-tok.txt > $BASE/data/$OPTARG-tok-bpe.ja
      # For hiragana:
      subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/$OPTARG-ja-hiragana.txt > $BASE/data/$OPTARG-ja-hiragana-bpe.txt
      subword-nmt apply-bpe -c $BASE/data/$OPTARG-ja-hiragana-bpe.txt < $BASE/data/$OPTARG-ja-hiragana.txt > $BASE/data/$OPTARG-tok-bpe-hiragana.ja
      # For romaji:
      subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/$OPTARG-ja-romaji.txt > $BASE/data/$OPTARG-ja-romaji-bpe.txt
      subword-nmt apply-bpe -c $BASE/data/$OPTARG-ja-romaji-bpe.txt < $BASE/data/$OPTARG-ja-romaji.txt > $BASE/data/$OPTARG-tok-bpe-romaji.ja
      ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Options for data processing are train-bl, dev-bl, test-bl, train-exp, dev-exp, test-ex, train-para-bl, dev-para-bl, and test-para-bl, train-para-exp, dev-para-exp, and test-para-exp"
      ;;
  esac
done

# Checking parallel files
echo "LINES COUNT"
for c in train-bl dev-bl test-bl train-exp dev-exp test-exp train-para-bl dev-para-bl test-para-bl train-para-exp dev-para-exp test-para-exp; do
    echo "corpus: " $c
    wc -l $BASE/data/$c-tok-bpe.ja
    echo "hiragana: " $c
    wc -l $BASE/data/$c-tok-bpe-hiragana.ja
    echo "romaji: " $c
    wc -l $BASE/data/$c-tok-bpe-romaji.ja
done

#wc -l $BASE/shared_models/*
