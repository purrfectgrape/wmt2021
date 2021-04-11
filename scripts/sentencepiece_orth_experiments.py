#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sentencepiece as spm

print('build vocab for baseline model')
spm.SentencePieceTrainer.train(input='data/train/raw/sample-4m.en', model_prefix='sentencepiece/baseline_sample_4m.en', vocab_size=32000, character_coverage=1.0)
spm.SentencePieceTrainer.train(input='data/train/raw/sample-4m.ja', model_prefix='sentencepiece/baseline_sample_4m.ja', vocab_size=32000, character_coverage=1.0)

print('build vocab for hiragana model')
spm.SentencePieceTrainer.train(input='data/train/preprocessed/sample-4m-hiragana.en', model_prefix='sentencepiece/hiragana_sample_4m.en', vocab_size=32000, character_coverage=1.0)
spm.SentencePieceTrainer.train(input='data/train/preprocessed/sample-4m-hiragana.ja', model_prefix='sentencepiece/hiragana_sample_4m.ja', vocab_size=32000, character_coverage=1.0)
