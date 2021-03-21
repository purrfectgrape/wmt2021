#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

if [[ ! -d $BASE/eval/wmt2021-bitext ]]; then 
	mkdir $BASE/eval/wmt2021-bitext
fi
for checkpoint in $BASE/models/wmt2021-bitext_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    onmt_translate \
        -batch_size 2000 \
	-gpu 0 \
        -beam_size 15 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-jaen-src-tok-bpe.ja \
        -tgt $BASE/data/test/preprocessed/newstest2020-jaen-ref-tok-bpe.en \
        -output $BASE/eval/wmt2021-bitext/test.en.hyp_${base%.*}
done

# Undo bpe
#$BASE/data/test/preprocessed/newstest2020-jaen-ref-tok-bpe.en | sed -r 's/@@ //g' > $BASE/data/test/preprocessed/newstest2020-jaen-ref-tok.en
#for checkpoint in $BASE/models/corpus_mid_step*.pt; do
#    echo "$checkpoint"
#    base=$(basename $checkpoint)
#    echo "$checkpoint" >> $BASE/eval/corpus_mid_sudachi/eval_mid.txt
#    sacrebleu -l ja-en $BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt_cln.txt
# < $BASE/eval/corpus_mid_sudachi/test.en.hyp_${base%.*} >>  $BASE/eval/corpus_mid_sudachi/eval_mid.txt
#done
