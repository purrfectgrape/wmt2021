#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import fasttext

class LanguageIdentification:

    def __init__(self):
        pretrained_model = "/tmp/lid.176.bin"
        self.model = fasttext.load_model(pretrained_model)

    def predict_lang(self, text):
        predictions = self.model.predict(text)
        return predictions

if __name__ == '__main__':
    LANGUAGE = LanguageIdentification()
    lang = LANGUAGE.predict_lang("Hej")
    print(lang)


