#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Code adapted from https://medium.com/@c.chaitanya/language-identification-in-python-using-fasttext-60359dc30ed0
# Usage python3 scripts/lang_id.py -a data/raw/reuters.ja -b data/raw/reuters.en

import fasttext
import optparse
import sys

optparser = optparse.OptionParser()
optparser.add_option("-a", "--input_one", dest="input_one", default="data/raw/paracrawl.en", help="File containing sentences to get lang-id of (default=data/raw/paracrawl.en)")
optparser.add_option("-b", "--input_two", dest="input_two", default="data/raw/paracrawl.ja", help="File containing sentences to get lang-id of (default=data/raw/paracrawl.ja)")
optparser.add_option("-n", "--num_sentences", dest="num_sents", default=sys.maxsize, type="int", help="Number of sentences, default=no limit)")
optparser.add_option("-s", "--conf_score", dest="score", default=0.9, type="float", help="Confidence score of prediction, default=0.9)")
opts = optparser.parse_args()[0]

class LanguageIdentification:

    def __init__(self):
        pretrained_model = "/tmp/lid.176.bin"
        self.model = fasttext.load_model(pretrained_model)

    def predict_lang(self, file_one, file_two):
        parallel_predictions = {}
        with open(file_one) as f1, open(file_two) as f2:
            for x, y in zip(f1, f2):
                parallel_predictions[(x,y)] = (self.model.predict(x.decode('utf-8').strip()), self.model.predict(y.decode('utf-8').strip()))
        return parallel_predictions
        
    def filter(self, predictions, file_one, file_two, score):
        with open(file_one.split(".")[0] + "-filtered." + file_one.split(".")[1], "w") as out1, open(file_two.split(".")[0] + "-filtered." + file_two.split(".")[1], "w") as out2:
            for prediction_k, prediction_v in predictions.items():
                if (prediction_v[0][1][0] > score and prediction_v[1][1][0] > score and file_one.split(".")[1] in prediction_v[0][0][0] and file_two.split(".")[1] in prediction_v[1][0][0]):
                    out1.write(prediction_k[0])
                    out2.write(prediction_k[1])

if __name__ == '__main__':
    LANGUAGE = LanguageIdentification()
    predictions = LANGUAGE.predict_lang(opts.input_one, opts.input_two)
    LANGUAGE.filter(predictions, opts.input_one, opts.input_two, opts.score)

