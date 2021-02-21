#! /bin/bash
# Author: Giang Le
# This script unzips and selects a small subset of the Paracrawl and Reuters corpora to use as a small corpus for training, dev, and test of a starter model.

DIR=`dirname "$0"`
BASE=$DIR/..
RAW=$DIR/data/raw
TRAIN=$DIR/data/train
DEV=$DIR/data/dev
TEST=$DIR/data/test

if [ ! -d $BASE/data/raw ]; then
  mkdir $BASE/data/raw
fi

if [ -f $BASE/data/reuters-ja-en.txt.gz ]; then
echo "Unzip the Reuters corpus and decode from EUC-JP to UTF-8"
gunzip $BASE/data/reuters-ja-en.txt.gz
iconv -f EUC-JP -t UTF-8 < $BASE/data/reuters-ja-en.txt > $BASE/data/reuters-ja-en-decoded.txt

echo "Write Reuters corpus to Japanese and English files."
python3 $BASE/scripts/prepare_reuters_sents.py $BASE/data/reuters-ja-en-decoded.txt $BASE/data/raw/reuters-ja.txt $BASE/data/raw/reuters-en.txt

# Clean up
rm $BASE/data/reuters-ja-en*

else
    echo "No reuters corpus found. Run sh get_data.sh -c reuters first to download."
fi

if [ -f $BASE/data/paracrawl-en-ja.tar.gz ]; then
echo "Unzip Paracrawl. See data/paracrawl-en-ja.txt for the data"
tar -xzf $BASE/data/paracrawl-en-ja.tar.gz
mv $BASE/scripts/en-ja/en-ja.bicleaner05.txt $BASE/data/paracrawl-en-ja.txt
rm -rf $BASE/scripts/en-ja
#cut -f2,3 $BASE/data/paracrawl-en-ja.txt > $BASE/data/raw/paracrawl-en.txt
##awk -F'\t' '$1 >= 0.777' $BASE/data/paracrawl-en-raw.txt | cut -f2 > $BASE/data/paracrawl-en-shortened.txt
#cut -f2,4 $BASE/data/paracrawl-en-ja.txt > $BASE/data/raw/paracrawl-ja.txt
##awk -F'\t' '$1 >= 0.777' $BASE/data/paracrawl-ja-raw.txt | cut -f2 > $BASE/data/paracrawl-ja-shortened.txt
else
    echo "Skipping Paracrawl data processing because no data were found."
fi
