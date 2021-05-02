#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

for checkpoint in $BASE/models/transformer_base/transformer_base_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    $HOME/.local/bin/onmt_translate \
        -gpu 1 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-jaen-transformer-base.sp.ja \
        -tgt $BASE/data/test/preprocessed/newstest2020-jaen-transformer-base.sp.en \
        -output $BASE/translate/transformer_base/test.en.hyp_${base%.*}.sp
done

for checkpoint in $BASE/models/transformer_base/transformer_base_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/transformer_base.en.model \
        -input_format=piece \
        < $BASE/translate/transformer_base/test.en.hyp_${base%.*}.sp \
        > $BASE/translate/transformer_base/test.en.hyp_${base%.*}
done

for checkpoint in $BASE/models/transformer_base/transformer_base_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/transformer_base/eval_transformer_base.txt
    sacrebleu -l ja-en  $BASE/data/test/raw/newstest2020-jaen-ref.en.sgm < $BASE/translate/transformer_base/test.en.hyp_${base%.*} >> $BASE/translate/transformer_base/eval_transformer_base.txt
done
