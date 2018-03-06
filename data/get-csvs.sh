#!/bin/bash

mkdir kdd_flights
cd kdd_flights

echo "Downloading the KDD Cup 1999"
echo "-----------------------------------------------------------------"
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.names
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.data.gz

echo "Uncompressing KDD Data"
echo "-----------------------------------------------------------------"
dtrx kddcup.data.gz

echo "Downloading the Flights Data"
echo "-----------------------------------------------------------------"
wget http://stat-computing.org/dataexpo/2009/2007.csv.bz2

echo "Uncompressing Flights Data"
echo "-----------------------------------------------------------------"
dtrx 2007.csv.bz2


echo "Done. Removing the compressed files"
echo "-----------------------------------------------------------------"
rm 2007.csv.bz2
rm kddcup.data.gz

echo "Cleaning up the KDD dataset"
echo "-----------------------------------------------------------------"

python ../clean-kdd.py
cat kddcup.data >> kdd.csv
rm kddcup.data
rm kddcup.names

echo "All done! Go ahead and work with kdd.csv and flights.csv"
