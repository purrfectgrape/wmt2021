 #!/bin/bash

DIR=`dirname "$0"`
BASE=$DIR/..

DATA_PATH = $BASE/data/sentence_filtered
DST_PATH = $BASE/sentencepiece
vocab_size=32000
spm_train --input=$BASE/data/sentence_filtered/mid_corpus.en --model_prefix=$BASE/vocab/en_mid \
        --vocab_size=$vocab_size --character_coverage=1
spm_train --input=$BASE/data/sentence_filtered/mid_corpus.ja --model_prefix=$BASE/vocab/ja_mid \
        --vocab_size=$vocab_size --character_coverage=1