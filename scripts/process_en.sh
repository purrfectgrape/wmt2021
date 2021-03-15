#! /bin/bash
# Author: Giang Le
# Bash script to apply processing steps to datasets.
# This processing step doesn't include adding voice tags to the data. The resulting data from this processing file serve as the baseline for our expeirments.
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
      # Based on SOCKEYE's processing steps:
      echo "Processing $OPTARG data for English" >&2
      echo "Normalizing punctuation"
      cat $BASE/data/$OPTARG-en-raw.txt | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/$OPTARG-en-punc-normalized.txt

      echo "Removing non printing char"
      cat $BASE/data/$OPTARG-en-punc-normalized.txt | $BASE/libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > $BASE/data/$OPTARG-en-punc-normalized1.txt

      echo "Tokenizing English data"
      cat $BASE/data/$OPTARG-en-punc-normalized1.txt | $BASE/libraries/moses/scripts/tokenizer/tokenizer.perl -no-escape -l en -protected=$BASE/libraries/moses/scripts/tokenizer/basic-protected-patterns > $BASE/data/$OPTARG-en-tok.txt

      echo "Learn byte pair encoding for English"
      # Not sure if I can use the same input file for learn-bpe and apply-bpe?
      subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/$OPTARG-en-tok.txt > $BASE/data/$OPTARG-en-bpe.txt
      subword-nmt apply-bpe -c $BASE/data/$OPTARG-en-bpe.txt < $BASE/data/$OPTARG-en-tok.txt > $BASE/data/$OPTARG-tok-bpe.en
      
#      echo "Building vocab"
#      mkdir $BASE/shared_models
#      python3 $BASE/libraries/joeynmt/scripts/build_vocab.py $BASE/data/train-tok-bpe-clean.ja $BASE/data/train-tok-bpe-clean.en --output_path $BASE/shared_models/vocab.txt
       ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Options for data processing are train, dev, test, train-para, dev-para, and test-para"
      ;;
  esac
done

# Checking parallel files
echo "WORD COUNT:"
for c in train dev test train-para dev-para test-para; do
    echo "corpus: " $c
    wc -l $BASE/data/$c-tok-bpe.en
    echo "hiragana: " $c
    wc -l $BASE/data/$c-tok-bpe-hiragana.en
    echo "romaji: " $c
    wc -l $BASE/data/$c-tok-bpe-romaji.en
done

#wc -l $BASE/shared_models/*
