#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..


for checkpoint in $BASE/models/romaji_4m/romaji_4m_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    $HOME/.local/bin/onmt_translate \
        -gpu 0 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.ja \
        -tgt $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.en \
        -output $BASE/translate/romaji_4m/test.en.hyp_${base%.*}.sp
done

for checkpoint in $BASE/models/romaji_4m/romaji_4m_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/romaji_sample_4m.en.model \
        -input_format=piece \
        < $BASE/translate/romaji_4m/test.en.hyp_${base%.*}.sp \
        > $BASE/translate/romaji_4m/test.en.hyp_${base%.*}
done

for checkpoint in $BASE/models/romaji_4m/romaji_4m_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/romaji_4m/eval_romaji_4m.txt
    sacrebleu -l ja-en  $BASE/data/test/raw/newstest2020-jaen-ref.en.sgm < $BASE/translate/romaji_4m/test.en.hyp_${base%.*} >> $BASE/translate/romaji_4m/eval_romaji_4m.txt
done
