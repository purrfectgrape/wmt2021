# Documentation for final submission's models

## Execute scripts from wmt2021/ directory
cd //nas/models/experiment/ja-en/wmt2021

## Get all data from WMT 2021 (Would take about 7 or 8 hours)
./scripts/get_all_wmt2021.sh <br>
(To get individual corpora: run ./scripts/get_data.sh -c ted for example)

## Extract sentences from each corpus

### Download ted talks processing tools
gdown --id 1-wmonUKD3WBy8va8_88O9UcSSw2Wy4zj <br>
unzip tools_2012.zip -d libraries/ted_tools <br>
rm tools_2012.zip <br>

### Training data
python3 scripts/extract_wikimatrix.py --threshold=1.0 --src-lang=en --trg-lang=ja --tsv=data/wmt2021/wikimatrix/WikiMatrix.v1.en-ja.langid.tsv --bitext=data/train/raw/wikimatrix<br>
<br>
python3 scripts/extract_paracrawl.py --txt data/wmt2021/paracrawl/en-ja/en-ja.bicleaner05.txt --bitext data/train/raw/paracrawl --threshold=0.600<br>
<br>
python3 scripts/extract_ted.py --jaen=data/wmt2021/ted/2017-01-trnted/texts/ja/en/ja-en.tgz --enja=data/wmt2021/ted/2017-01-trnted/texts/en/ja/en-ja.tgz --out_dir=data/train/raw<br>
<br>
python3 scripts/extract_kftt.py --in_dir=data/wmt2021/kftt/kftt-data-1.0/data --out_dir=data/train/raw (this is for orig data. for tok type, specify --type=tok)<br>
<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/subtitles/raw/raw --bitext=data/train/raw/subtitles<br>
<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/news-commentary/news-commentary-v16.en-ja.tsv --bitext=data/train/raw/news-commentary<br>
<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/wikititles/wikititles-v3.ja-en.tsv --bitext=data/train/raw/wikititles<br>
<br>
### Dev data
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --tgt --type=dev<br>
<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --src  --type=dev<br>
<br>
### Test data
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --tgt --type=test<br>
<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --src --type=test<br>
<br>
## Sanity check
./scripts/get_corpus_stats.sh -c train/raw<br>
<br>
## Concatenate raw corpora for train
./scripts/concatenate_bitext.sh -c train/raw <br>
<br>

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin<br>

## Filter by lang-id
python3 scripts/lang_id.py --conf_score=0.80 <br>
The amount of training data after filtering should be 12.7M

## Get rid of extra whitespaces
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.en > data/train/raw/wmt2021-bitext-langid-filtered-cln.en  <br>
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.ja > data/train/raw/wmt2021-bitext-langid-filtered-cln.ja <br>


## Preprocess English (punc and non-printing char norm)
scripts/preprocess_en.sh -c wmt2021-bitext

## Preprocess Japanese
Also: steps to test this script:
cat data/train/raw/wmt2021-bitext-langid-filtered.ja | grep "(.\*)" | head -n 1000 > testfile.ja <br>
python3 scripts/preprocess_ja.py --input=testfile.ja --output=out.ja <br>
diff -y --color testfile.ja out.ja --suppress-common-lines -W 150 --color=auto | grep "(.\*)" <br>

Note that for JA>EN, we only remove the English in parentheses. We don't normalize katakana. <br>
python3 scripts/preprocess_ja.py --input=/nas/models/experiment/ja-en/wmt2021/data/train/raw/wmt2021-bitext-langid-filtered-cln.ja --output=/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja

## Train sentencepiece
spm_train --input=data/train/preprocessed/wmt2021-bitext.en --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=1 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.en <br>
<br>
spm_train --input=data/train/preprocessed/wmt2021-bitext.ja --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=0.9995 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.ja <br>
<br>

## Create file for fast_align from sentencepiece models
spm_encode --model=sentencepiece/transformer_big.en.model --output_format=piece < data/train/preprocessed/wmt2021-bitext.en | sed 's/▁//g' > data/alignment/fast_align.en <br>
<br>
spm_encode --model=sentencepiece/transformer_big.ja.model --output_format=piece < data/train/preprocessed/wmt2021-bitext.ja | sed 's/▁//g' > data/alignment/fast_align.ja <br>
<br>
python3 scripts/prepare_align_bitext.py <br>
<br>

## Apply politeness and formality tags
python scripts/pofo_tagger_simple.py --corpus=data/train/preprocessed/wmt2021-bitext

## Run fast_align
cd libraries/fast_align/build <br>
cmake .. <br>
make <br>

./fast_align -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align.bitext -d -o -v > //nas/models/experiment/ja-en/wmt2021/data/alignment/enja.align  <br>
./fast_align -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align.bitext -d -o -v -r > //nas/models/experiment/ja-en/wmt2021/data/alignment/jaen.align
<br>
