# Documentation for final submission's models

## Execute scripts from wmt2021/ directory
cd //nas/models/experiment/ja-en/wmt2021

## Get all data from WMT 2021 (Would take about 7 or 8 hours)
./scripts/get_all_wmt2021.sh <br>
(To get individual corpora: run ./scripts/get_data.sh -c ted for example)

## Extract sentences from each corpus

### Download ted talks processing tools
gdown --id 1-wmonUKD3WBy8va8_88O9UcSSw2Wy4zj
unzip tools_2012.zip -d libraries/ted_tools
rm tools_2012.zip

### Training data
python3 scripts/extract_wikimatrix.py --threshold=1.0 --src-lang=en --trg-lang=ja --tsv=data/wmt2021/wikimatrix/WikiMatrix.v1.en-ja.langid.tsv --bitext=data/train/raw/wikimatrix<br> 
python3 scripts/extract_paracrawl.py --txt data/wmt2021/paracrawl/en-ja/en-ja.bicleaner05.txt --bitext data/train/raw/paracrawl --threshold=0.730<br>
python3 scripts/extract_ted.py --jaen=data/wmt2021/ted/2017-01-trnted/texts/ja/en/ja-en.tgz --enja=data/wmt2021/ted/2017-01-trnted/texts/en/ja/en-ja.tgz --out_dir=data/train/raw<br>
python3 scripts/extract_kftt.py --in_dir=data/wmt2021/kftt/kftt-data-1.0/data --out_dir=data/train/raw (this is for orig data. for tok type, specify --type=tok)<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/subtitles/raw/raw --bitext=data/train/raw/subtitles<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/news-commentary/news-commentary-v16.en-ja.tsv --bitext=data/train/raw/news-commentary<br>
python3 scripts/extract_titles_newscom.py --txt=data/wmt2021/wikititles/wikititles-v3.ja-en.tsv --bitext=data/train/raw/wikititles<br>
### Dev data
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --tgt --type=dev<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --src  --type=dev<br>
### Test data
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --tgt --type=test<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --src --type=test<br>

## Sanity check
./scripts/get_corpus_stats.sh -c train/raw

## Concatenate raw corpora for train
./scripts/concatenate_bitext.sh -c train/raw
You should see this:
Concatenate all bitext corpora...
Total sents count for bitext data in Japanese: 13957762 ./scripts/../data/train/raw/wmt2021-bitext.ja
Total sents count for bitext data in English: 13957762 ./scripts/../data/train/raw/wmt2021-bitext.en

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

## Filter by lang-id
python3 scripts/lang_id.py --conf_score=0.88
