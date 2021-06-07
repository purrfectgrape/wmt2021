#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/../
# echo BASE
# spm_encode --model=sentencepiece/en_mid.model \
#     < $BASE/data/wmt2021/mono/4M-langid-filtered.en \
#     > $BASE/data/wmt2021/mono/4M.en.sp

spm_encode --model=sentencepiece/en_mid.model \
    < $BASE/data/wmt2021/mono/9M.en \
    > $BASE/data/wmt2021/mono/9M.en.sp
CUDA_VISIBLE_DEVICES=2
# awk '{ if (length($0) < 100) print }' data/wmt2021/mono/4M.en.sp > data/wmt2021/mono/4M_filtered2.en.sp
awk '{ if (length($0) < 100) print }' data/wmt2021/mono/9M.en.sp > data/wmt2021/mono/9M_filtered.en.sp

# $HOME/.local/bin/onmt_translate \
# -gpu  2 \
# -batch_size  4096 \
# -batch_type tokens \
# -beam_size 1 \
# -model $BASE/models/mid_model_full/model_step_19000.pt \
# -src $BASE/data/wmt2021/mono4M_filtered.en.sp \
# -output  $BASE/data/wmt2021/mono/4M_backtrans4.ja.sp
$HOME/.local/bin/onmt_translate \
-gpu  2 \
-batch_size  4096 \
-batch_type tokens \
-beam_size 1 \
-model $BASE/models/mid_model_full/model_step_19000.pt \
-src $BASE/data/wmt2021/mono/9M_filtered.en.sp \
-output  $BASE/data/wmt2021/mono/9M_backtrans5.ja.sp

# spm_decode \
#     -model=sentencepiece/en_mid.model\
#     -input_format=piece \
#     < $BASE/data/wmt2021/mono/4M_backtrans2.ja.sp \
#     > $BASE/data/wmt2021/mono/4M_backtrans2.ja
# spm_decode \
#     -model=sentencepiece/en_mid.model\
#     -input_format=piece \
#     < $BASE/data/wmt2021/mono/9M_backtrans5.ja.sp \
#     > $BASE/data/wmt2021/mono/9M_backtrans5.ja
spm_decode \
    -model=sentencepiece/en_mid.model\
    -input_format=piece \
    < $BASE/data/wmt2021/mono/9M_filtered.en.sp \
    > $BASE/data/wmt2021/mono/9M_filtered.en