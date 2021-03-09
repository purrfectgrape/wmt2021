#! /bin/bash
# Author: Giang Le
# Date: Mar 9, 2021.
# Bash script to retrieve the available datasets for the Japanese-English language pair,
# provided by the WMT 2021's organizers.
# Usage: sh get_data.sh paracrawl

DIR=`dirname "$0"`
BASE=$DIR/..

# Check number of required arguments.
if [ $# -ne 1 ]; then
    echo "Usage: $0 corpus_name" 1>&2
    exit 1
fi

# Make a new wmt2021 directory if it hasn't existed before.
if [ ! -d $BASE/data/wmt2021 ]; then
  mkdir $BASE/data/wmt2021
fi

# Function to download datasets and unzip them.
function download {
    echo "Downloading $1 corpus..."
    wget $(data_loc $1) -P $BASE/data/wmt2021
    echo "Unzipping $1 corpus..."
    FILENAME=$(basename $(data_loc $1))
    tar -xf $BASE/data/wmt2021/$FILENAME --directory $BASE/data/wmt2021
    echo "Done! Check in $BASE/data/wmt2021 for the downloaded data"
}

# Datasets and URLs.
function data_loc {
    # parallel training data
    if [ $1 = "reuters" ]; then
        echo "https://www2.nict.go.jp/astrec-att/member/mutiyama/jea/reuters/reuters-je-11.txt.gz"
    fi
    if [ $1 = "wikimatrix" ]; then
        echo "http://data.statmt.org/wmt20/translation-task/WikiMatrix/WikiMatrix.v1.en-ja.langid.tsv.gz"
    fi
    if [ $1 = "kftt" ]; then
        echo "http://www.phontron.com/kftt/download/kftt-data-1.0.tar.gz"
    fi
    if [ $1 = "ted" ]; then
        echo "https://wit3.fbk.eu/archive/2017-01-trnted//texts/en/ja/en-ja.tgz"
    fi
    if [ $1 = "newscommentary" ]; then
        echo "http://data.statmt.org/news-commentary/v15/training/news-commentary-v15.en-ja.tsv.gz"
    fi
    if [ $1 = "wikititles" ]; then
        echo "http://data.statmt.org/wikititles/v2/wikititles-v2.ja-en.tsv.gz"
    fi
    if [ $1 = "subtitles" ]; then
        echo "https://nlp.stanford.edu/projects/jesc/data/split.tar.gz"
    fi
    if [ $1 = "paracrawl" ]; then
        echo "http://www.kecl.ntt.co.jp/icl/lirg/jparacrawl/release/2.0/bitext/en-ja.tar.gz"
    fi
    # monolingual data
    if [ $1 = "commoncrawl-ja" ]; then
        echo "http://web-language-models.s3-website-us-east-1.amazonaws.com/ngrams/ja/deduped/ja.deduped.xz"
    fi
    if [ $1 = "commoncrawl-en" ]; then
        echo "http://web-language-models.s3-website-us-east-1.amazonaws.com/wmt16/deduped/en-new.xz"
    fi
    # dev sets
    if [ $1 = "dev" ]; then
        echo "http://data.statmt.org/wmt20/translation-task/dev.tgz"
    fi
}

download $1

