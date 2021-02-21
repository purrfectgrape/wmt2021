#! /bin/bash
# Author: Giang Le
# Bash script to process the retrieved corpus for Checkpoint 1.

DIR=`dirname "$0"`
BASE=$DIR/..

if [ -f $BASE/data/reuters-ja-en.txt.gz ]; then
echo "Preparing reuters data as train data..."
gunzip $BASE/data/reuters-ja-en.txt.gz
iconv -f EUC-JP -t UTF-8 < $BASE/data/reuters-ja-en.txt > $BASE/data/reuters-ja-en-decoded.txt

python3 $BASE/scripts/prepare_reuters_sents.py $BASE/data/reuters-ja-en-decoded.txt $BASE/data/reuters-ja-total.txt $BASE/data/reuters-en-total.txt
cat $BASE/data/reuters-ja-total.txt | head -n 50000 > $BASE/data/train-ja-raw.txt
cat $BASE/data/reuters-en-total.txt | head -n 50000 > $BASE/data/train-en-raw.txt
LC_TRAIN_EN=$(wc -l < $BASE/data/train-en-raw.txt)
LC_TRAIN_JA=$(wc -l < $BASE/data/train-ja-raw.txt)

echo "Preparing a part of reuters data as dev data..."
reuters_count=$(wc -l < $BASE/data/reuters-ja-total.txt)
cat $BASE/data/reuters-ja-total.txt | sed -n -e '50001,55000p' > $BASE/data/dev-ja-raw.txt
cat $BASE/data/reuters-en-total.txt | sed -n -e '50001,55000p' > $BASE/data/dev-en-raw.txt
LC_DEV_EN=$(wc -l < $BASE/data/dev-en-raw.txt)
LC_DEV_JA=$(wc -l < $BASE/data/dev-ja-raw.txt)

echo "Preparing a part of reuters data as test data..."
test_count=$((reuters_count - 55000))
cat $BASE/data/reuters-ja-total.txt | tail -n $test_count > $BASE/data/test-ja-raw.txt
cat $BASE/data/reuters-en-total.txt | tail -n $test_count > $BASE/data/test-en-raw.txt
LC_TEST_EN=$(wc -l < $BASE/data/test-en-raw.txt)
LC_TEST_JA=$(wc -l < $BASE/data/test-ja-raw.txt)
else
	echo "Skipping Reuters data processing because no data were found."
fi
#echo "Preparing Kyoto Free Translation Task data as test data..."
#tar -xzf $BASE/data/kyoto-en-ja.tar.gz
#mv $BASE/kftt-data-1.0/data/orig/kyoto-test.en $BASE/data/test-en-raw.txt
#mv $BASE/kftt-data-1.0/data/orig/kyoto-test.ja $BASE/data/test-ja-raw.txt
#LC_TEST_EN=$(wc -l < $BASE/data/test-en-raw.txt)
#LC_TEST_JA=$(wc -l < $BASE/data/test-ja-raw.txt)

if [ -f $BASE/data/paracrawl-en-ja.tar.gz ]; then
echo "Preparing Paracrawl data as full data..."
tar -xzf $BASE/data/paracrawl-en-ja.tar.gz
mv $BASE/en-ja/en-ja.bicleaner05.txt $BASE/data/paracrawl-en-ja.txt
cut -f2,3 $BASE/data/paracrawl-en-ja.txt > $BASE/data/paracrawl-en-raw.txt
awk -F'\t' '$1 >= 0.777' $BASE/data/paracrawl-en-raw.txt | cut -f2 > $BASE/data/paracrawl-en-shortened.txt
cut -f2,4 $BASE/data/paracrawl-en-ja.txt > $BASE/data/paracrawl-ja-raw.txt
awk -F'\t' '$1 >= 0.777' $BASE/data/paracrawl-ja-raw.txt | cut -f2 > $BASE/data/paracrawl-ja-shortened.txt
LC_PARACRAWL_EN=$(wc -l < $BASE/data/paracrawl-en-shortened.txt)
LC_PARACRAWL_JA=$(wc -l < $BASE/data/paracrawl-ja-shortened.txt)

