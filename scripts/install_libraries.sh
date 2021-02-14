#! /bin/bash
# Author: Giang Le
# Bash script to install the packages needed to train an NMT model.

DIR=`dirname "$0"`
BASE=$DIR/..

if [ ! -d $BASE/libraries ]; then
  mkdir $BASE/libraries
fi

if [ ! -d $BASE/libraries/moses ]; then
  echo "Installing Moses"
  git clone https://github.com/bricksdont/moses-scripts $BASE/libraries/moses
fi

#if [ ! -d $BASE/joeynmt ]; then
#  echo "Installing JoeyNMT"
#  git clone https://github.com/joeynmt/joeynmt.git $BASE/libraries/joeynmt
#  (cd $BASE/libraries/joeynmt && pip install .)
#fi

#if [ ! -d $BASE/libraries/kytea ]; then
#  echo "Installing Japanese tokenizer"
#  wget http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz
#  tar -xzf kytea-0.4.7.tar.gz
#  (cd kytea-0.4.7 && ./configure && make && sudo make install)
#  mv kytea-0.4.7 $BASE/libraries/kytea
#fi

echo "Installing subword-nmt"
pip install https://github.com/rsennrich/subword-nmt/archive/master.zip

# This one was installed successfully.
if [ ! -d $BASE/libraries/mecab ]; then
  echo "Installing MeCab for Japanese tokenization"
  git clone https://github.com/taku910/mecab.git $BASE/libraries/mecab
  (cd $BASE/libraries/mecab/mecab && ./configure --enable-utf8-only && make && sudo make install)
fi

# It's better to use Unidic instead of IPAdic as IPAdic is out of date and not being actively maintained, but there's some failure related to unidic config in MeCab right now.
# This one was installed successfully.
if [ ! -d $BASE/libraries/unidic ]; then
echo "Installing Japanese UniDic"
mkdir $BASE/libraries/unidic
wget https://unidic.ninjal.ac.jp/unidic_archive/cwj/2.1.2/unidic-mecab-2.1.2_src.zip
mv $BASE/unidic-mecab-2.1.2_src.zip $BASE/libraries/unidic
unzip $BASE/libraries/unidic/unidic-mecab-2.1.2_src.zip
mv $BASE/unidic-mecab-2.1.2_src $BASE/libraries/unidic/unidic-mecab-2.1.2_src
(cd $BASE/libraries/unidic/unidic-mecab-2.1.2_src && ./configure && make && sudo make install)
echo "Modify the dicdir of MeCab"
sed -ie "s@dicdir =  /usr/local/lib/mecab/dic/ipadic@dicdir =  /usr/local/lib/mecab/dic/unidic@" $BASE/libraries/mecab/mecab/mecabrc
fi

echo "Installing fugashi, a Python wrapper of MeCab"
# Couldn't install fugashi on the server, so I was unable to process Japanese data on the server.
pip install fugashi
#if [ ! -d $BASE/libraries/fugashi ]; then
#git clone https://github.com/polm/fugashi.git $BASE/libraries/fugashi
#(cd $BASE/libraries/fugashi && python setup.py install)
#fi

# ipadic in /home/gianghl2/.local/lib/python2.7/site-packages but then I will need to be in python3 virtual env to run OpenNMT later?
echo "Installing MeCab IPA dic"
pip install ipadic

echo "Installing character converter"
pip install pykakasi

# Download OpenNMT-py from source
if [ ! -d $BASE/libraries/OpenNMT ]; then
git clone https://github.com/OpenNMT/OpenNMT-py.git $BASE/libraries/OpenNMT
(cd $BASE/libraries/OpenNMT && python setup.py install)
fi

# Install Ginza for morphological analyzer
pip install -U ginza
