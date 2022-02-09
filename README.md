# Illinois Japanese ↔ English News Translation for WMT 2021

This repository contains the scripts to reproduce results described in paper [Illinois Japanese ↔ English News Translation for WMT 2021](https://aclanthology.org/2021.wmt-1.11/). If you use any of the results here, please cite

    @inproceedings{le-etal-2021-illinois,
        title = "{I}llinois {J}apanese $\leftrightarrow$ {E}nglish {N}ews {T}ranslation for {WMT} 2021",
        author = "Le, Giang  and
            Mori, Shinka  and
            Schwartz, Lane",
        booktitle = "Proceedings of the Sixth Conference on Machine Translation",
        month = nov,
        year = "2021",
        address = "Online",
        publisher = "Association for Computational Linguistics",
        url = "https://aclanthology.org/2021.wmt-1.11",
        pages = "144--153",
        abstract = "This system paper describes an end-to-end NMT pipeline for the Japanese $\leftrightarrow$ English news translation task as submitted to WMT 2021, where we explore the efficacy of techniques such as tokenizing with language-independent and language-dependent tokenizers, normalizing by orthographic conversion, creating a politeness-and-formality-aware model by implementing a tagger, back-translation, model ensembling, and n-best reranking. We use parallel corpora provided by WMT 2021 organizers for training, and development and test data from WMT 2020 for evaluation of different experiment models. The preprocessed corpora are trained with a Transformer neural network model. We found that combining various techniques described herein, such as language-independent BPE tokenization, incorporating politeness and formality tags, model ensembling, n-best reranking, and back-translation produced the best translation models relative to other experiment systems.",
    }

First, make sure that you are in wmt2021/ directory. After that, follow the steps below to reproduce the results of our experiments.

## Retrieve data from WMT 2021
Please note that it would take approximately 7 to 8 hours to retrieve all datasets for the Japanese-English language pair from WMT 2021.

    ./scripts/get_all_wmt2021.sh

If you would like to retrieve individual datasets, do the following. Substitute the name of the corpus you are interested in with *paracrawl*

    ./scripts/get_data.sh -c ted
