#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

# Preprocess dev datasets located in data/dev/raw
# Remove leading and trailing whitespaces
# Remove non-printing (non-UTF8) characters
# Normalizing punctuation (for EN)
DIRECTION=$1
## Get rid of extra whitespaces
awk '{$1=$1;print}' data/dev/raw/newsdev2020-$DIRECTION.en.sgm > data/dev/raw/newsdev2020-$DIRECTION.en.sgm.tmp
awk '{$1=$1;print}' data/dev/raw/newsdev2020-$DIRECTION.ja.sgm > data/dev/raw/newsdev2020-$DIRECTION.ja.sgm.tmp

echo "removing non UTF8"
cat data/dev/raw/newsdev2020-$DIRECTION.en.sgm.tmp | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l en > data/dev/raw/newsdev2020-$DIRECTION.en.sgm.tmp1
cat data/dev/raw/newsdev2020-$DIRECTION.ja.sgm.tmp | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l ja > data/dev/raw/newsdev2020-$DIRECTION.ja.sgm.tmp1

echo "English only: normalizing punctuation"
cat data/dev/raw/newsdev2020-$DIRECTION.en.sgm.tmp1 | $BASE/libraries/moses/scripts/tokenizer/normalize-punctuation.perl -l en > $BASE/data/dev/preprocessed/newsdev2020-$DIRECTION.en

python3 scripts/preprocess_ja.py --input=data/dev/raw/newsdev2020-$DIRECTION.ja.sgm.tmp1 --output=data/dev/preprocessed/newsdev2020-$DIRECTION.ja

echo "clean up.."
rm data/dev/raw/*.tmp*

echo "Check out the data in data/dev/preprocessed/*.en and data/dev/preprocessed/*.ja"
