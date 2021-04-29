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
	  if [[ -f $BASE/data/$OPTARG/transformer-base.ja ]]; then
            rm $BASE/data/$OPTARG/transformer-base.ja
          fi
          if [[ -f $BASE/data/$OPTARG/transformer-base.en ]]; then
            rm $BASE/data/$OPTARG/transformer-base.en
          fi
	  for corpus in paracrawl-all news-commentary wikititles wikimatrix subtitles kftt ted; do
            cat $BASE/data/$OPTARG/$corpus.ja >> $BASE/data/$OPTARG/transformer-base.ja
	    cat $BASE/data/$OPTARG/$corpus.en >> $BASE/data/$OPTARG/transformer-base.en
          done
	  echo "Total sents count for bitext data in Japanese: $(wc -l $BASE/data/$OPTARG/transformer-base.ja)"
	  echo "Total sents count for bitext data in English: $(wc -l $BASE/data/$OPTARG/transformer-base.en)"
        ;;   
        *)
	  echo "Invalid argument: $OPTARG. Usage: ./scripts/concatenate_bitext.sh -c train/raw. Argument must be one of train/raw, dev/raw, or test/raw" >&2
	;;
      esac
    ;;
    \?)
      echo "Invalid option: -$OPTARG. Specify a corpus using a -c flag. Usage: ./scripts/concatenate_bitext.sh -c train/raw. Argument must be one of train/raw, dev/raw, or test/raw" >&2
      exit 1
    ;;
  esac
done

