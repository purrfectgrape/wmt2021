awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.en > data/train/raw/wmt2021-bitext-langid-filtered-cln.en
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.ja > data/train/raw/wmt2021-bitext-langid-filtered-1.ja
cat data/train/raw/wmt2021-bitext-langid-filtered-1.ja | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l ja > data/train/raw/wmt2021-bitext-langid-filtered-cln.ja
rm data/train/raw/wmt2021-bitext-langid-filtered-1.ja
scripts/preprocess_en.sh -c wmt2021-bitext
python3 scripts/preprocess_ja.py --input=/nas/models/experiment/ja-en/wmt2021/data/train/raw/wmt2021-bitext-langid-filtered-cln.ja --output=/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja
spm_train --input=data/train/preprocessed/wmt2021-bitext.en --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=1 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.en
spm_train --input=data/train/preprocessed/wmt2021-bitext.ja --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=0.9995 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.ja
scripts/train.sh configs/transformer_big_ja_en.yaml 0,1,2,3
