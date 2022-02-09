#! /bin/bash
DIR=`dirname "$0"`
BASE=$DIR/..

$HOME/.local/bin/onmt_translate \
        -gpu $1 \
        -batch_size 2000 -batch_type tokens \
	-seed $5 \
        -beam_size 10 \
        -model models/transformer_big/$2 models/transformer_big/$6 models/transformer_big/$7 \
	-n_best 10 \
        -src data/wmt2021/test/test-src/newstest2021.$3-$4.$3.sp \
        -output $BASE/submissions/sp/"$2"."$6"."$7".10hyp."$4".sp

echo "decoding SP-segmented text"
    spm_decode \
        -model=$BASE/sentencepiece/transformer_big.$4.model \
        -input_format=piece \
        < $BASE/submissions/sp/"$2"."$6"."$7".10hyp."$4".sp \
        > $BASE/submissions/text/"$2"."$6"."$7".10hyp."$4"
