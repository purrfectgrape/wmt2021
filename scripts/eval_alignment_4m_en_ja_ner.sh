#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

#for checkpoint in $BASE/models/alignment_4m_en_ja_ner/alignment_4m_en_ja_ner_step*.pt; do
#    echo "# Translating with checkpoint $checkpoint"
#    base=$(basename $checkpoint)
#    $HOME/.local/bin/onmt_translate \
#        -gpu 7 \
#        -batch_size 2000 -batch_type tokens \
#        -beam_size 5 \
#	-report_align \
#        -model $checkpoint \
#        -src $BASE/data/test/preprocessed/newstest2020-enja-baseline-annotated.sp.en \
#        -tgt $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.ja \
#        -output $BASE/translate/alignment_4m_en_ja_ner/test.ja.hyp_${base%.*}.sp
#done

#for checkpoint in $BASE/models/alignment_4m_en_ja_ner/alignment_4m_en_ja_ner_step*.pt; do
#    base=$(basename $checkpoint)
#    spm_decode \
#        -model=$BASE/sentencepiece/baseline_sample_4m.ja.model \
#        -input_format=piece \
#        < $BASE/translate/alignment_4m_en_ja_ner/test.ja.hyp_${base%.*}.sp \
#        > $BASE/translate/alignment_4m_en_ja_ner/test.ja.hyp_${base%.*}
#done

for checkpoint in $BASE/models/alignment_4m_en_ja_ner/alignment_4m_en_ja_ner_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $BASE/translate/alignment_4m_en_ja_ner/eval_alignment_4m_en_ja_ner.txt
    /home/gianghl2/.linuxbrew/lib/python3.9/site-packages/sacrebleu/sacrebleu.py -l en-ja  $BASE/data/test/raw/newstest2020-enja-ref.ja.sgm < $BASE/translate/alignment_4m_en_ja_ner/test.ja.hyp_${base%.*} >> $BASE/translate/alignment_4m_en_ja_ner/eval_alignment_4m_en_ja_ner.txt
done

