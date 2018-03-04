#!/bin/bash
echo "-----------------------------------------------------------------"
echo "Downloading the KDD Cup 1999"
echo "-----------------------------------------------------------------"
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.names
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.data.gz

echo "-----------------------------------------------------------------"
echo "Uncompressing KDD Data"
echo "-----------------------------------------------------------------"
dtrx kddcup.data.gz

echo "-----------------------------------------------------------------"
echo "Downloading the Flights Data"
echo "-----------------------------------------------------------------"
wget http://stat-computing.org/dataexpo/2009/2007.csv.bz2

echo "-----------------------------------------------------------------"
echo "Uncompressing KDD Data"
echo "-----------------------------------------------------------------"
dtrx 2007.csv.bz2

echo "-----------------------------------------------------------------"
echo "Done. Removing the compressed files"
echo "-----------------------------------------------------------------"
rm 2007.csv.bz2
rm kddcup.data.gz
