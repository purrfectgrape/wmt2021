#! /bin/bash
# Author: Giang Le
# Bash script to train OpenNMT

DIR=`dirname "$0"`
BASE=$DIR/..

#(TODO)Giang: Update filenames for reuters cases.
source /opt/python/3.7/venv/pytorch1.3_cuda10.0/bin/activate

while getopts ":c:" opt; do
  case $opt in
    c)
      echo "Build vocab for mixed scripts"
      onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe.ja -train_tgt //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe.en -valid_src //nas/models/experiment/ja-en/wmt2021/data/dev-$OPTARG-tok-bpe.ja -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/dev-tok-bpe.en -save_data //nas/models/experiment/ja-en/wmt2021/data/OpenNMT-data-$OPTARG -overwrite
    
      echo "Build vocab for hiragana"
      onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe-hiragana.ja -train_tgt //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe-hiragana.en -valid_src //nas/models/experiment/ja-en/wmt2021/data/dev-$OPTARG-tok-bpe-hiragana.ja -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/dev-tok-bpe.en -save_data //nas/models/experiment/ja-en/wmt2021/data/OpenNMT-data-$OPTARG-hiragana -overwrite
      
      echo "Build vocab for romaji"
      onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe-romaji.ja -train_tgt //nas/models/experiment/ja-en/wmt2021/data/train-$OPTARG-tok-bpe-romaji.en -valid_src //nas/models/experiment/ja-en/wmt2021/data/dev-$OPTARG-tok-bpe-romaji.ja -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/dev-tok-bpe.en -save_data //nas/models/experiment/ja-en/wmt2021/data/OpenNMT-data-$OPTARG-romaji -overwrite
    
       ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Options for data processing are bl, exp, para-bl, para-exp"
      ;;
  esac
done