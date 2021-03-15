#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..


for checkpoint in $BASE/models/corpus_mid_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -batch_size 2000 \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm_filtered.txt_cln.txt \
        -tgt $BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt_cln.txt \
        -output $BASE/eval/corpus_mid_sudachi/test.en.hyp_${base%.*}
done

#for checkpoint in $BASE/models/corpus_mid_step*.pt; do
#    echo "$checkpoint"
#    base=$(basename $checkpoint)
#    echo "$checkpoint" >> $BASE/eval/corpus_mid_sudachi/eval_mid.txt
#    sacrebleu -l ja-en $BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt_cln.txt
# < $BASE/eval/corpus_mid_sudachi/test.en.hyp_${base%.*} >>  $BASE/eval/corpus_mid_sudachi/eval_mid.txt
#done
