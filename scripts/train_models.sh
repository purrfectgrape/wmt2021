#! /bin/bash
# Author: Giang Le
# Bash script to train OpenNMT

DIR=`dirname "$0"`
BASE=$DIR/..

export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

source /opt/python/3.7/venv/pytorch1.3_cuda10.0/bin/activate

# Giang: replace the higher dir with a variable. OpenNMT is complaining to I'm writing in the path for now.
num_threads=5
device=0, 1

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads onmt_train -config=~/project-scripts-purrfectgrape/configs/bl_mixed_ja_en.yaml
