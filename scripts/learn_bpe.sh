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
          echo "Learn byte pair encoding for $OPTARG"
          subword-nmt learn-bpe -s $BPE_NUM_OPS < $BASE/data/train/preprocessed/wmt2021-bitext-tok.$OPTARG > $BASE/data/train/preprocessed/wmt2021-bitext-bpe.$OPTARG
          subword-nmt apply-bpe -c $BASE/data/train/preprocessed/wmt2021-bitext-bpe.$OPTARG < $BASE/data/train/preprocessed/wmt2021-bitext-tok.$OPTARG > $BASE/data/train/preprocessed/wmt2021-bitext-tok-bpe.$OPTARG

         ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Option for l is ja or en"
      ;;
  esac
done

