#! /bin/bash
# Author: Giang Le
# Bash script to retrieve data from different websites, provided by WMT 2020.
# Small data set for Checkpoint 1: Reuters data from https://www2.nict.go.jp/astrec-att/member/mutiyama/jea/reuters/ (50k sentences)
# Usage: sh get_data.sh -c paracrawl

DIR=`dirname "$0"`
BASE=$DIR/..

if [ ! -d $BASE/data ]; then
  mkdir $BASE/data
fi

while getopts ":c:" opt; do
  case $opt in
    c)
      case $OPTARG in
        reuters)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget https://www2.nict.go.jp/astrec-att/member/mutiyama/jea/$OPTARG/reuters-je-11.txt.gz
          mv reuters-je-11.txt.gz $BASE/data/reuters-ja-en.txt.gz
	  rm -rf en-ja
	  if [ -f $BASE/data/reuters-ja-en.txt.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        wikimatrix)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget http://data.statmt.org/wmt20/translation-task/WikiMatrix/WikiMatrix.v1.en-ja.langid.tsv.gz
          mv WikiMatrix.v1.en-ja.langid.tsv.gz $BASE/data/wikimatrix-en-ja.tsv.gz
	  if [ -f $BASE/data/wikimatrix-en-ja.tsv.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        kyoto)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget http://www.phontron.com/kftt/download/kftt-data-1.0.tar.gz
          mv kftt-data-1.0.tar.gz $BASE/data/kyoto-en-ja.tar.gz
          rm -rf kftt-data-1.0
	  if [ -f $BASE/data/kyoto-en-ja.tar.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        newscommentary)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget http://data.statmt.org/news-commentary/v15/training/news-commentary-v15.en-ja.tsv.gz
          mv news-commentary-v15.en-ja.tsv.gz $BASE/data/newscommentary-en-ja.tsv.gz
	  if [ -f $BASE/data/newscommentary-en-ja.tsv.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        wikititles)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget http://data.statmt.org/wikititles/v2/wikititles-v2.ja-en.tsv.gz
          mv wikititles-v2.ja-en.tsv.gz $BASE/data/wikititles-ja-en.tsv.gz
	  if [ -f $BASE/data/wikititles-ja-en.tsv.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        subtitles)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget https://nlp.stanford.edu/projects/jesc/raw.tar.gz
          mv raw.tar.gz $BASE/data/subtitles-en-ja.tar.gz
	  if [ -f $BASE/data/subtitles-en-ja.tar.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        paracrawl)
          echo "Retrieving corpus from: $OPTARG" >&2
          wget http://www.kecl.ntt.co.jp/icl/lirg/jparacrawl/release/2.0/bitext/en-ja.tar.gz
          mv en-ja.tar.gz $BASE/data/paracrawl-en-ja.tar.gz
	  rm -rf en-ja.tar.gz
	  if [ -f $BASE/data/paracrawl-en-ja.tar.gz ]; then
    		echo "Data successfully downloaded."
	  else
    		echo "Data not successfully downloaded."
    	  exit
	  fi
          ;;
        *)
          echo "Available data are reuters, wikimatrix, kyoto, newscommentary, wikititles, subtitles, paracrawl."
          ;;
      esac
      ;;
    \?)
      echo "Usage: cmd [-c]"
      echo "Available data are reuters, wikimatrix, kyoto, newscommentary, wikititles, subtitles, paracrawl."
      ;;
  esac
done
