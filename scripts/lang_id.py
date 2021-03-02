#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Code adapted from https://medium.com/@c.chaitanya/language-identification-in-python-using-fasttext-60359dc30ed0
# Usage python3 scripts/lang_id.py -i data/reuters-ja-total.txt -n 500 -s 0.8

import fasttext
import optparse
import sys
import pathlib

optparser = optparse.OptionParser()
optparser.add_option("-i", "--input", dest="input", default="{pathlib.Path(__file__).parent.absolute()}/data/reuters-ja-total.txt", help="File containing sentences to get lang-id of (default=data/train/reuters-ja-total.txt)")
optparser.add_option("-n", "--num_sentences", dest="num_sents", default=sys.maxsize, type="int", help="Number of sentences, default=no limit)")
optparser.add_option("-s", "--conf_score", dest="score", default=0.9, type="float", help="Confidence score of prediction, default=0.9)")
optparser.add_option("-l", "--lang", dest="lang", default="label", type=str, help="Lang predicted, default to anything")
opts = optparser.parse_args()[0]

class LanguageIdentification:

    def __init__(self):
        pretrained_model = "/tmp/lid.176.bin"
        self.model = fasttext.load_model(pretrained_model)

    def predict_lang(self, file):
        predictions = {}
        for line in open(file).readlines()[:opts.num_sents]:
            predictions[line] = self.model.predict(line.strip())
        return predictions

if __name__ == '__main__':
    LANGUAGE = LanguageIdentification()
    predictions = LANGUAGE.predict_lang(opts.input)
    print("Print out sentences and the lang_id prediction for " + opts.lang + " if the confidence score of prediction is less than " + str(opts.score))
    for prediction_k, prediction_v in predictions.items():
        if prediction_v[1] < opts.score and opts.lang in prediction_v[0][0]:
            print(prediction_k, prediction_v)
