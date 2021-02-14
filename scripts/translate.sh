#! /bin/bash
# Author: Giang Le
# Bash script to evaluate models.

DIR=`dirname "$0"`
BASE=$DIR/..
i=0
for step in $BASE/model/romaji/model-romaji_step_*.pt; do
    onmt_translate -beam_size 5 -gpu=0 \
	    -model $step -src $BASE/data/test-bl-tok-bpe.ja -tgt $BASE/data/test-tok-bpe.en -output model/romaji/pred_$i -verbose && i=$((i+1))
done
