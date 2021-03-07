#! /bin/bash
# Author: Giang Le
# Bash script to apply processing steps to datasets.

DIR=`dirname "$0"`
BASE=$DIR/..

if [ ! -d $BASE/data/preprocessed ]; then
  mkdir $BASE/data/preprocessed
fi

while getopts ":c:" opt; do
  case $opt in
    c)
      # Based on SOCKEYE's processing steps:
      echo "Processing $OPTARG data for English" >&2
      echo "Normalizing punctuation"
      cat $BASE/data/raw/$OPTARG-filtered.en | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/preprocessed/$OPTARG-punc-normalized.en

      echo "Removing non printing char"
      cat $BASE/data/preprocessed/$OPTARG-punc-normalized.en | $BASE/libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > $BASE/data/preprocessed/$OPTARG-punc-normalized1.en

      echo "Tokenizing English data"
      cat $BASE/data/preprocessed/$OPTARG-punc-normalized1.en | $BASE/libraries/moses/scripts/tokenizer/tokenizer.perl -no-escape -l en -protected=$BASE/libraries/moses/scripts/tokenizer/basic-protected-patterns > $BASE/data/preprocessed/$OPTARG-tok.en
       ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Options for data preprocessing are wikimatrix, paracrawl, newscommentary, reuters"
      ;;
  esac
done

# Checking parallel files
echo "LINES COUNT CHECK - PARALLEL LC MUST BE EQUAL!"
echo "##############################################"
for c in wikimatrix paracrawl newscommentary reuters newsdev2020; do
    echo "corpus: " $c
    wc -l $BASE/data/preprocessed/$c-tok.en
    wc -l $BASE/data/raw/$c-filtered.ja
done
echo "##############################################"

# Clean up
rm $BASE/data/preprocessed/$OPTARG-punc-normalized.en
rm $BASE/data/preprocessed/$OPTARG-punc-normalized1.en

