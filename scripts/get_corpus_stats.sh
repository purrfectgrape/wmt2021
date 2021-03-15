#! /bin/bash
# Author: Giang Le
# Sentences count check for all corpora.

DIR=`dirname "$0"`
BASE=$DIR/..

echo "Printing the number of sentence pairs per parallel corpus..."

while getopts ":c:" flag; do
  case $flag in
    c)
      case $OPTARG in
        train/raw | dev/raw | test/raw)
	  for corpus in paracrawl news-commentary wikititles wikimatrix subtitles kftt ted dev; do
            if [[ ! -f $BASE/data/$OPTARG/$corpus.ja || ! -f $BASE/data/$OPTARG/$corpus.en ]]; then
	      echo "$BASE/data/$OPTARG/$corpus.ja"
              echo "$OPTARG $corpus: not found"
            else
              SENTS_COUNT_JA=$(wc -l < $BASE/data/$OPTARG/$corpus.ja)
              SENTS_COUNT_EN=$(wc -l < $BASE/data/$OPTARG/$corpus.en)
              echo "$OPTARG $corpus: $SENTS_COUNT_JA"
              echo "$OPTARG $corpus: $SENTS_COUNT_EN"
	      if [[ $SENTS_COUNT_JA != $SENTS_COUNT_EN ]]; then
                echo "Error. Sentence pairs counts don't match for $corpus."
	      fi
            fi
          done
        ;;   
        *)
	  echo "Invalid argument: $OPTARG. Usage: ./scripts/get_corpus_stats.sh -c raw. Argument must be one of train/raw, dev/raw, or test/raw or others" >&2
	;;
      esac
    ;;
    \?)
      echo "Invalid option: -$OPTARG. Specify a corpus using a -c flag. Usage: ./scripts/get_corpus_stats.sh -c raw. Argument must be one of train/raw, dev/raw, or test/raw" >&2
      exit 1
    ;;
  esac
done

