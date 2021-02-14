#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# TRAIN DATA
cp $BASE/data/train-tok-bpe.en $BASE/data/train-bl-tok-bpe.en
cp $BASE/data/train-tok-bpe.en $BASE/data/train-bl-tok-bpe-hiragana.en
cp $BASE/data/train-tok-bpe.en $BASE/data/train-bl-tok-bpe-romaji.en
    
cp $BASE/data/train-tok-bpe.en $BASE/data/train-exp-tok-bpe.en
cp $BASE/data/train-tok-bpe.en $BASE/data/train-exp-tok-bpe-hiragana.en
cp $BASE/data/train-tok-bpe.en $BASE/data/train-exp-tok-bpe-romaji.en

cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-bl-tok-bpe.en
cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-bl-tok-bpe-hiragana.en
cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-bl-tok-bpe-romaji.en
    
cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-exp-tok-bpe.en
cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-exp-tok-bpe-hiragana.en
cp $BASE/data/train-para-tok-bpe.en $BASE/data/train-para-exp-tok-bpe-romaji.en
