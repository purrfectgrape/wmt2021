#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

if [[ ! -d $BASE/eval/wmt2021-bitext ]]; then 
	mkdir $BASE/eval/wmt2021-bitext
fi
for checkpoint in $BASE/models/wmt2021-bitext/wmt2021-bitext_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -batch_size 2000 -batch_type tokens \
	-gpu 0 \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-jaen-src-tok-bpe.ja \
        -tgt $BASE/data/test/preprocessed/newstest2020-jaen-ref-tok-bpe.en \
        -output $BASE/eval/wmt2021-bitext/test.en.hyp_${base%.*}
done

for checkpoint in $BASE/models/wmt2021-bitext/wmt2021-bitext_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/eval/wmt2021-bitext/eval.txt
    sacrebleu -l ja-en $BASE/data/test/preprocessed/newstest2020-jaen-ref-tok-bpe.en < $BASE/eval/wmt2021-bitext/test.en.hyp_${base%.*} >>  $BASE/eval/wmt2021-bitext/eval.txt
done
