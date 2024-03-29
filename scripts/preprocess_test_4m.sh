#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# Refactor this file later.
# encode test set
echo "Encoding hiragana test set"
spm_encode --model=$BASE/sentencepiece/hiragana_sample_4m.en.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.en \
    > $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.en

spm_encode --model=$BASE/sentencepiece/hiragana_sample_4m.ja.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.ja \
    > $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.ja

echo "Encoding romaji test set"
spm_encode --model=$BASE/sentencepiece/romaji_sample_4m.en.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-romaji.en \
    > $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.en

spm_encode --model=$BASE/sentencepiece/romaji_sample_4m.ja.model \
    < $BASE/data/test/preprocessed/newstest2020-jaen-romaji.ja \
    > $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.ja

echo "Encoding baseline test set"
spm_encode --model=$BASE/sentencepiece/baseline_sample_4m.en.model \
    < $BASE/data/test/raw/newstest2020-jaen-ref.en.sgm \
    > $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.en

spm_encode --model=$BASE/sentencepiece/baseline_sample_4m.ja.model \
    < $BASE/data/test/raw/newstest2020-jaen-src.ja.sgm \
    > $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.ja

spm_encode --model=$BASE/sentencepiece/baseline_sample_4m.en.model \
	 < $BASE/data/test/raw/newstest2020-enja-src.en.sgm \
	 > $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.en

spm_encode --model=$BASE/sentencepiece/baseline_sample_4m.ja.model \
    < $BASE/data/test/raw/newstest2020-enja-ref.ja.sgm \
    > $BASE/data/test/preprocessed/newstest2020-enja-baseline.sp.ja

echo "line counts"
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.en
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.en
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.en
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-hiragana.sp.ja
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-romaji.sp.ja
wc -l $BASE/data/test/preprocessed/newstest2020-jaen-baseline.sp.ja

