DIR=`dirname "$0"`
BASE=$DIR/..
CONFIG=$BASE/configs/hiragana_4m_ja_en.yaml
onmt_build_vocab -config $CONFIG -n_sample -1
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config $CONFIG
echo "finished training"
