#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# encode test set
echo "Encoding hiragana test set"
spm_encode --model=$BASE/sentencepiece/hiragana_sample_4m.en.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.en \
    > $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.en

echo "Encoding romaji test set"
spm_encode --model=$BASE/sentencepiece/romaji_sample_4m.en.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-romaji.en \
    > $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.en

echo "Encoding baseline test set"
spm_encode --model=$BASE/sentencepiece/baseline_sample_4m.en.model \
    < $BASE/data/test/raw/newstest2020-jaen-ref.en.sgm \
    > $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.en

echo "line counts"
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.en
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.en
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.en
