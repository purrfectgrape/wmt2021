#! /bin/bash
# Author: Giang Le
# Date: Mar 9, 2021.
# Bash script to retrieve the available datasets for the Japanese-English language pair,
# provided by the WMT 2021's organizers. Visit http://www.statmt.org/wmt21/translation-task.html for the latest datasets.
# Usage: ./scripts/get_data.sh -c paracrawl

DIR=`dirname "$0"`
BASE=$DIR/..

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 -c paracrawl. Argument must be one of paracrawl, news-commentary, wikititles, wikimatrix, subtitles, kftt, ted, newscrawl-ja, news-commentary-ja, commoncrawl-ja, newscrawl-en, news-discussion-en, europarl-en, news-commentary-en, commoncrawl-en, or dev" >&2
  exit 1
fi

# Make a new wmt2021 directory if it hasn't existed before.
if [[ ! -d $BASE/data/wmt2021 ]]; then
  mkdir $BASE/data/wmt2021
fi

# Function to check if resulting file exists
does_exist() {
  FILENAME=$(basename $(data_loc $1))
  if [[ -d $BASE/data/wmt2021/$1/$FILENAME ]] || [[ -f $BASE/data/wmt2021/$1/$FILENAME ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Function to download datasets
download() {
  # Create new directory if data are downloaded for the first time.
  if [[ ! -d $BASE/data/wmt2021/$1 ]]; then
    mkdir $BASE/data/wmt2021/$1
  fi
  FILENAME=$(basename $(data_loc $1))
  echo "Downloading $1 corpus..."
  if [[ $(data_loc $1) == 1gFeuPTRc3RB4DhJEkhr8O-a8PObM7Ix2 ]]; then
    gdown --id $(data_loc $1) -O $BASE/data/wmt2021/$1/XML_releases.tgz
  else
    wget $(data_loc $1) -P $BASE/data/wmt2021/$1
  fi
  echo "Done downloading $1 corpus. Saved in $BASE/data/wmt2021/$1"
}

# Function to unzip files.
unzip() {
  echo "Unzipping $1 corpus..."
  FILENAME=$(basename $(data_loc $1))
  if [[ $(data_loc $1) != 1gFeuPTRc3RB4DhJEkhr8O-a8PObM7Ix2 ]]; then
    if [[ $FILENAME == *".tar.gz" ]] || [[ $FILENAME == *".tgz" ]]; then
      tar -xf $BASE/data/wmt2021/$1/$FILENAME --directory $BASE/data/wmt2021/$1
    elif [[ $FILENAME == *".tsv.gz" ]] || [[ $FILENAME == *".gz" ]]; then
      gzip -d $BASE/data/wmt2021/$1/$FILENAME
    elif [[ $FILENAME == *".xz" ]]; then
      xz -d $BASE/data/wmt2021/$1/$FILENAME
    fi
  else
    tar -xf $BASE/data/wmt2021/$1/XML_releases.tgz --directory $BASE/data/wmt2021/$1
  fi
  echo "Done unzipping! Run ls $BASE/data/wmt2021/$1 to inspect the unzipped data"
}

# Datasets and URLs. Update these lines if file location changes!
data_loc() {
    # parallel training data
    if [[ $1 == "paracrawl" ]]; then
        echo "http://www.kecl.ntt.co.jp/icl/lirg/jparacrawl/release/2.0/bitext/en-ja.tar.gz"
    fi
    if [[ $1 == "news-commentary" ]]; then
        echo "http://data.statmt.org/news-commentary/v16/training/news-commentary-v16.en-ja.tsv.gz"
    fi
    if [[ $1 == "wikititles" ]]; then
        echo "http://data.statmt.org/wikititles/v3/wikititles-v3.ja-en.tsv"
    fi
    if [[ $1 == "wikimatrix" ]]; then
        echo "http://data.statmt.org/wmt21/translation-task/WikiMatrix/WikiMatrix.v1.en-ja.langid.tsv.gz"
    fi
    if [[ $1 == "subtitles" ]]; then
        echo "https://nlp.stanford.edu/projects/jesc/data/raw.tar.gz"
    fi
    if [[ $1 == "kftt" ]]; then
        echo "http://www.phontron.com/kftt/download/kftt-data-1.0.tar.gz"
    fi
    if [[ $1 == "ted" ]]; then
	# Ted talks data are shared via Google Drive so we will download it with gdown and by the file id.
        echo "1gFeuPTRc3RB4DhJEkhr8O-a8PObM7Ix2"
	#echo "http://data.statmt.org/wmt20/translation-task/ja-en/ted.en-ja.tgz"
    fi

    # monolingual data
    if [[ $1 == "newscrawl-ja" ]]; then
	echo "http://data.statmt.org/news-crawl/ja/news.2020.ja.shuffled.deduped.gz"
    fi
    if [[ $1 == "news-commentary-ja" ]]; then
        echo "http://data.statmt.org/news-commentary/v16/training-monolingual/news-commentary-v16.ja.gz"
    fi
    if [[ $1 == "commoncrawl-ja" ]]; then
        echo "http://web-language-models.s3-website-us-east-1.amazonaws.com/ngrams/ja/deduped/ja.deduped.xz"
    fi
    if [[ $1 == "newscrawl-en" ]]; then
	echo "http://data.statmt.org/news-crawl/en/news.2020.en.shuffled.deduped.gz"
    fi
    if [[ $1 == "news-discussion-en" ]]; then
	echo "http://data.statmt.org/news-discussions/en/news-discuss.2019.en.filtered.gz"
    fi
    if [[ $1 == "europarl-en" ]]; then
	echo "http://www.statmt.org/europarl/v10/training-monolingual/europarl-v10.en.tsv.gz"
    fi
    if [[ $1 == "news-commentary-en" ]]; then
        echo "http://data.statmt.org/news-commentary/v16/training-monolingual/news-commentary-v16.en.gz"
    fi
    if [[ $1 == "commoncrawl-en" ]]; then
        echo "http://web-language-models.s3-website-us-east-1.amazonaws.com/wmt16/deduped/en-new.xz"
    fi

    # dev sets
    if [[ $1 == "dev" ]]; then
        echo "http://data.statmt.org/wmt20/translation-task/dev.tgz"
    fi

    # test sets
    if [[ $1 == "test" ]]; then
	echo "http://data.statmt.org/wmt20/translation-task/test.tgz"
    fi
}

#########################
# Main script starts here

while getopts ":c:" flag; do
  case $flag in
    c)
      case $OPTARG in
        test | paracrawl | news-commentary | wikititles | wikimatrix | subtitles | kftt | ted | newscrawl-ja | news-commentary-ja | commoncrawl-ja | newscrawl-en | news-discussion-en | europarl-en | news-commentary-en | commoncrawl-en | dev)
	  if [[ $(does_exist $OPTARG) == "true" ]]; then
	    echo "File already exists. If you want to overwrite, remove the directory $BASE/data/wmt2021/$OPTARG with rm -rf $BASE/data/wmt2021/$OPTARG and run again."
	    exit 1
    	  else
            download $OPTARG
	    unzip $OPTARG
	  fi
	;;
	*)
	  echo "Invalid argument: $OPTARG. Usage: ./scripts/get_data.sh -c paracrawl. Argument must be one of paracrawl, news-commentary, wikititles, wikimatrix, subtitles, kftt, ted, newscrawl-ja, news-commentary-ja, commoncrawl-ja, newscrawl-en, news-discussion-en, europarl-en, news-commentary-en, commoncrawl-en, or dev" >&2
    	;;
      esac
    ;;
    \?)
      echo "Invalid option: -$OPTARG. Specify a corpus using a -c flag. Usage: ./scripts/get_data.sh -c paracrawl. Argument must be one of paracrawl, news-commentary, wikititles, wikimatrix, subtitles, kftt, ted, newscrawl-ja, news-commentary-ja, commoncrawl-ja, newscrawl-en, news-discussion-en, europarl-en, news-commentary-en, commoncrawl-en, or dev" >&2
      exit 1
    ;;
  esac
done

