# Steps to prepare a full-sized model

cd //nas/models/experiment/ja-en/wmt2021

## Get all data from WMT 2021 (Would take about 7 or 8 hours)
./scripts/get_all_wmt2021.sh
(To get individual corpora: run **./scripts/get_data.sh -c ted** for example)

## Extract sentences from each corpus
python3 scripts/extract_wikimatrix.py --src-lang=en --trg-lang=ja --tsv=data/wmt2021/wikimatrix/WikiMatrix.v1.en-ja.langid.tsv --bitext=data/train/raw/wikimatrix
python3 scripts/extract_paracrawl.py --txt data/wmt2021/paracrawl/en-ja/en-ja.bicleaner05.txt --bitext data/train/raw/paracrawl --threshold=0.730
python3 scripts/extract_ted.py --jaen=data/wmt2021/ted/2017-01-trnted/texts/ja/en/ja-en.tgz --enja=data/wmt2021/ted/2017-01-trnted/texts/en/ja/en-ja.tgz --out_dir=data/train/raw
python3 scripts/extract_kftt.py --in_dir=data/wmt2021/kftt/kftt-data-1.0/data --out_dir=data/train/raw (this is for orig data. for tok type, specify --type=tok)
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/subtitles/raw/raw --bitext=data/train/raw/subtitles
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/news-commentary/news-commentary-v16.en-ja.tsv --bitext=data/train/raw/news-commentary
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/wikititles/wikititles-v3.ja-en.tsv --bitext=data/train/raw/wikititles

## Sanity check
./scripts/get_corpus_stats.sh -c train/raw

## Concatenate raw corpora for train
./scripts/concatenate_bitext.sh -c train/raw

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

## Filter by lang-id
python3 scripts/lang_id.py --conf_score=0.85 (I used a lower threshold because when I set the threshold to 0.9 only 6.4M sentence pairs were left. This script took a while to run)

## Preprocess EN data with Moses
./scripts/moses_en.sh -c wmt2021-bitext

## Preprocess JA data with fugashi
python3 scripts/tokenize_japanese.py --input=data/train/raw/wmt2021-bitext-langid-filtered.ja --output=data/train/preprocessed/wmt2021-bitext-tok.ja

## Learn bpe for both
./scripts/learn_bpe.sh -l ja
./scripts/learn_bpe.sh -l en

## Preprocess development set

## Build vocab

# Steps to train a mid-sized model (as of Mar 7, 2021)

cd //nas/models/experiment/ja-en/wmt2021

## Download the parallel data
sh scripts/get_data.sh -c reuters
sh scripts/get_data.sh -c wikimatrix
sh scripts/get_data.sh -c paracrawl
sh scripts/get_data.sh -c newscommentary

## Write the lines to English and Japanese files
sh scripts/preprocess_small_sample.sh

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

## Filtering based on lang identification (0.9 for all four corpora)
scripts/lang_id.py -a data/raw/newscommentary.ja -b data/raw/newscommentary.en
scripts/lang_id.py -a data/raw/reuters.ja -b data/raw/reuters.en
scripts/lang_id.py -a data/raw/paracrawl.ja -b data/raw/paracrawl.en
scripts/lang_id.py -a data/raw/wikimatrix.ja -b data/raw/wikimatrix.en

## Copy moses scripts to libraries
git clone https://github.com/bricksdont/moses-scripts libraries/moses

## Preprocessing the English data with Moses
sh scripts/moses_en.sh -c reuters
sh scripts/moses_en.sh -c newscommentary
sh scripts/moses_en.sh -c wikimatrix
sh scripts/moses_en.sh -c paracrawl

## Filter newsdev data (preprocessed by Shinka)
cat /nas/models/experiment/ja-en/wmt2021/data/test/wmt2020/enja/newstest2020-enja-ref.ja.sgm_cln.txt | sed '/^$/d' | grep -v "＜道新スポーツ９月２７日掲 載＞" > /nas/models/experiment/ja-en/wmt2021/data/raw/dev/newsdev2020-filtered.ja
cat /nas/models/experiment/ja-en/wmt2021/data/wmt2020_dev/enja/newsdev2020-enja-src.en.sgm_cln.txt | sed '/^$/d' > /nas/models/experiment/ja-en/wmt2021/data/raw/dev/newsdev2020-filtered.en

## Preprocess the newsdev data
sh scripts/moses_en.sh -c dev/newsdev2020

## Combine training corpora
cat /nas/models/experiment/ja-en/wmt2021/data/preprocessed/*tok.en > /nas/models/experiment/ja-en/wmt2021/data/preprocessed/corpus_mid.en
cat /nas/models/experiment/ja-en/wmt2021/data/sentence_filtered/*filtered_tok.ja > /nas/models/experiment/ja-en/wmt2021/data/preprocessed/corpus_mid.ja

## Tokenize the newsdev data using fugashi
python3 scripts/tokenize_japanese.py dev/newsdev2020-filtered
mv data/raw/dev/newsdev2020-filtered-tok.ja data/preprocessed/dev/newsdev2020-tok.ja

## The training data can be found in data/preprocessed/corpus_mid.{en|ja} and the dev data can be found in data/preprocessed/dev/

source /opt/python/3.7/venv/pytorch1.3_cuda10.0/bin/activate

## Build vocab
onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/preprocessed/corpus_mid.ja -train_tgt //nas/models/experiment/ja-en/wmt2021/data/preprocessed/corpus_mid.en -valid_src //nas/models/experiment/ja-en/wmt2021/data/preprocessed/dev/newsdev2020-tok.ja -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/preprocessed/dev/newsdev2020-tok.en -save_data //nas/models/experiment/ja-en/wmt2021/data/opennmt-vocab/corpus_mid -overwrite

## Train the model
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config=configs/corpus_mid_baseline.yaml

## Evaluate
./scripts/eval_mid_sudachi.sh

