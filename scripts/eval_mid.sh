#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..


for checkpoint in $BASE/models/mid_model_full/model_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -gpu 0 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/wmt2020/enja/newstest2020-enja-src.en.sgm.sp \
        -tgt $BASE/data/test/wmt2020/enja/newstest2020-enja-ref.ja.sgm.sp \
        -output $BASE/translate/mid_model_full/test.de.hyp_${base%.*}.sp
done

for checkpoint in $BASE/models/mid_model_full/model_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/ja_mid.model \
        -input_format=piece \
        < $BASE/translate/mid_model_full/test.de.hyp_${base%.*}.sp \
        > $BASE/translate/mid_model_full/test.de.hyp_${base%.*}
done

for checkpoint in $BASE/models/mid_model_full/model_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/mid_model_full/eval_mid.txt
    sacrebleu -l en-ja  $BASE/data/test/wmt2020/enja/newstest2020-enja-ref.ja.sgm_filtered.txt < $BASE/translate/mid_model_full/test.de.hyp_${base%.*} >>  $BASE/translate/mid_model_full/eval_mid.txt
done
