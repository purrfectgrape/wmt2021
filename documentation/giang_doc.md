# Steps for tagging experiments
## Polite tag only
gianghl2@qivalluk://nas/models/experiment/ja-en/wmt2021$ cp /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-enja-ref.ja.sgm  /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-enja.ja
gianghl2@qivalluk://nas/models/experiment/ja-en/wmt2021$ cp /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-enja-src.en.sgm /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-enja.en
gianghl2@qivalluk://nas/models/experiment/ja-en/wmt2021$  cp /nas/models/experiment/ja-en/wmt2021/data/test/raw/newstest2020-enja-ref.ja.sgm /nas/models/experiment/ja-en/wmt2021/data/test/raw/newstest2020-enja.ja
gianghl2@qivalluk://nas/models/experiment/ja-en/wmt2021$ cp /nas/models/experiment/ja-en/wmt2021/data/test/raw/newstest2020-enja-src.en.sgm /nas/models/experiment/ja-en/wmt2021/data/test/raw/newstest2020-enja.en
python scripts/pofo_tagger_simple.py --corpus=/nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-enja --nb_sents=1998
python scripts/pofo_tagger_simple.py --corpus=/nas/models/experiment/ja-en/wmt2021/data/sentence_filtered/mid_corpus
python scripts/pofo_tagger_simple.py --corpus=/nas/models/experiment/ja-en/wmt2021/data/test/raw/newstest2020-enja

scripts/train.sh configs/config_mid_en_ja_polite.yaml 0

# Steps for transformer big setting on 4m ja>en data. Set the GPU number by adding a number at the end of the command.
scripts/train.sh configs/big_4m_ja_en.yaml 0

# Steps for base experiment (biggest data possible)
## Extracting train files
Similar to before, but do not specify threshold for paracrawl and wikimatrix. paracrawl is saved in paracrawl-all

## Concatenate
./scripts/concatenate_bitext_transformer_base.sh -c train/raw

## Build vocab
spm_train --input=data/train/raw/transformer-base.en --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=1 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_base.en
spm_train --input=data/train/raw/transformer-base.ja --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=0.9995 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_base.ja

## Train
scripts/train.sh configs/transformer_base_ja_en.yaml 0

## Encode test set
spm_encode --model=sentencepiece/transformer_base.ja.model < data/test/raw/newstest2020-jaen-src.ja.sgm > data/test/preprocessed/newstest2020-jaen-transformer-base.sp.ja
spm_encode --model=sentencepiece/transformer_base.en.model < data/test/raw/newstest2020-jaen-src.en.sgm > data/test/preprocessed/newstest2020-jaen-transformer-base.sp.en

## Translate and Eval
./scripts/eval_transformer_base.sh

# Steps for fast_align experiment
## Create file for fast_align

spm_encode --model=sentencepiece/baseline_sample_4m.en.model --output_format=piece < data/train/raw/sample-4m.en | sed 's/▁//g' > data/alignment/fast_align_sample.en
spm_encode --model=sentencepiece/baseline_sample_4m.ja.model --output_format=piece < data/train/raw/sample-4m.ja | sed 's/▁//g' > data/alignment/fast_align_sample.ja
python3 scripts/prepare_bitext.py
## Run fast_align
cd libraries/fast_align/build
cmake ..
make

./fast_align  -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align_sample.bitext -d -o -v > //nas/models/experiment/ja-en/wmt2021/data/alignment/forward.enja.align
./fast_align  -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align_sample.bitext -d -o -v -r > //nas/models/experiment/ja-en/wmt2021/data/alignment/reverse.jaen.align

## Tokenize using sentencepiece
spm_encode --model=sentencepiece/baseline_sample_4m.en.model --output_format=piece < data/train/raw/sample-4m.en > //nas/models/experiment/ja-en/wmt2021/data/alignment/sample-4m.en.sp
spm_encode --model=sentencepiece/baseline_sample_4m.ja.model --output_format=piece < data/train/raw/sample-4m.ja > //nas/models/experiment/ja-en/wmt2021/data/alignment/sample-4m.ja.sp

spm_encode --model=sentencepiece/baseline_sample_4m.en.model --output_format=piece < /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-jaen-ref.en.sgm > data/alignment/dev.en.sp

spm_encode --model=sentencepiece/baseline_sample_4m.ja.model --output_format=piece < /nas/models/experiment/ja-en/wmt2021/data/dev/raw/newsdev2020-jaen-src.ja.sgm > data/alignment/dev.ja.sp

## Train
scripts/train.sh configs/alignment_4m_ja_en.yaml 0

## Translate and eval
./scripts/eval_alignment_4m.sh

# Politeness tagger
python scripts/pofo_tagger.py --corpus=data/train/raw/paracrawl --nb_sents=10000

# Steps to prepare a full-sized model

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
python3 scripts/lang_id.py --conf_score=0.85

