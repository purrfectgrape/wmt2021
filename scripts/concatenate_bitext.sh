#! /bin/bash
# Author: Giang Le
# Write all bitext corpora to data/raw/wmt2021_bitext.{en|ja}

DIR=`dirname "$0"`
BASE=$DIR/..

echo "Concatenate all bitext corpora..."
while getopts ":c:" flag; do
  case $flag in
    c)
      case $OPTARG in
        train/raw | dev/raw | test/raw)
	  if [[ -f $BASE/data/$OPTARG/wmt2021-bitext.ja ]]; then
            rm $BASE/data/$OPTARG/wmt2021-bitext.ja
          fi
          if [[ -f $BASE/data/$OPTARG/wmt2021-bitext.en ]]; then
            rm $BASE/data/$OPTARG/wmt2021-bitext.en
          fi
	  for corpus in paracrawl news-commentary wikititles wikimatrix subtitles kftt ted dev; do
            cat $BASE/data/$OPTARG/$corpus.ja >> $BASE/data/$OPTARG/wmt2021-bitext.ja
	    cat $BASE/data/$OPTARG/$corpus.en >> $BASE/data/$OPTARG/wmt2021-bitext.en
          done
	  echo "Total sents count for bitext data in Japanese: $(wc -l $BASE/data/$OPTARG/wmt2021-bitext.ja)"
	  echo "Total sents count for bitext data in English: $(wc -l $BASE/data/$OPTARG/wmt2021-bitext.en)"
        ;;   
        *)
	  echo "Invalid argument: $OPTARG. Usage: ./scripts/concatenate_bitext.sh -c train/raw. Argument must be one of train/raw, dev/raw, or test/raw" >&2
	;;
      esac
    ;;
    \?)
      echo "Invalid option: -$OPTARG. Specify a corpus using a -c flag. Usage: ./scripts/concatenate_bitext.sh -c raw. Argument must be one of train/raw, dev/raw, or test/raw" >&2
      exit 1
    ;;
  esac
done

