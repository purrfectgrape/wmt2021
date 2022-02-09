DIR=`dirname "$0"`
BASE=$DIR/..
for checkpoint in $BASE/models/alignment_4m_en_ja/alignment_4m_en_ja_step*.pt; do
   echo "# Translating with checkpoint $checkpoint"
   base=$(basename $checkpoint)
   $HOME/.local/bin/onmt_translate \
       -gpu 0 \
       -batch_size 100 -batch_type tokens \
       -beam_size 5 \
       -model $checkpoint \
       -src $BASE/data/wmt2021/mono/1000.en \
       -n_best 20\
       -verbose \
       -output translate/n_best/1000.ja
done