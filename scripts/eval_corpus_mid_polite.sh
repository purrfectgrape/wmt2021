#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

for checkpoint in $BASE/models/corpus_mid_polite/corpus_mid_polite_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    $HOME/.local/bin/onmt_translate \
        -gpu 2 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 5 \
	-attn_debug \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.en \
        -tgt $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.ja \
        -output $BASE/translate/corpus_mid_polite/test.ja.hyp_${base%.*}.sp
done

for checkpoint in $BASE/models/corpus_mid_polite/corpus_mid_polite_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/ja_mid.model \
        -input_format=piece \
        < $BASE/translate/corpus_mid_polite/test.ja.hyp_${base%.*}.sp \
        > $BASE/translate/corpus_mid_polite/test.ja.hyp_${base%.*}
done

for checkpoint in $BASE/models/corpus_mid_polite/corpus_mid_polite_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/corpus_mid_polite/eval_corpus_mid_polite.txt
    /home/gianghl2/.linuxbrew/lib/python3.9/site-packages/sacrebleu/sacrebleu.py -l en-ja  $BASE/data/test/raw/newstest2020-enja-ref.ja.sgm < $BASE/translate/corpus_mid_polite/test.ja.hyp_${base%.*} >> $BASE/translate/corpus_mid_polite/eval_corpus_mid_polite.txt
done


