echo "Train with config $1"
$HOME/.local/bin/onmt_build_vocab -config $1 -n_sample -1
CUDA_VISIBLE_DEVICES=$2 $HOME/.local/bin/onmt_train -config $1
echo "Finished training"
