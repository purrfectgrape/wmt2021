# Documentation for final submission's models

## Execute scripts from wmt2021/ directory
cd //nas/models/experiment/ja-en/wmt2021

## Get all data from WMT 2021 (Would take about 7 or 8 hours)
./scripts/get_all_wmt2021.sh <br>
(To get individual corpora: run ./scripts/get_data.sh -c ted for example)

## Extract sentences from each corpus

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
#### ja>en direction
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --tgt --type=dev<br>
<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=jaen --out_dir=data/dev/raw --src  --type=dev<br>
<br>
#### en>ja direction
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --src --type=dev<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/dev/dev --direction=enja --out_dir=data/dev/raw --tgt --type=dev<br>

### Test data
#### ja>en direction
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --tgt --type=test<br>
<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=jaen --out_dir=data/test/raw --src --type=test<br>
<br>
#### en>ja direction
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=enja --out_dir=data/test/raw --src --type=test<br>
python3 scripts/extract_dev_test.py --input_dir=data/wmt2021/test/sgm --direction=enja --out_dir=data/test/raw --tgt --type=test <br>

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
awk '{$1=$1;print}' data/train/raw/wmt2021-bitext-langid-filtered.ja > data/train/raw/wmt2021-bitext-langid-filtered-1.ja <br>
cat data/train/raw/wmt2021-bitext-langid-filtered-1.ja | libraries/moses/scripts/tokenizer/remove-non-printing-char.perl -l ja > data/train/raw/wmt2021-bitext-langid-filtered-cln.ja <br>
rm data/train/raw/wmt2021-bitext-langid-filtered-1.ja

## Preprocess English (punc and non-printing char norm)
scripts/preprocess_en.sh -c wmt2021-bitext

## Preprocess Japanese
Also: steps to test this script:
cat data/train/raw/wmt2021-bitext-langid-filtered.ja | grep "(.\*)" | head -n 1000 > testfile.ja <br>
python3 scripts/preprocess_ja.py --input=testfile.ja --output=out.ja <br>
diff -y --color testfile.ja out.ja --suppress-common-lines -W 150 --color=auto | grep "(.\*)" <br>

Note that for JA>EN, we only remove the English in parentheses. We don't normalize katakana. <br>
python3 scripts/preprocess_ja.py --input=/nas/models/experiment/ja-en/wmt2021/data/train/raw/wmt2021-bitext-langid-filtered-cln.ja --output=/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja

## Shuffle the training corpus
paste -d '\t' /nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja /nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.en | shuf | awk -v FS='\t' '{ print $1 > "/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext-shuffled.ja" ; print $2 > "/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext-shuffled.en" }'

## Train sentencepiece
spm_train --input=data/train/preprocessed/wmt2021-bitext.en --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=1 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.en <br>
<br>
spm_train --input=data/train/preprocessed/wmt2021-bitext.ja --train_extremely_large_corpus=true --vocab_size=32000 --character_coverage=0.9995 --input_sentence_size=7000000 --shuffle_input_sentence=true --model_prefix=sentencepiece/transformer_big.ja <br>
<br>

## Apply politeness and formality tags
python scripts/pofo_tagger_simple.py --corpus=data/train/preprocessed/wmt2021-bitext

## Preprocess development data
scripts/preprocess_dev.sh jaen 
scripts/preprocess_dev.sh enja

## Preprocess test data
scripts/preprocess_test.sh jaen
scripts/preprocess_test.sh enja

## Train ja->en BIG model on 4 GPUs.
scripts/train.sh configs/transformer_big_ja_en.yaml 0,1,2,3

## Visualize the learning curve
Add these lines to the yaml
tensorboard: true <br>
tensorboard_log_dir: /nas/models/experiment/ja-en/wmt2021/logs <br>
Also log into the server like this
ssh -L 16006:127.0.0.1:6006 gianghl2@qivalluk.linguistics.illinois.edu <br>
tensorboard --logdir=logs/ <br>
http://127.0.0.1:16006/ <br>

## Annotate named entities in English and Japanese 12.7M
python3 scripts/ner_annotator.py --lang=en --input=data/train/preprocessed/wmt2021-bitext-shuffled.en --output=data/train/preprocessed/wmt2021-bitext-shuffled-annotated.en --nb-sents=12718322 <br>
python3 scripts/ner_annotator.py --lang=ja --input=data/train/preprocessed/wmt2021-bitext-shuffled.ja --output=data/train/preprocessed/wmt2021-bitext-shuffled-annotated.ja --nb-sents=12718322 <br>
python3 scripts/ner_annotator_norm.py --lang=en --input=data/train/preprocessed/wmt2021-bitext-shuffled.en --output=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-norm.en --nb-sents=12718322 <br>
python3 scripts/ner_annotator_norm.py --lang=ja --input=data/train/preprocessed/wmt2021-bitext-shuffled.ja --output=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-norm.ja --nb-sents=12718322 <br>

