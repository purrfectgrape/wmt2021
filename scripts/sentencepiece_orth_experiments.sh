#!/bin/bash

DIR=`dirname "$0"`
BASE=$DIR/..

DATA_PATH=$BASE/data/train/raw
DST_PATH=$BASE/sentencepiece
vocab_size=32000

echo "Training vocab for the baseline model with 4m sentence pairs"
spm_train --input=$DATA_PATH/sample-4m.en --model_prefix=$BASE/vocab/en_sample_4m \
        --vocab_size=$vocab_size --character_coverage=1
spm_train --input=$DATA_PATH/sample-4m.ja --model_prefix=$BASE/vocab/ja_sample_4m \
        --vocab_size=$vocab_size --character_coverage=1
