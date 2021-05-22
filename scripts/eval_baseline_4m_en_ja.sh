#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

for checkpoint in $BASE/models/baseline_4m_en_ja/baseline_4m_en_ja_step*.pt; do
    echo "# Translating with checkpoint $checkpoint"
    base=$(basename $checkpoint)
    $HOME/.local/bin/onmt_translate \
        -gpu 2 \
        -batch_size 2000 -batch_type tokens \
        -beam_size 5 \
        -model $checkpoint \
        -src $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.en \
        -tgt $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.ja \
        -output $BASE/translate/baseline_4m_en_ja/test.ja.hyp_${base%.*}.sp
done

for checkpoint in $BASE/models/baseline_4m_en_ja/baseline_4m_en_ja_step*.pt; do
    base=$(basename $checkpoint)
    spm_decode \
        -model=$BASE/sentencepiece/baseline_sample_4m.ja.model \
        -input_format=piece \
        < $BASE/translate/baseline_4m_en_ja/test.ja.hyp_${base%.*}.sp \
        > $BASE/translate/baseline_4m_en_ja/test.ja.hyp_${base%.*}
done

for checkpoint in $BASE/models/baseline_4m_en_ja/baseline_4m_en_ja_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/baseline_4m_en_ja/eval_baseline_4m_en_ja.txt
    /home/gianghl2/.linuxbrew/lib/python3.9/site-packages/sacrebleu/sacrebleu.py -l en-ja  $BASE/data/test/raw/newstest2020-enja-ref.ja.sgm < $BASE/translate/baseline_4m_en_ja/test.ja.hyp_${base%.*} >> $BASE/translate/baseline_4m_en_ja/eval_baseline_4m_en_ja.txt
done