Fix issues with the annotator (remember to do the same for ja)
cat data/train/preprocessed/wmt2021-bitext-shuffled-annotated.en | sed 's/^｠//g' | sed 's/\(^.*｟[^｠]*\)$/\1｠/g' > data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en
diff -y data/train/preprocessed/wmt2021-bitext-shuffled-annotated.en data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en --suppress-common-lines | wc -l (should return the same number of lines as in data/train/preprocessed/wmt2021-bitext-shuffled.en.errors)
python3 scripts/normalize_ner.py --input=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en --output=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-norm.en --nb_sents=12718322

## Create file for fast_align from sentencepiece models
spm_encode --model=sentencepiece/transformer_big.en.model --output_format=piece < data/train/preprocessed/wmt2021-bitext-shuffled.en > data/alignment/fast_align.en.sp
spm_encode --model=sentencepiece/transformer_big.ja.model --output_format=piece < data/train/preprocessed/wmt2021-bitext-shuffled.ja > data/alignment/fast_align.ja.sp
spm_encode --model=sentencepiece/transformer_big.ja.model  --output_format=piece < data/dev/preprocessed/newsdev2020-jaen.ja > data/alignment/dev.ja.sp
spm_encode --model=sentencepiece/transformer_big.en.model  --output_format=piece < data/dev/preprocessed/newsdev2020-jaen.en > data/alignment/dev.en.sp 
python3 scripts/prepare_align_bitext.py --input_en=data/alignment/fast_align.en.sp --input_ja=data/alignment/fast_align.ja.sp --output=data/alignment/fast_align.bitext.sp 

## Learn alignments with fastalign
cd libraries/fast_align/build && cmake .. && make
./fast_align -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align.bitext.sp -d -o -v > //nas/models/experiment/ja-en/wmt2021/data/alignment/enja.align 
./fast_align -i //nas/models/experiment/ja-en/wmt2021/data/alignment/fast_align.bitext.sp -d -o -v -r > //nas/models/experiment/ja-en/wmt2021/data/alignment/jaen.align

## Train model with alignment
scripts/train.sh configs/transformer_big_align_ja_en.yaml 4

## Train model for en>ja without politeness info
scripts/train.sh configs/transformer_big_en_ja.yaml 7

## (Experiment) Train a small model (4m) with annotated NE in English to translate en->ja and translate
scripts/train.sh configs/alignment_4m_en_ja_ner.yaml 7
scripts/eval_alignment_4m_en_ja_ner.sh (remember to include --report_align in calling translate.py)
Check cat translate/alignment_4m_en_ja_ner/test.ja.hyp_alignment_4m_en_ja_ner_step_6000.sp for the alignment

## Preprocess test files
spm_encode --model=sentencepiece/transformer_big.ja.model  --output_format=piece < data/test/preprocessed/newstest2020-jaen.ja > data/test/preprocessed/newstest2020-jaen.ja.sp
spm_encode --model=sentencepiece/transformer_big.en.model  --output_format=piece < data/test/preprocessed/newstest2020-jaen.en > data/test/preprocessed/newstest2020-jaen.en.sp
spm_encode --model=sentencepiece/transformer_big.ja.model  --output_format=piece < data/test/preprocessed/newstest2020-enja.ja > data/test/preprocessed/newstest2020-enja.ja.sp
spm_encode --model=sentencepiece/transformer_big.en.model  --output_format=piece < data/test/preprocessed/newstest2020-enja.en > data/test/preprocessed/newstest2020-enja.en.sp


## Preprocess dev files for eval
spm_encode --model=sentencepiece/transformer_big.ja.model  --output_format=piece < data/dev/preprocessed/newsdev2020-jaen.ja > data/dev/preprocessed/newsdev2020-jaen.ja.sp
spm_encode --model=sentencepiece/transformer_big.en.model  --output_format=piece < data/dev/preprocessed/newsdev2020-jaen.en > data/dev/preprocessed/newsdev2020-jaen.en.sp
spm_encode --model=sentencepiece/transformer_big.ja.model  --output_format=piece < data/dev/preprocessed/newsdev2020-enja.ja > data/dev/preprocessed/newsdev2020-enja.ja.sp
spm_encode --model=sentencepiece/transformer_big.en.model  --output_format=piece < data/dev/preprocessed/newsdev2020-enja.en > data/dev/preprocessed/newsdev2020-enja.en.sp
## Translate and evaluation
scripts/eval.sh dev transformer_big 7
scripts/eval.sh test transformer_big 7
scripts/eval.sh dev transformer_big_align 7
scripts/eval.sh test transformer_big_align 7

