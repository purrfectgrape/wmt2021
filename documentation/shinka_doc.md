- train_mid_models.sh
    - build ocab, train model
- /nas/models/experiment/ja-en/data/preprocess_dev.ipynb
    - preprocess dev set by stripping html tag
- /nas/models/experiment/ja-en/data/preprocess_sudachi.ipynb
    - tokenize mid_corpus using sudachi tokenizer A
- /nas/models/experiment/ja-en/data/remove_english_name.ipynb
    - strips English translation of names following Japanese names
    - パブロ・ピカソ(Pablo Picaso) => パブロ・ピカソ 
- /nas/models/experiment/ja-en/wmt2021/scripts/get_devset.sh
    - gets dev set from wmt2020 link
    - moves to dev directory