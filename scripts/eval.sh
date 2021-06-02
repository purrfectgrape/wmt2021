#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

for checkpoint in $BASE/models/$2/ja-en_step*.pt; do
    echo "# Translating $1 data with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    $HOME/.local/bin/onmt_translate \
        -gpu $3 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 10 \
        -model $checkpoint \
        -src $BASE/data/$1/preprocessed/news"$1"2020-jaen.ja.sp \
        -tgt $BASE/data/$1/preprocessed/news"$1"2020-jaen.en.sp \
        -output $BASE/translate/$2/$1.en.hyp_${base%.*}.sp
done

echo "decoding SP-segmented text"
for checkpoint in $BASE/models/$2/ja-en_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/$2.en.model \
        -input_format=piece \
        < $BASE/translate/$2/$1.en.hyp_${base%.*}.sp \
        > $BASE/translate/$2/$1.en.hyp_${base%.*}
done

for checkpoint in $BASE/models/$2/ja-en_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/$2/eval_$1_$2_ja_en.txt
    sacrebleu -l ja-en  $BASE/data/$1/preprocessed/news"$1"2020-jaen.en < $BASE/translate/$2/$1.en.hyp_${base%.*} >> $BASE/translate/$2/eval_$1_$2_ja_en.txt
done
