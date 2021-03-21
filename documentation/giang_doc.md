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
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --tgt --type=dev
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --src  --type=dev
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --tgt --type=test
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --src --type=test

## Sanity check
./scripts/get_corpus_stats.sh -c train/raw

## Concatenate raw corpora for train
./scripts/concatenate_bitext.sh -c train/raw

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

## Filter by lang-id
python3 scripts/lang_id.py --conf_score=0.85

## Preprocess EN data with Moses
`For training data`
./scripts/moses_en.sh -c wmt2021-bitext
`For development data`
./scripts/moses_dev_en.sh -c newsdev2020-enja-src
./scripts/moses_dev_en.sh -c newsdev2020-jaen-ref
`For test data`
./scripts/moses_test_en.sh -c newstest2020-enja-src
./scripts/moses_test_en.sh -c newstest2020-jaen-ref

## Preprocess JA data with fugashi
`For training data`
python3 scripts/tokenize_japanese.py --input=data/train/raw/wmt2021-bitext-langid-filtered.ja --output=data/train/preprocessed/wmt2021-bitext-tok.ja
`For development data`
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-enja-ref.ja.sgm --output=data/dev/preprocessed/newsdev2020-enja-ref-tok.ja
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-jaen-src.ja.sgm --output=data/dev/preprocessed/newsdev2020-jaen-src-tok.ja
`For test data`
python3 scripts/tokenize_japanese.py --input=data/test/raw/newstest2020-enja-ref.ja.sgm --output=data/test/preprocessed/newstest2020-enja-ref-tok.ja
python3 scripts/tokenize_japanese.py --input=data/test/raw/newstest2020-jaen-src.ja.sgm --output=data/test/preprocessed/newstest2020-jaen-src-tok.ja

## Learn bpe for both
./scripts/learn_bpe.sh -l ja
./scripts/learn_bpe.sh -l en
`For development data. Normal to have 4 warnings.`
./scripts/learn_bpe_dev.sh -l ja
./scripts/learn_bpe_dev.sh -l en
`Currently there's an error in learning bpe for data/test/preprocessed/newstest2020-enja-src-tok-bpe.en`
./scripts/learn_bpe_test.sh -l ja
./scripts/learn_bpe_test.sh -l en

## Build vocab
onmt_preprocess -train_src data/train/preprocessed/wmt2021-bitext-tok-bpe.ja -train_tgt data/train/preprocessed/wmt2021-bitext-tok-bpe.en -valid_src data/dev/preprocessed/newsdev2020-jaen-src-tok-bpe.ja -valid_tgt data/dev/preprocessed/newsdev2020-jaen-ref-tok-bpe.en  -save_data //nas/models/experiment/ja-en/wmt2021/data/opennmt-vocab/wmt2021-bitext  -overwrite

## Train
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config=configs/wmt2021-bitext.yaml

## Evaluate
./scripts/eval_wmt2021-bitext.sh

# Steps to train a mid-sized model (as of Mar 21, 2021) to translate EN->JA

cd //nas/models/experiment/ja-en/wmt2021

## Download the parallel data
sh scripts/get_mid_corpus.sh -c reuters
sh scripts/get_mid_corpus.sh -c wikimatrix
sh scripts/get_mid_corpus.sh -c paracrawl
sh scripts/get_mid_corpus.sh -c newscommentary
./scripts/get_data.sh -c dev

## Write the lines to English and Japanese files
sh scripts/preprocess_mid_corpus.sh

## Extract dev lines
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --tgt --type=dev
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --src  --type=dev

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
sh scripts/moses_en_mid.sh -c reuters
sh scripts/moses_en_mid.sh -c newscommentary
sh scripts/moses_en_mid.sh -c wikimatrix
sh scripts/moses_en_mid.sh -c paracrawl
`for development data`
./scripts/moses_dev_en.sh -c newsdev2020-enja-src

## Preprocessing the Japanese data with fugashi
python3 scripts/tokenize_japanese.py --input=data/raw/reuters-langid-filtered.ja --output=data/preprocessed/reuters-tok.ja
python3 scripts/tokenize_japanese.py --input=data/raw/newscommentary-langid-filtered.ja --output=data/preprocessed/newscommentary-tok.ja
python3 scripts/tokenize_japanese.py --input=data/raw/wikimatrix-langid-filtered.ja --output=data/preprocessed/wikimatrix-tok.ja
python3 scripts/tokenize_japanese.py --input=data/raw/paracrawl-langid-filtered.ja --output=data/preprocessed/paracrawl-tok.ja
`for development data`
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-enja-ref.ja.sgm --output=data/dev/preprocessed/newsdev2020-enja-ref-tok.ja

## Learn bpe
./scripts/learn_bpe_mid.sh -l ja
./scripts/learn_bpe_mid.sh -l en
`for development data. It's normal to have 4 warnings` 
./scripts/learn_bpe_dev.sh -l ja
./scripts/learn_bpe_dev.sh -l en

## The training data can be found in data/train/preprocessed/corpus-mid-tok-bpe.{en|ja} and the dev data can be found in data/dev/preprocessed

source /opt/python/3.7/venv/pytorch1.3_cuda10.0/bin/activate

## Build vocab
onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/corpus-mid-tok-bpe.en -train_tgt //nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/corpus-mid-tok-bpe.ja -valid_src //nas/models/experiment/ja-en/wmt2021/data/dev/preprocessed/newsdev2020-enja-src-tok-bpe.en -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/dev/preprocessed/newsdev2020-enja-ref-tok-bpe.ja -save_data //nas/models/experiment/ja-en/wmt2021/data/opennmt-vocab/corpus-mid-0321 -overwrite

## Train the model
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config=configs/corpus_mid_baseline.yaml

## Evaluate
./scripts/eval_mid_sudachi.sh

