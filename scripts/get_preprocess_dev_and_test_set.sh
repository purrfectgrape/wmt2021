DIR=`dirname "$0"`
BASE=$DIR/..

wget http://data.statmt.org/wmt20/translation-task/dev.tgz
mv dev.tgz $BASE/data/wmt2020_dev
tar -xvf $BASE/data/dev/dev.tgz
mkdir $BASE/data/wmt2020_dev/dev/enja
find $BASE/data/wmt2020_dev/dev  -name "*ja*"  -exec mv -t $BASE/data/wmt2020_dev/dev/enja {} +
# 
wget http://data.statmt.org/wmt20/translation-task/test.tgz
mv dev.tgz $BASE/data/test/wmt2020
tar -xvf $BASE/data/test/dev.tgz
find $BASE/data/test/wmt2020/sgm  -name "*ja*"  -exec mv -t $BASE/data/test/wmt2020/enja {} +