## Preparing Japanese data for NE annotation
scripts/tokenize_japanese.py --input=data/train/preprocessed/wmt2021-bitext-shuffled.ja --output=data/train/preprocessed/wmt2021-bitext-shuffled-tok.ja

## Learn alignments
python3 scripts/prepare_align_bitext.py --input_en=data/train/preprocessed/wmt2021-bitext-shuffled-annotated.en --input_ja=data/train/preprocessed/wmt2021-bitext-shuffled-tok.ja --output=data/train/preprocessed/wmt2021-bitext-shuffled-tok.bitext
cd libraries/fast_align/build && cmake .. && make
./fast_align -i data/train/preprocessed/wmt2021-bitext-shuffled-tok.bitext -d -o -v > //nas/models/experiment/ja-en/wmt2021/data/alignment/wmt2021-bitext-shuffled-tok-enja.align

## Create a dictionary for possible NE mappings
python3 scripts/ner_dict.py --input_ja=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.ja --input_en=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en --output=data/ner_dict/ner_dict.pickle --nb_sents=12718322 --direction=en-ja

python3 scripts/ner_dict.py --input_ja=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.ja --input_en=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en --output=data/ner_dict/ner_dict.pickle --nb_sents=12718322 --direction=ja-en

# create a dictionary map for PERSON only
 python3 scripts/ner_dict_per.py --input_ja=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.ja --input_en=data/train/preprocessed/wmt2021-bitext-shuffled-annotated-fixed.en --output=data/ner_dict/ner_dict.pickle.per --nb_sents=12718322 --direction=en-ja 


## (Deprecated) Find the most probable translation for a given NE
python3 scripts/find_ne_translation.py --input=data/ner_dict/ner_dict.pickle.en-ja --word='Japan'
python3 scripts/find_ne_translation.py --input=data/ner_dict/ner_dict.pickle.ja-en --word='日本'

## Create phrase tables for both directions
python3 scripts/find_ne_translation.py --input=data/ner_dict/ner_dict.pickle.en-ja --output=data/ner_dict/phrase_table_en_ja.txt
python3 scripts/find_ne_translation.py --input=data/ner_dict/ner_dict.pickle.ja-en --output=data/ner_dict/phrase_table_ja_en.txt
## Create a phrase table for PERSON en->ja direction about 500k entities.

## Get test data sources
wget http://data.statmt.org/wmt21/translation-task/test-src.tgz
tar -xf test-src.tgz
mv test-src data/wmt2021/test/

## NER correction in test data.
python3 scripts/ner_annotator.py --lang=en --input=data/wmt2021/test/test-src/newstest2021.en-ja.en --output=data/wmt2021/test/test-src/newstest2021-norm.en-ja.en --nb_sents=1000
spm_encode --model=sentencepiece/transformer_big.en.model --output_format=piece < data/wmt2021/test/test-src/newstest2021-annotated.en-ja.en > data/wmt2021/test/test-src/newstest2021-annotated.en-ja.en.sp


## Get Stanford parser for dependencies
pip3 install jpype1
cd libraries && wget https://projects.csail.mit.edu/spatial/images/f/f8/Stanford-parser-python-r22186.tar.gz

## Translating for final submission.
scripts/generate_translations.sh

## Tokenize Japanese with fugashi for bert scoring (example)
scripts/tokenize_japanese.py --input submissions/text/en-ja-bt-pofo-02_step_210000.pt.en-ja-bt-pofo-02_step_240000.pt.en-ja-bt-pofo-02_step_250000.pt.10hyp.ja  --output submissions/fugashi/en-ja-bt-pofo-02_step_210000.pt.en-ja-bt-pofo-02_step_240000.pt.en-ja-bt-pofo-02_step_250000.pt.10hyp.ja

# Run bert scoring
sh script_japanese.sh ../submissions/fugashi/en-ja_step_300000.pt.en-ja_step_290000.pt.en-ja_step_260000.pt.10hyp.ja ../submissions/nbest/en-ja_step_300000.pt.en-ja_step_290000.pt.en-ja_step_260000.pt.10hyp.ja ../bert_japanese
## Wrapping files in xml
wmt-wrap -s data/wmt2021/test/test-src/newstest2021.src.ja-en.xml -t submissions/nbest/ja-en_step_300000.pt.10hyp_nest.en -n Illini -l en > submissions/final_xml/newsdev2021.ja-en_step_300000.pt.10hyp_best.en.xml

