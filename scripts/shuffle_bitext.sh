paste -d '\t' /nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.ja /nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext.en | shuf | awk -v FS='\t' '{ print $1 > "/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext-shuffled.ja" ; print $2 > "/nas/models/experiment/ja-en/wmt2021/data/train/preprocessed/wmt2021-bitext-shuffled.en" }'