## Sample 4M sentence pairs for training
python3 scripts/sample_train_corpus.py --txt=data/train/raw/wmt2021-bitext-langid-filtered --nb-sents=8000000 --bitext=data/train/raw/sample-4m

## Convert mixed orthography to Hiragana and Romaji
### Training data
python3 scripts/orthography_converter.py --infile=data/train/raw/sample-4m --outfile=data/train/preprocessed/sample-4m-hiragana --to_type=hira --nb_sents=4000000
python3 scripts/orthography_converter.py --infile=data/train/raw/sample-4m --outfile=data/train/preprocessed/sample-4m-romaji --to_type=hepburn --nb_sents=4000000
### Dev data
python3 scripts/orthography_converter_dev_test.py --infile=data/dev/raw/newsdev2020-jaen --outfile=data/dev/preprocessed/newsdev2020-jaen-hiragana --to_type=hira
python3 scripts/orthography_converter_dev_test.py --infile=data/dev/raw/newsdev2020-jaen --outfile=data/dev/preprocessed/newsdev2020-jaen-romaji --to_type=hepburn
### Test data
python3 scripts/orthography_converter_dev_test.py --infile=data/test/raw/newstest2020-jaen --outfile=data/test/preprocessed/newstest2020-jaen-hiragana --to_type=hira
python3 scripts/orthography_converter_dev_test.py --infile=data/test/raw/newstest2020-jaen --outfile=data/test/preprocessed/newstest2020-jaen-romaji --to_type=hepburn
## Use sentencepiece to build vocab for 3 experiments(in that case no need to preprocess with moses, fugashi, etc.)
python3 scripts/sentencepiece_orth_experiments.py

## Train model
To start training,  onmt needs to version 2.0. Update by running pip3 install --upgrade OpenNMT-py==2.0.0rc1 --prefix=$HOME/.local
. This will be installed to /home/gianghl2/.local
The command below will also install pytorch with 10.1 cuda driver.
pip3 install --prefix=$HOME/.local torch==1.7.1+cu101 torchvision==0.8.2+cu101 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html
vim ~/.bashrc to export PYTHONPATH with the above dir, then source

scripts/train.sh configs/hiragana_4m_ja_en.yaml
scripts/train.sh configs/baseline_4m.sh
scripts/train.sh configs/romaji_4m_ja_en.yaml
scripts/train.sh configs/baseline_4m_big.sh # Use Transformer big setting
## Translate and Eval
./scripts/preprocess_test_4m.sh
./scripts/eval_hiragana_4m.sh
./scripts/eval_romaji_4m.sh
./scripts/eval_baseline_4m.sh

## Preprocess EN data with Moses
### Training data
./scripts/moses_en.sh -c wmt2021-bitext<br>
### Dev data
./scripts/moses_dev_en.sh -c newsdev2020-enja-src<br>
./scripts/moses_dev_en.sh -c newsdev2020-jaen-ref<br>
### Test data
./scripts/moses_test_en.sh -c newstest2020-enja-src<br>
./scripts/moses_test_en.sh -c newstest2020-jaen-ref<br>

## Preprocess JA data with fugashi
### Training data
python3 scripts/tokenize_japanese.py --input=data/train/raw/wmt2021-bitext-langid-filtered.ja --output=data/train/preprocessed/wmt2021-bitext-tok.ja<br>
### Dev data
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-enja-ref.ja.sgm --output=data/dev/preprocessed/newsdev2020-enja-ref-tok.ja<br>
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-jaen-src.ja.sgm --output=data/dev/preprocessed/newsdev2020-jaen-src-tok.ja<br>
### Test data
python3 scripts/tokenize_japanese.py --input=data/test/raw/newstest2020-enja-ref.ja.sgm --output=data/test/preprocessed/newstest2020-enja-ref-tok.ja<br>
python3 scripts/tokenize_japanese.py --input=data/test/raw/newstest2020-jaen-src.ja.sgm --output=data/test/preprocessed/newstest2020-jaen-src-tok.ja<br>

## Learn bpe for both
### Training data
./scripts/learn_bpe.sh -l ja<br>
./scripts/learn_bpe.sh -l en<br>
### Dev data
 *Normal to have 4 warnings.*
./scripts/learn_bpe_dev.sh -l ja<br>
./scripts/learn_bpe_dev.sh -l en<br>
### Test data
*Currently there's an error in learning bpe for data/test/preprocessed/newstest2020-enja-src-tok-bpe.en*
./scripts/learn_bpe_test.sh -l ja<br>
./scripts/learn_bpe_test.sh -l en<br>

## Build vocab
onmt_preprocess -train_src data/train/preprocessed/wmt2021-bitext-tok-bpe.ja -train_tgt data/train/preprocessed/wmt2021-bitext-tok-bpe.en -valid_src data/dev/preprocessed/newsdev2020-jaen-src-tok-bpe.ja -valid_tgt data/dev/preprocessed/newsdev2020-jaen-ref-tok-bpe.en  -save_data //nas/models/experiment/ja-en/wmt2021/data/opennmt-vocab/wmt2021-bitext  -overwrite