echo "Preparing Paracrawl data as train data..."
cat $BASE/data/paracrawl-ja-shortened.txt | head -n 1292000 > $BASE/data/train-para-ja-raw.txt
cat $BASE/data/paracrawl-en-shortened.txt | head -n 1292000 > $BASE/data/train-para-en-raw.txt
LC_TRAIN_PARA_EN=$(wc -l < $BASE/data/train-para-en-raw.txt)
LC_TRAIN_PARA_JA=$(wc -l < $BASE/data/train-para-ja-raw.txt)

echo "Preparing Paracrawl data as dev data..."
paracrawl_count=$(wc -l < $BASE/data/paracrawl-en-shortened.txt)
cat $BASE/data/paracrawl-ja-shortened.txt | sed -n -e '1292001,1297000p' > $BASE/data/dev-para-ja-raw.txt
cat $BASE/data/paracrawl-en-shortened.txt | sed -n -e '1292001,1297000p' > $BASE/data/dev-para-en-raw.txt
LC_DEV_PARA_EN=$(wc -l < $BASE/data/dev-para-en-raw.txt)
LC_DEV_PARA_JA=$(wc -l < $BASE/data/dev-para-ja-raw.txt)

echo "Preparing Paracrawl data as test data..."
test_para_count=$((paracrawl_count - 1297000))
cat $BASE/data/paracrawl-ja-shortened.txt | tail -n $test_para_count > $BASE/data/test-para-ja-raw.txt
cat $BASE/data/paracrawl-en-shortened.txt | tail -n $test_para_count > $BASE/data/test-para-en-raw.txt
LC_TEST_PARA_EN=$(wc -l < $BASE/data/test-para-en-raw.txt)
LC_TEST_PARA_JA=$(wc -l < $BASE/data/test-para-ja-raw.txt)

else
	echo "Skipping Paracrawl data processing because no data were found."
fi

echo "Total number of JA REUTERS TRAIN sentences is $LC_TRAIN_JA"
echo "Total number of EN REUTERS TRAIN sentences is $LC_TRAIN_EN"
echo "Total number of JA REUTERS DEV sentences is $LC_DEV_JA"
echo "Total number of EN REUTERS DEV sentences is $LC_DEV_EN"
echo "Total number of JA REUTERS TEST sentences is $LC_TEST_JA"
echo "Total number of EN REUTERS TEST sentences is $LC_TEST_EN"
echo "Total number of JA PARACRAWL TRAIN sentences is $LC_TRAIN_PARA_JA"
echo "Total number of EN PARACRAWL TRAIN sentences is $LC_TRAIN_PARA_EN"
echo "Total number of JA PARACRAWL DEV sentences is $LC_DEV_PARA_JA"
echo "Total number of EN PARACRAWL DEV sentences is $LC_DEV_PARA_EN"
echo "Total number of JA PARACRAWL TEST sentences is $LC_TEST_PARA_JA"
echo "Total number of EN PARACRAWL TEST sentences is $LC_TEST_PARA_EN"

# Do copying for baseline and experiments for Japanese
#mv $BASE/data/train-ja-raw.txt $BASE/data/train-bl-ja-raw.txt
#cp $BASE/data/train-bl-ja-raw.txt $BASE/data/train-exp-ja-raw.txt
#mv $BASE/data/dev-ja-raw.txt $BASE/data/dev-bl-ja-raw.txt
#cp $BASE/data/dev-bl-ja-raw.txt $BASE/data/dev-exp-ja-raw.txt
#mv $BASE/data/test-ja-raw.txt $BASE/data/test-bl-ja-raw.txt
#cp $BASE/data/test-bl-ja-raw.txt $BASE/data/test-exp-ja-raw.txt

#mv $BASE/data/train-para-ja-raw.txt $BASE/data/train-para-bl-ja-raw.txt
#cp $BASE/data/train-para-bl-ja-raw.txt $BASE/data/train-para-exp-ja-raw.txt
#mv $BASE/data/dev-para-ja-raw.txt $BASE/data/dev-para-bl-ja-raw.txt
#cp $BASE/data/dev-para-bl-ja-raw.txt $BASE/data/dev-para-exp-ja-raw.txt
#mv $BASE/data/test-para-ja-raw.txt $BASE/data/test-para-bl-ja-raw.txt
#cp $BASE/data/test-para-bl-ja-raw.txt $BASE/data/test-para-exp-ja-raw.txt
