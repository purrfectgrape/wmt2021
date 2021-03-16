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


while getopts ":l:" opt; do
  case $opt in
    l)
      case $OPTARG in
        ja | en)
		# Filenames: newstest2020-enja-ref.ja  newstest2020-enja-src-tok.en  newstest2020-jaen-ref-tok.en  newstest2020-jaen-src.ja
          echo "Learn byte pair encoding for $OPTARG"
	  for file in newstest2020-enja-ref newstest2020-enja-src newstest2020-jaen-ref newstest2020-jaen-src; do
            subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/test/preprocessed/$file-tok.$OPTARG > $BASE/data/test/preprocessed/$file-bpe.$OPTARG
            subword-nmt apply-bpe -c $BASE/data/test/preprocessed/$file-bpe.$OPTARG < $BASE/data/test/preprocessed/$file-tok.$OPTARG > $BASE/data/test/preprocessed/$file-tok-bpe.$OPTARG
          done
         ;;
         *)
          echo "Invalid argument: $OPTARG. Usage: ./scripts/learn_bpe -l ja. Argument must be either ja or en." >&2
        ;;
      esac
    ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Option for l is ja or en"
      ;;
  esac
done
