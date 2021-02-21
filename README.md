# wmt2021
Repository for WMT 2021

# Get Data
./scripts/get_data.sh -c paracrawl
./scripts/get_data.sh -c reuters

# To create small corpora
./scripts/preprocess_small_sample.sh

# Unzipping data and splitting to train, dev, test
./scripts/preprocess_data.sh

Once the script finishes running you should get the following sentence count:
Total number of JA PARACRAWL TRAIN sentences is 1292000
Total number of EN PARACRAWL TRAIN sentences is 1292000
Total number of JA PARACRAWL DEV sentences is 5000
Total number of EN PARACRAWL DEV sentences is 5000
Total number of JA PARACRAWL TEST sentences is 2373
Total number of EN PARACRAWL TEST sentences is 2373

# Process Paracrawl data
