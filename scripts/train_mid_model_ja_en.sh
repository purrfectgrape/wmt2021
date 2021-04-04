DIR=`dirname "$0"`
BASE=$DIR/..
CONFIG=$BASE/configs/config_mid_ja_en.yaml
# onmt_build_vocab -config $CONFIG -n_sample -1
onmt_train -config $CONFIG
echo "finished training"