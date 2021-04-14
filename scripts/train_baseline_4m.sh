DIR=`dirname "$0"`
BASE=$DIR/..
CONFIG=$BASE/configs/baseline_4m_ja_en.yaml
$HOME/.local/bin/onmt_build_vocab -config $CONFIG -n_sample -1
$HOME/.local/bin/onmt_train -config $CONFIG
echo "Finished training"

