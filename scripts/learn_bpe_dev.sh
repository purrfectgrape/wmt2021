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
		# Filenames: newsdev2020-enja-ref.ja  newsdev2020-enja-src-tok.en  newsdev2020-jaen-ref-tok.en  newsdev2020-jaen-src.ja
          echo "Learn byte pair encoding for $OPTARG"
	  for file in newsdev2020-enja-ref newsdev2020-enja-src newsdev2020-jaen-ref newsdev2020-jaen-src; do
            subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/dev/preprocessed/$file-tok.$OPTARG > $BASE/data/dev/preprocessed/$file-bpe.$OPTARG
            subword-nmt apply-bpe -c $BASE/data/dev/preprocessed/$file-bpe.$OPTARG < $BASE/data/dev/preprocessed/$file-tok.$OPTARG > $BASE/data/dev/preprocessed/$file-tok-bpe.$OPTARG
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
