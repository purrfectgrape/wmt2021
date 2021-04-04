#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..
MODEL=$BASE/models/mid_model_full/ja-en
SRC=$BASE/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm.sp
TGT=$BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm.sp
DST=$BASE/translate/mid_model_full/ja_en
SRC_BASE=$BASE/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm_filtered.txt_cln.txt
TGT_BASE=$BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt_cln.txt
# for checkpoint in $BASE/models/mid_model_full/ja-en/_step*.pt; do
#     echo "# Translating with checkpoint $checkpoint"
#     base=$(basename $checkpoint)
#     onmt_translate \
#         -gpu 0 \
#         -batch_size 2000 -batch_type tokens \
#         -beam_size 5 \
#         -model $checkpoint \
#         -src $SRC \
#         -tgt $TGT \
#         -output $DST/test.de.hyp_${base%.*}.sp
# done

# for checkpoint in $MODEL/_step*.pt; do
#     base=$(basename $checkpoint)
#     spm_decode \
#         -model=$BASE/sentencepiece/en_mid.model \
#         -input_format=piece \
#         < $DST/test.de.hyp_${base%.*}.sp \
#         > $DST/test.de.hyp_${base%.*}
# done

for checkpoint in $MODEL/_step*.pt; do
    echo "$checkpoint"
    base=$(basename $checkpoint)
    echo "$checkpoint" >> $DST/eval_mid.txt
    sacrebleu -l en-ja  $TGT_BASE < $BASE/translate/mid_model_full/ja_en/test.de.hyp_${base%.*} >>  $BASE/translate/mid_model_full/ja_en/eval_mid.txt
done
