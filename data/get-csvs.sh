#!/bin/bash

echo "Downloading the KDD Cup 1999"
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.names
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.data.gz

echo "Uncompressing KDD Data"
dtrx kddcup.data.gz

echo "Downloading the Flights Data"
wget http://stat-computing.org/dataexpo/2009/2007.csv.bz2

echo "Uncompressing KDD Data"
dtrx 2007.csv.bz2

echo "Done. Removing the compressed files"

rm 2007.csv.bz2
rm kddcup.data.gz
