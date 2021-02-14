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

    echo "Remove sentences that are longer than 100 tokens for mixed script (TRAINING ONLY, for both datasets)"
    #  command: clean-corpus-n.perl CORPUS L1 L2 OUT MIN MAX
    $BASE/libraries/moses/scripts/training/clean-corpus-n.perl \
    $BASE/data/$OPTARG-tok-bpe ja en $BASE/data/$OPTARG-tok-bpe-clean 1 100
    mv $BASE/data/$OPTARG-tok-bpe-clean.ja $BASE/data/$OPTARG-tok-bpe.ja
    mv $BASE/data/$OPTARG-tok-bpe-clean.en $BASE/data/$OPTARG-tok-bpe.en

    echo "Remove sentences that are longer than 100 tokens for hiragana script (TRAINING ONLY, for both datasets)"
    $BASE/libraries/moses/scripts/training/clean-corpus-n.perl \
    $BASE/data/$OPTARG-tok-bpe-hiragana ja en $BASE/data/$OPTARG-tok-bpe-hiragana-clean 1 100
    mv $BASE/data/$OPTARG-tok-bpe-hiragana-clean.ja $BASE/data/$OPTARG-tok-bpe-hiragana.ja
    mv $BASE/data/$OPTARG-tok-bpe-hiragana-clean.en $BASE/data/$OPTARG-tok-bpe-hiragana.en

    echo "Remove sentences that are longer than 100 tokens for romaji script (TRAINING ONLY, for both datasets)"
    $BASE/libraries/moses/scripts/training/clean-corpus-n.perl \
    $BASE/data/$OPTARG-tok-bpe-romaji ja en $BASE/data/$OPTARG-tok-bpe-romaji-clean 1 100
    mv $BASE/data/$OPTARG-tok-bpe-romaji-clean.ja $BASE/data/$OPTARG-tok-bpe-romaji.ja
    mv $BASE/data/$OPTARG-tok-bpe-romaji-clean.en $BASE/data/$OPTARG-tok-bpe-romaji.en

#      echo "Building vocab"
#      mkdir $BASE/shared_models
#      python3 $BASE/libraries/joeynmt/scripts/build_vocab.py $BASE/data/train-tok-bpe-clean.ja $BASE/data/train-tok-bpe-clean.en --output_path $BASE/shared_models/vocab.txt
       ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Options for data processing are train and train-para"
      ;;
  esac
done

# Checking parallel files
echo "WORD COUNT:"
for c in train-bl train-exp train-para-bl train-para-exp; do
    echo "corpus: " $c
    wc -l $BASE/data/$c-tok-bpe.en $BASE/data/$c-tok-bpe.ja
    echo "hiragana: " $c
    wc -l $BASE/data/$c-tok-bpe-hiragana.en $BASE/data/$c-tok-bpe-hiragana.ja
    echo "romaji: " $c
    wc -l $BASE/data/$c-tok-bpe-romaji.en $BASE/data/$c-tok-bpe-romaji.ja
done
