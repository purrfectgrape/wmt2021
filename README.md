# wmt2021
Repository for WMT 2021

# For a toy model
./scripts/get_data.sh -c reuters

# Unzipping data and splitting to train, dev, test
./scripts/preprocess_data.sh

# Installation
./scripts/install_libraries.sh

# Process English
./scripts/process_en.sh -c train

./scripts/process_en.sh -c dev

./scripts/process_en.sh -c test

./scripts/copy_en.sh


# Process Japanese (baseline and experiment)
Would fail in qivalluk server because of missing libraries

./scripts/process_ja.sh -c train-bl

./scripts/process_ja.sh -c dev-bl

./scripts/process_ja.sh -c test-bl

# Process training data in parallel
./scripts/parallel_processing.sh -c train-bl

# Build vocab
./scripts/build_vocab.sh -c bl
