#! /bin/bash
# Author: Giang Le
# Bash script to apply preprocessing steps to English data.

DIR=`dirname "$0"`
BASE=$DIR/..

if [ ! -d $BASE/data/train/preprocessed ]; then
  mkdir $BASE/data/train/preprocessed
fi

while getopts ":c:" opt; do
  case $opt in
    c)
      # Based on SOCKEYE's processing steps:
      echo "Processing $OPTARG data for English" >&2

      echo "Normalizing punctuation"
      cat $BASE/data/train/raw/$OPTARG-langid-filtered-cln.en | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/train/preprocessed/$OPTARG-punc-normalized.en

      echo "Removing non printing char"
      cat $BASE/data/train/preprocessed/$OPTARG-punc-normalized.en | $BASE/libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > $BASE/data/train/preprocessed/$OPTARG.en

      echo "Clean up...."
      rm $BASE/data/train/preprocessed/$OPTARG-punc-normalized.en
      ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Option for data preprocessing is wmt2021-bitext"
      ;;
  esac
done