## Train
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config=configs/wmt2021-bitext.yaml

## Evaluate
./scripts/eval_wmt2021-bitext.sh

# Steps to train a mid-sized model (as of Mar 21, 2021) to translate EN->JA

cd //nas/models/experiment/ja-en/wmt2021

## Download the parallel data
./scripts/get_mid_corpus.sh -c reuters<br>
./scripts/get_mid_corpus.sh -c wikimatrix<br>
./scripts/get_mid_corpus.sh -c paracrawl<br>
./scripts/get_mid_corpus.sh -c newscommentary<br>
./scripts/get_data.sh -c dev<br>
./scripts/get_data.sh -c test<br>

## Write the lines to English and Japanese files
sh scripts/preprocess_mid_corpus.sh

## Extract dev lines
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --tgt --type=dev<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --src  --type=dev<br>

## Extract test lines
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=enja --out_dir=data/test/raw --tgt --type=test<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=enja --out_dir=data/test/raw --src --type=test<br>

## Get fast-text pre-trained model
wget -O /tmp/lid.176.bin https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin

## Filtering based on lang identification (0.9 for all four corpora)
scripts/lang_id.py -a data/raw/newscommentary.ja -b data/raw/newscommentary.en<br>
scripts/lang_id.py -a data/raw/reuters.ja -b data/raw/reuters.en<br>
scripts/lang_id.py -a data/raw/paracrawl.ja -b data/raw/paracrawl.en<br>
scripts/lang_id.py -a data/raw/wikimatrix.ja -b data/raw/wikimatrix.en<br>

## Copy moses scripts to libraries
git clone https://github.com/bricksdont/moses-scripts libraries/moses

## Preprocessing the English data with Moses
sh scripts/moses_en_mid.sh -c reuters<br>
sh scripts/moses_en_mid.sh -c newscommentary<br>
sh scripts/moses_en_mid.sh -c wikimatrix<br>
sh scripts/moses_en_mid.sh -c paracrawl<br>
### Dev data
./scripts/moses_dev_en.sh -c newsdev2020-enja-src
### Test data
./scripts/moses_test_en.sh -c newstest2020-enja-src

## Preprocessing the Japanese data with fugashi
python3 scripts/tokenize_japanese.py --input=data/raw/reuters-langid-filtered.ja --output=data/preprocessed/reuters-tok.ja<br>
python3 scripts/tokenize_japanese.py --input=data/raw/newscommentary-langid-filtered.ja --output=data/preprocessed/newscommentary-tok.ja<br>
python3 scripts/tokenize_japanese.py --input=data/raw/wikimatrix-langid-filtered.ja --output=data/preprocessed/wikimatrix-tok.ja<br>
python3 scripts/tokenize_japanese.py --input=data/raw/paracrawl-langid-filtered.ja --output=data/preprocessed/paracrawl-tok.ja<br>
### Dev data
python3 scripts/tokenize_japanese.py --input=data/dev/raw/newsdev2020-enja-ref.ja.sgm --output=data/dev/preprocessed/newsdev2020-enja-ref-tok.ja
### Test data
python3 scripts/tokenize_japanese.py --input=data/test/raw/newstest2020-enja-ref.ja.sgm --output=data/test/preprocessed/newstest2020-enja-ref-tok.ja

## Learn bpe
./scripts/learn_bpe_mid.sh -l ja<br>
./scripts/learn_bpe_mid.sh -l en<br>
### Dev data
*It's normal to have 4 warnings* 
./scripts/learn_bpe_dev.sh -l ja
./scripts/learn_bpe_dev.sh -l en
### Test data
*It's normal to have 4 warnings*
./scripts/learn_bpe_test.sh -l ja
./scripts/learn_bpe_test.sh -l en

**The training data can be found in data/train/preprocessed/corpus-mid-tok-bpe.{en|ja} and the dev data can be found in data/dev/preprocessed after these steps**

## Activate venv
source /opt/python/3.7/venv/pytorch1.3_cuda10.0/bin/activate

## Build vocab
onmt_preprocess -train_src //nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/corpus-mid-tok-bpe.en -train_tgt //nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/corpus-mid-tok-bpe.ja -valid_src //nas/models/experiment/ja-en/wmt2021/data/dev/preprocessed/newsdev2020-enja-src-tok-bpe.en -valid_tgt //nas/models/experiment/ja-en/wmt2021/data/dev/preprocessed/newsdev2020-enja-ref-tok-bpe.ja -save_data //nas/models/experiment/ja-en/wmt2021/data/opennmt-vocab/corpus-mid-0321 -overwrite

## Train the model
CUDA_VISIBLE_DEVICES=0 OMP_NUM_THREADS=5 onmt_train -config=configs/corpus_mid_baseline.yaml

## Translate
./scripts/eval_mid_sudachi.sh

## Postprocessing and evaluation
