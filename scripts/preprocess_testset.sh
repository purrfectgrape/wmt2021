#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# cat $DATA/newstest2020-enja-ref.ja.sgm_cln.txt | sed '/^$/d' > $DATA/newstest2020-enja-ref.ja.sgm_filtered.txt
# cat /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-enja-src.en.sgm_cln.txt | sed '/^$/d' > /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-enja-src.en.sgm_filtered.txt
# cat /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_cln.txt | sed '/^$/d' > /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt
# cat /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm_cln.txt | sed '/^$/d' > /nas/models/experiment/ja-en/wmt2021/
DATA=$BASE/data/test/wmt2020/enja
cat $DATA/newstest2020-enja-ref.ja.sgm_cln.txt | sed '/^$/d' > $DATA/newstest2020-enja-ref.ja.sgm_filtered.txt
wc -l $DATA/newstest2020-enja-ref.ja.sgm_filtered.txt
cat $DATA/newstest2020-enja-src.en.sgm_cln.txt | sed '/^$/d' > $DATA/newstest2020-enja-src.en.sgm_filtered.txt 
wc -l $DATA/newstest2020-enja-src.en.sgm_filtered.txt 
cat $DATA/newstest2020-jaen-ref.en.sgm_cln.txt | sed '/^$/d' > $DATA/newstest2020-jaen-ref.en.sgm_filtered.txt
wc -l $DATA/newstest2020-jaen-ref.en.sgm_filtered.txt
cat $DATA/newstest2020-jaen-src.ja.sgm_cln.txt | sed '/^$/d' > $DATA/newstest2020-jaen-src.ja.sgm_filtered.txt 
wc -l $DATA/newstest2020-jaen-src.ja.sgm_filtered.txt 



# # encode test set
spm_encode --model=$BASE/sentencepiece/en_mid.model \
    < $BASE/data/test/wmt2020/enja/newstest2020-enja-src.en.sgm_filtered.txt \
    > $BASE/data/test/wmt2020/enja/newstest2020-enja-src.en.sgm.sp

spm_encode --model=$BASE/sentencepiece/ja_mid.model \
    < $BASE/data/test/wmt2020/enja/newstest2020-enja-ref.ja.sgm_filtered.txt \
    > $BASE/data/test/wmt2020/enja/newstest2020-enja-ref.ja.sgm.sp

spm_encode --model=$BASE/sentencepiece/en_mid.model \
    < $BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm_filtered.txt \
    > $BASE/data/test/wmt2020/enja/newstest2020-jaen-ref.en.sgm.sp

spm_encode --model=$BASE/sentencepiece/ja_mid.model \
    < $BASE/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm_filtered.txt \
    > $BASE/data/test/wmt2020/enja/newstest2020-jaen-src.ja.sgm.sp