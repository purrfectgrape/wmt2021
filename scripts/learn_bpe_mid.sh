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
	  echo "Concatenate train files"
	  cat $BASE/data/preprocessed/reuters-tok.$OPTARG $BASE/data/preprocessed/paracrawl-tok.$OPTARG $BASE/data/preprocessed/wikimatrix-tok.$OPTARG $BASE/data/preprocessed/newscommentary-tok.$OPTARG > $BASE/data/train/preprocessed/corpus-mid-tok.$OPTARG
          echo "Learn byte pair encoding for $OPTARG"
          subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/train/preprocessed/corpus-mid-tok.$OPTARG > $BASE/data/train/preprocessed/corpus-mid-bpe.$OPTARG
          subword-nmt apply-bpe -c $BASE/data/train/preprocessed/corpus-mid-bpe.$OPTARG < $BASE/data/train/preprocessed/corpus-mid-tok.$OPTARG > $BASE/data/train/preprocessed/corpus-mid-tok-bpe.$OPTARG

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
