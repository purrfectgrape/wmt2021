#! /bin/bash
# Author: Giang Le
# Bash script to apply preprocessing steps to English data.

DIR=`dirname "$0"`
BASE=$DIR/..

if [ ! -d $BASE/data/dev/preprocessed ]; then
  mkdir $BASE/data/dev/preprocessed
fi

while getopts ":c:" opt; do
  case $opt in
    c)
      # Based on SOCKEYE's processing steps:
      echo "Processing $OPTARG data for English" >&2
      echo "Normalizing punctuation"
      cat $BASE/data/dev/raw/$OPTARG.en.sgm | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/dev/preprocessed/$OPTARG-punc-normalized.en

      echo "Removing non printing char"
      cat $BASE/data/dev/preprocessed/$OPTARG-punc-normalized.en | $BASE/libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > $BASE/data/dev/preprocessed/$OPTARG-punc-normalized1.en

      echo "Tokenizing English data"
      cat $BASE/data/dev/preprocessed/$OPTARG-punc-normalized1.en | $BASE/libraries/moses/scripts/tokenizer/tokenizer.perl -no-escape -l en -protected=$BASE/libraries/moses/scripts/tokenizer/basic-protected-patterns > $BASE/data/dev/preprocessed/$OPTARG-tok.en
      
 #     echo "Learn byte pair encoding for English"
 #     # Not sure if I can use the same input file for learn-bpe and apply-bpe?
 #     subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/dev/preprocessed/$OPTARG-tok.en > $BASE/data/dev/preprocessed/$OPTARG-bpe.en
 #     subword-nmt apply-bpe -c $BASE/data/dev/preprocessed/$OPTARG-bpe.en < $BASE/data/dev/preprocessed/$OPTARG-tok.en > $BASE/data/dev/preprocessed/$OPTARG-tok-bpe.en
      
      
      echo "##############################################"
      echo "$(wc -l $BASE/data/dev/preprocessed/$OPTARG-tok.en)"

      echo "##############################################" 
      echo "Clean up...."
      rm $BASE/data/dev/preprocessed/$OPTARG-punc-normalized.en
      rm $BASE/data/dev/preprocessed/$OPTARG-punc-normalized1.en
      ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Option for data preprocessing is newsdev2020-enja-src  newsdev2020-jaen-ref"
      ;;
  esac
done
