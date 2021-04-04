#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..


if [[ ! -d $BASE/eval/corpus_mid_fugashi ]]; then
	mkdir $BASE/eval/corpus_mid_fugashi
fi

for checkpoint in $BASE/models/corpus-mid-0321_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -batch_size 2000 -batch_type tokens \
	-gpu 0 \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-enja-src-tok-bpe.en \
        -tgt $BASE/data/test/preprocessed/newstest2020-enja-ref-tok-bpe.ja \
        -output $BASE/eval/corpus_mid_fugashi/test.ja.hyp_${base%.*}
done

for checkpoint in $BASE/models/corpus-mid-0321_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$base"
    echo "$checkpoint" >> $BASE/eval/corpus_mid_fugashi/eval_mid.txt
    sacrebleu -l en-ja $BASE/data/test/preprocessed/newstest2020-enja-ref-tok-bpe.ja < $BASE/eval/corpus_mid_fugashi/test.ja.hyp_${base%.*} >> $BASE/eval/corpus_mid_fugashi/eval_mid.txt
done
