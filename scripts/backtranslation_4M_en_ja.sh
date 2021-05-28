#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/../
# echo BASE
spm_encode --model=sentencepiece/en_mid.model \
    < $BASE/data/wmt2021/mono/4M.en \
    > $BASE/data/wmt2021/mono/4M.en.sp
CUDA_VISIBLE_DEVICES=5

$HOME/.local/bin/onmt_translate \
-gpu  5 \
-batch_size  500 \
-batch_type tokens \
-beam_size 1 \
-model $BASE/models/mid_model_full/model_step_19000.pt \
-src $BASE/data/wmt2021/mono/4M.en.sp \
-output  $BASE/data/wmt2021/mono/4M_backtrans.ja.sp

spm_decode \
    -model=sentencepiece/en_mid.model\
    -input_format=piece \
    < $BASE/data/wmt2021/mono/4M_backtrans.ja.sp \
    > $BASE/data/wmt2021/mono/4M_backtrans.ja