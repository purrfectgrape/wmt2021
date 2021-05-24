#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..
# echo BASE
# spm_encode --model=sentencepiece/ja_mid.model \
#     < $BASE/data/wmt2021/mono/4M-langid-filtered.ja  \
#     > $BASE/data/wmt2021/mono/4M-langid-filtered.ja.sp
CUDA_VISIBLE_DEVICES=0,1,2

# $HOME/.local/bin/onmt_translate \
# -gpu  3 \
# -batch_size  500 -batch_type tokens \
# -beam_size 5 \
# -model $BASE/models/mid_model_full/ja-en/_step_20000.pt \
# -src $BASE/data/wmt2021/mono/1M.ja.sp \
# -output  $BASE/data/wmt2021/mono/1M_backtrans.en.sp

spm_decode \
    -model=sentencepiece/en_mid.model\
    -input_format=piece \
    < $BASE/data/wmt2021/mono/1M_backtrans.en.sp \
    > $BASE/data/wmt2021/mono/1M.en