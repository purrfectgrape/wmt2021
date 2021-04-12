DIR=`dirname "$0"`
BASE=$DIR/..
CONFIG=$BASE/configs/config_mid_en_ja.yaml
onmt_build_vocab -config $CONFIG -n_sample -1
onmt_train -config $CONFIG
echo "finished training"
