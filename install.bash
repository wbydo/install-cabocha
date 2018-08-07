#!/bin/bash

set -e
cd `dirname $0`

cabocha="cabocha-0.69"

curl -c ./cookie "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU"
getcode="$(awk '/_warning_/ {print $NF}' ./cookie)"
curl -Lb ./cookie -o $cabocha.tar.bz2 "https://drive.google.com/uc?export=download&confirm=${getcode}&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU"
rm cookie

mkdir -p $cabocha
cd $cabocha

mkdir -p src && tar zxvf ../$cabocha.tar.bz2 -C src --strip-components 1
rm ../$cabocha.tar.bz2

cd src
export CPPFLAGS="-I$CRFPP_ROOT/include $(mecab-config --cflags) -I/usr/local/include"
export LDFLAGS="-L$CRFPP_ROOT/lib $(mecab-config --libs) -L/usr/local/lib"
./configure --prefix=`cd .. ; pwd` --with-charset=utf8
make
make install

cd ..
rm -rf src
