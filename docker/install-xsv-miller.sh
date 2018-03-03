#!/bin/bash
wget https://github.com/BurntSushi/xsv/releases/download/0.12.2/xsv-0.12.2-i686-unknown-linux-musl.tar.gz
tar -xvzf xsv-0.12.2-i686-unknown-linux-musl.tar.gz
mv xsv /usr/local/bin/
rm xsv-0.12.2-i686-unknown-linux-musl.tar.gz

wget https://github.com/johnkerl/miller/releases/download/v5.3.0/mlr-5.3.0.tar.gz
tar -xvzf mlr-5.3.0.tar.gz
cd mlr-5.3.0
./configure
make
make install
cd ..
rm -r mlr-5.3.0
rm mlr-5.3.0.tar.gz
