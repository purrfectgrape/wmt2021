#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/../
# echo BASE
# spm_encode --model=sentencepiece/ja_mid.model \
#     < $BASE/data/wmt2021/mono/4M-langid-filtered.ja  \
#     > $BASE/data/wmt2021/mono/4M.ja.sp
CUDA_VISIBLE_DEVICES=6

# awk '{ if (length($0) < 100) print }' data/wmt2021/mono/4M.ja.sp > data/wmt2021/mono/4M_filtered.ja.sp

# $HOME/.local/bin/onmt_translate \
# -gpu 6 \
# -batch_size 4096 \
# -batch_type tokens \
# -beam_size 5 \
# -model $BASE/models/transformer_base/transformer_base_step_50000.pt \
# -src $BASE/data/wmt2021/mono/4M_filtered.ja.sp \
# -output  $BASE/data/wmt2021/mono/4M_backtrans_subset4.en.sp

# spm_decode \
#     -model=sentencepiece/en_mid.model\
#     -input_format=piece \
#     < $BASE/data/wmt2021/mono/4M_backtrans_subset4.en.sp \
#     > $BASE/data/wmt2021/mono/4M_subset.en

spm_decode \
    -model=sentencepiece/en_mid.model\
    -input_format=piece \
    < $BASE/data/wmt2021/mono/4M_filtered.ja.sp \
    > $BASE/data/wmt2021/mono/4M_filtered.ja

# sed 's/▁//' 4M_filtered.ja > 4M_filtered_postprocessed.ja