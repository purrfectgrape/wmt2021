#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# Preprocess test datasets located in data/test/raw
# Remove leading and trailing whitespaces
# Remove non-printing (non-UTF8) characters
# Normalizing punctuation (for EN)
DIRECTION=$1
## Get rid of extra whitespaces
awk '{$1=$1;print}' data/test/raw/newstest2020-$DIRECTION.en.sgm > data/test/raw/newstest2020-$DIRECTION.en.sgm.tmp
awk '{$1=$1;print}' data/test/raw/newstest2020-$DIRECTION.ja.sgm > data/test/raw/newstest2020-$DIRECTION.ja.sgm.tmp

echo "removing non UTF8"
cat data/test/raw/newstest2020-$DIRECTION.en.sgm.tmp | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > data/test/raw/newstest2020-$DIRECTION.en.sgm.tmp1
cat data/test/raw/newstest2020-$DIRECTION.ja.sgm.tmp | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l ja > data/test/raw/newstest2020-$DIRECTION.ja.sgm.tmp1

echo "English only: normalizing punctuation"
cat data/test/raw/newstest2020-$DIRECTION.en.sgm.tmp1 | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/test/preprocessed/newstest2020-$DIRECTION.en

python3 scripts/preprocess_ja.py --input=data/test/raw/newstest2020-$DIRECTION.ja.sgm.tmp1 --output=data/test/preprocessed/newstest2020-$DIRECTION.ja

echo "clean up.."
rm data/test/raw/*.tmp*

echo "Check out the data in data/test/preprocessed/*.en and data/test/preprocessed/*.ja"
