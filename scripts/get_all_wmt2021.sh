#! /bin/bash

for corpus in paracrawl news-commentary wikititles wikimatrix subtitles kftt ted newscrawl-ja news-commentary-ja commoncrawl-ja newscrawl-en news-discussion-en europarl-en news-commentary-en commoncrawl-en dev; do
  ./scripts/get_data.sh -c $corpus
done
