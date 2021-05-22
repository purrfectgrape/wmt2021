python3 scripts/lang_id.py --conf_score=0.80
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.en > data/train/raw/wmt2021-bitext-langid-filtered-cln.en
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.ja > data/train/raw/wmt2021-bitext-langid-filtered-cln.ja
scripts/preprocess_en.sh -c wmt2021-bitext
python3 scripts/preprocess_ja.py --input=/nas/models/experiment/ja-en/wmt2021/data/train/raw/wmt2021-bitext-langid-filtered-cln.ja --output=/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja
spm_train --input=data/train/preprocessed/wmt2021-bitext.en --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=1 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.en
spm_train --input=data/train/preprocessed/wmt2021-bitext.ja --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=0.9995 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.ja
spm_encode --model=sentencepiece/transformer_big.en.model --output_format=piece < data/train/preprocessed/wmt2021-bitext.en | sed 's/▁//g' > data/alignment/fast_align.en
spm_encode --model=sentencepiece/transformer_big.ja.model --output_format=piece < data/train/preprocessed/wmt2021-bitext.ja | sed 's/▁//g' > data/alignment/fast_align.ja
python3 scripts/prepare_align_bitext.py
