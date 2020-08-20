# datamash

- https://www.gnu.org/software/datamash/manual/datamash.html
- https://www.gnu.org/software/datamash/manual/html_node/Available-Operations.html

---

## Installation Notes

- If you use `sudo apt install datamash`, check the version with `datamash --version`
- We need version `1.1.0` and above (for functions like `crosstab`)
- If not, follow these steps

```bash
# download the installer
wget -P /tmp/ ftp://ftp.gnu.org/gnu/datamash/datamash-1.1.1.tar.gz

# untar the file
mkdir /tmp/datamash
tar -xzf /tmp/datamash-1.1.1.tar.gz -C /tmp/datamash/

# build
cd /tmp/datamash
./configure
make
sudo make install

# if `datamash` doesn't run, copy the executable to the /usr/bin/ folder
sudo cp ./datamash /usr/bin/datamash

# run this to check
datamash --version

# read the documentation
datamash --help 
man datamash
info datamash
```

---

## Usage

Where op1 is the operation to perform on the values in column1. datamash reads input from stdin and performs one or more operations on the input data. If --group is used, each operation is performed on every group. If --group is not used, each operation is performed on all the values in the input file.


Syntax
```
datamash [option]… op1 column1  [op2 column2 …]
```

---





## Highlights

<br>

|Title|Features|
|---|---|
| Summary Statistics|  	            `count,min,max,mean,stdev,median,quartiles`|
| Header Lines and Column Names|  	Using files with header lines|
| Field Delimiters|                   	Tabs, Whitespace, other delimiters|
| Column Ranges|                 	Operating on multiple columns|
| Groupby|  	        **Groupby**, count, collapse|
| Check|  	                        Validate tabular structure|
| Crosstab|  	                        Cross-tabulation (**pivot-tables**)|
| Rounding numbers|  	                `round, ceil, floor, trunc, frac`|
| **Binning** numbers|  	                assigning numbers into fixed number of buckets|
| Binning strings|  	                assigning strings into fixed number of buckets|
| File operations |`transpose, reverse`|
| Line-Filtering operations |`rmdup`|
| Per-Line operations   |`base64, debase64, md5, sha1, sha256, sha512`|
| Numeric Grouping operations  |`sum, min, max, absmin, absmax`|
|Textual/Numeric Grouping operations |`count, first, last, rand, unique, collapse, countunique`|
| Statistical Grouping operations 1  |`mean, median, q1, q3, iqr, mode, antimode, pstdev, sstdev`|
|Statistical Grouping Operations 2|`, pvar, svar, mad, madraw, pskew, sskew, pkurt, skurt, dpo, jarque`|

---

## Also

<br>

- fills NAs!
- remove duplicates!

---

## MOAR Options

<br>

```
Grouping Options:

  -f, --full                print entire input line before op results
                              (default: print only the grouped keys)
                              
  -g, --group=X[,Y,Z]       group via fields X,[Y,Z]
                                                        
  -H, --headers             first input line is column headers, print column headers as first line
  
  -i, --ignore-case         ignore upper/lower case when comparing text;
                              this affects grouping, and string operations

  -s, --sort                sort the input before grouping; this removes the
                              need to manually pipe the input through 'sort'
                              
File Operation Options:

      --no-strict           allow lines with varying number of fields
      --filler=X            fill missing values with X (default %s)

General Options:

  -t, --field-separator=X   use X instead of TAB as field delimiter
      --narm                skip NA/NaN values
  -W, --whitespace          use whitespace (one or more spaces and/or tabs)
                            for field delimiters
```


```python
!ls -l ../data/raw | grep csv
```

    -rw-rw-r-- 1 dk dk        3619 May 16 10:51 countrynames.csv
    -rw-rw-r-- 1 dk dk  1489911208 May 16 10:51 Crimes_Chicago.csv
    -rw------- 1 dk dk   702878193 May 16 10:51 Flight_Delays.csv
    -rw------- 1 dk dk   702878193 May 16 23:10 flights.csv
    -rw-rw-r-- 1 dk dk         523 May 16 23:45 fromPandas_01.csv
    -rw-rw-r-- 1 dk dk         532 May 16 23:45 fromPandas_02.csv
    -rw-rw-r-- 1 dk dk   535743168 May 16 15:42 fromPandas.csv
    -rw-rw-r-- 1 dk dk          57 May 16 10:51 het-bool.csv
    -rw-rw-r-- 1 dk dk   742580451 May 16 18:59 kdd.csv
    -rw-rw-r-- 1 dk dk    28512235 May 16 18:49 millionSongsSample.csv
    -rw-rw-r-- 1 dk dk 10136806470 May 16 10:52 NYC__311Requests.csv
    -rw-rw-r-- 1 dk dk   151488712 May 16 10:52 worldcitiespop.csv


## basic `stat`s


```python
!head ../data/raw/fromPandas.csv | csvlook
```

    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  C00 | D01      | C02   | D03   | D04   | A05   | A06   | B07   | A08   | C09    |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  PO  | Alert    | 0.08  | -0.29 | 1.04  | 0.5   | -0.19 | 0.92  | -1.18 | 0.46   |
    |  PO  | Alert    | 0.86  | 1.81  | 2.28  | 1.58  | 0.79  | 1.19  | 0.99  | -1.17  |
    |  PO  | Critical | -0.04 | 0.52  | -0.52 | 0.34  | 2.09  | -0.6  | 0.85  | -1.14  |
    |  AR  | Critical | -0.28 | 0.56  | 0.69  | 0.62  | -0.28 | -0.25 | 0.64  | -2.03  |
    |  AR  | Critical | 0.04  | -0.38 | -0.66 | -1.76 | -0.13 | 0.6   | -2.06 | 0.96   |
    |  PO  | Critical | 0.77  | 1.48  | 0.16  | -0.59 | 0.94  | 0.48  | -0.32 | -0.55  |
    |  AR  | Alert    | -0.15 | 0.03  | -2.05 | -0.56 | -1.04 | 1.29  | 0.51  | -0.01  |
    |  PO  | Alert    | -0.17 | -0.4  | -0.16 | 2.65  | -0.48 | 0.25  | -1.1  | 0.77   |
    |  AR  | Alert    | -0.57 | -0.31 | -0.14 | -2.89 | 0.52  | 0.18  | -0.03 | 0.47   |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|



```python
!datamash -sHi -t, sum 3-6 < ../data/raw/fromPandas.csv | csvlook
```

    |-----------+----------+----------+-----------|
    |  sum(C02) | sum(D03) | sum(D04) | sum(A05)  |
    |-----------+----------+----------+-----------|
    |  4083.25  | 3448.1   | -2271.68 | -236.88   |
    |-----------+----------+----------+-----------|



```python
!datamash -t, -H min 3 q1 3 median 3 q3 3 max 3  < ../data/raw/fromPandas.csv | csvlook
```

    |-----------+---------+-------------+---------+-----------|
    |  min(C02) | q1(C02) | median(C02) | q3(C02) | max(C02)  |
    |-----------+---------+-------------+---------+-----------|
    |  -5.21    | -0.67   | -0          | 0.68    | 5.19      |
    |-----------+---------+-------------+---------+-----------|



```python
!datamash -t, -H mean A06 sstdev A06 < ../data/raw/fromPandas.csv | csvlook
```

    |--------------+------------------|
    |  mean(A06)   | sstdev(A06)      |
    |--------------+------------------|
    |  0.000461629 | 1.0001281946602  |
    |--------------+------------------|


## `groupby` operations


```python
!csvcut -c interaction_type,src_bytes,dst_bytes ../data/raw/kdd.csv | head | csvlook
```

    |-------------------+-----------+------------|
    |  interaction_type | src_bytes | dst_bytes  |
    |-------------------+-----------+------------|
    |  normal.          | 215       | 45076      |
    |  normal.          | 162       | 4528       |
    |  normal.          | 236       | 1228       |
    |  normal.          | 233       | 2032       |
    |  normal.          | 239       | 486        |
    |  normal.          | 238       | 1282       |
    |  normal.          | 235       | 1337       |
    |  normal.          | 234       | 1364       |
    |  normal.          | 239       | 1295       |
    |-------------------+-----------+------------|



```python
!datamash -sHi -t,  \
--group interaction_type \
   mean src_bytes,dst_bytes \
 sstdev src_bytes,dst_bytes < ../data/raw/kdd.csv | csvlook
# -t, because our file is comma delimited
# --sort because groupby needs it
# -H because the input has headers and we want the output to have them too
# --group for group-by
# -i to ignore case
# count is the aggregation function used (Remember the syntax <op1> <col1>)
```

    |----------------------------+--------------------+---------------------+-------------------+--------------------|
    |  GroupBy(interaction_type) | mean(src_bytes)    | mean(dst_bytes)     | sstdev(src_bytes) | sstdev(dst_bytes)  |
    |----------------------------+--------------------+---------------------+-------------------+--------------------|
    |  back.                     | 54156.355878348    | 8232.6495687699     | 3159.3602320464   | 616.23179457446    |
    |  buffer_overflow.          | 1400.4333333333    | 6339.8333333333     | 1337.1326162103   | 12440.664773466    |
    |  ftp_write.                | 220.75             | 5382.25             | 267.74761570234   | 13793.737530903    |
    |  guess_passwd.             | 125.33962264151    | 216.18867924528     | 3.037859799687    | 257.50228203647    |
    |  imap.                     | 347.58333333333    | 54948.666666667     | 629.92603582172   | 187158.40119454    |
    |  ipsweep.                  | 10.436583607083    | 4.394359426328      | 37.09492550297    | 462.19579938396    |
    |  land.                     | 0                  | 0                   | 0                 | 0                  |
    |  loadmodule.               | 151.88888888889    | 3009.8888888889     | 127.74529780431   | 2907.4277052252    |
    |  multihop.                 | 435.14285714286    | 213016.28571429     | 540.96038936057   | 382586.00499962    |
    |  neptune.                  | 0.0099942444942571 | 0.00082088250466177 | 10.347866229879   | 0.84992741107836   |
    |  nmap.                     | 24.424006908463    | 0.13255613126079    | 60.37052484509    | 4.7761242620571    |
    |  normal.                   | 1477.846250081     | 3234.6501113817     | 110500.41940105   | 34231.680610548    |
    |  perl.                     | 265.66666666667    | 2444                | 4.9328828623162   | 166.13548687743    |
    |  phf.                      | 51                 | 8127                | 0                 | 0                  |
    |  pod.                      | 1462.6515151515    | 0                   | 125.0980442777    | 0                  |
    |  portsweep.                | 431708.31182176    | 202681.31643138     | 20383536.155508   | 13983601.671997    |
    |  rootkit.                  | 294.7              | 4276.6              | 538.57817961328   | 7558.5449540386    |
    |  satan.                    | 0.99874150515983   | 2.1274855273093     | 35.927415459528   | 145.10315741745    |
    |  smurf.                    | 935.7730962012     | 0                   | 200.02142879934   | 0                  |
    |  spy.                      | 174.5              | 1193.5              | 88.388347648318   | 490.02499936228    |
    |  teardrop.                 | 28                 | 0.057201225740552   | 0                 | 1.2649097429583    |
    |  warezclient.              | 300219.5627451     | 719.31764705882     | 1200905.2431303   | 1104.4083239047    |
    |  warezmaster.              | 49.3               | 3922087.7           | 212.15513192002   | 2197498.9594262    |
    |----------------------------+--------------------+---------------------+-------------------+--------------------|



```python
!csvcut -c 9,10,15-19 ../data/raw/flights.csv | head | csvlook
```

    |----------------+-----------+----------+----------+--------+------+-----------|
    |  UniqueCarrier | FlightNum | ArrDelay | DepDelay | Origin | Dest | Distance  |
    |----------------+-----------+----------+----------+--------+------+-----------|
    |  WN            | 2891      | 1        | 7        | SMF    | ONT  | 389       |
    |  WN            | 462       | 8        | 13       | SMF    | PDX  | 479       |
    |  WN            | 1229      | 34       | 36       | SMF    | PDX  | 479       |
    |  WN            | 1355      | 26       | 30       | SMF    | PDX  | 479       |
    |  WN            | 2278      | -3       | 1        | SMF    | PDX  | 479       |
    |  WN            | 2386      | 3        | 10       | SMF    | PDX  | 479       |
    |  WN            | 409       | 47       | 56       | SMF    | PHX  | 647       |
    |  WN            | 1131      | -2       | 9        | SMF    | PHX  | 647       |
    |  WN            | 1212      | 44       | 47       | SMF    | PHX  | 647       |
    |----------------+-----------+----------+----------+--------+------+-----------|



```python
# exclude missing data manually

! csvtk filter -f "15-16>0" ../data/raw/flights.csv \
| datamash -t, -sHi -g UniqueCarrier,Origin,Dest \
mean ArrDelay,DepDelay \
| csvsort -r -c 'mean(ArrDelay)' \
| head | csvlook
```

    |-------------------------+-----------------+---------------+----------------+-----------------|
    |  GroupBy(UniqueCarrier) | GroupBy(Origin) | GroupBy(Dest) | mean(ArrDelay) | mean(DepDelay)  |
    |-------------------------+-----------------+---------------+----------------+-----------------|
    |  B6                     | ONT             | IAD           | 370.0          | 386.0           |
    |  XE                     | ELP             | MFE           | 316.0          | 307.0           |
    |  DL                     | SLC             | KOA           | 308.0          | 317.5           |
    |  OH                     | ACY             | MYR           | 252.0          | 222.0           |
    |  EV                     | RIC             | CVG           | 243.0          | 262.0           |
    |  UA                     | OAK             | LAX           | 231.0          | 248.0           |
    |  OH                     | MDT             | CLE           | 219.0          | 209.0           |
    |  OH                     | JAX             | CMH           | 217.0          | 165.0           |
    |  NW                     | DCA             | PLN           | 210.0          | 168.0           |
    |-------------------------+-----------------+---------------+----------------+-----------------|



```python
! csvtk filter -f "15-16=' '" ../data/raw/flights.csv | head
```

    [31m[ERRO][0m invalid filter: 15-16=' '



```python
!mlr 
```


```python
!datamash -t, -sHi -g UniqueCarrier,Origin,Dest \
mean ArrDelay,DepDelay < ../data/raw/flights.csv | head | csvlook
```

    datamash: invalid numeric value in line 2 field 15: 'NA'
    sort: write failed: 'standard output': Broken pipe
    sort: write error
    |-------------------------+-----------------+---------------+----------------+-----------------|
    |  GroupBy(UniqueCarrier) | GroupBy(Origin) | GroupBy(Dest) | mean(ArrDelay) | mean(DepDelay)  |
    |-------------------------+-----------------+---------------+----------------+-----------------|


---
## `dealing with missing data`

- check with `csvstat --nulls`
- remove with `awk`
- fill with `datamash`


```python
!csvstat -c 15-16 --nulls ../data/raw/flights.csv
```

     15. ArrDelay: True
     16. DepDelay: True


---

> **Drop rows with missing data in a particular column**

```bash
# ignore rows with null values in column 5
$ awk -F, '!length($5)' file
# 1,abc,543,87,,fsg; 
# 1,abc,543,88,,fsg;
```

---


```python
import pandas as pd
import numpy as np

df = pd.DataFrame(data=np.random.randn(10, 10).round(2))
df.iloc[::2, ::2] = np.nan
df.columns = ['C' + str(i).zfill(2) for i in range(10)]
df.to_csv('fp2.csv', index=False)
df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>C00</th>
      <th>C01</th>
      <th>C02</th>
      <th>C03</th>
      <th>C04</th>
      <th>C05</th>
      <th>C06</th>
      <th>C07</th>
      <th>C08</th>
      <th>C09</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>NaN</td>
      <td>-0.65</td>
      <td>NaN</td>
      <td>-0.51</td>
      <td>NaN</td>
      <td>2.10</td>
      <td>NaN</td>
      <td>-0.01</td>
      <td>NaN</td>
      <td>-0.11</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.14</td>
      <td>0.24</td>
      <td>-0.91</td>
      <td>-0.54</td>
      <td>0.72</td>
      <td>1.14</td>
      <td>-0.07</td>
      <td>0.02</td>
      <td>-0.05</td>
      <td>1.07</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>0.81</td>
      <td>NaN</td>
      <td>-1.10</td>
      <td>NaN</td>
      <td>1.01</td>
      <td>NaN</td>
      <td>-1.88</td>
      <td>NaN</td>
      <td>-3.18</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.14</td>
      <td>-0.25</td>
      <td>-2.19</td>
      <td>0.40</td>
      <td>1.34</td>
      <td>-0.96</td>
      <td>0.27</td>
      <td>0.26</td>
      <td>-1.02</td>
      <td>-0.37</td>
    </tr>
    <tr>
      <th>4</th>
      <td>NaN</td>
      <td>0.34</td>
      <td>NaN</td>
      <td>-0.81</td>
      <td>NaN</td>
      <td>0.80</td>
      <td>NaN</td>
      <td>1.13</td>
      <td>NaN</td>
      <td>-0.15</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-2.23</td>
      <td>-0.90</td>
      <td>-0.52</td>
      <td>0.54</td>
      <td>-1.07</td>
      <td>1.47</td>
      <td>-0.58</td>
      <td>-0.46</td>
      <td>0.53</td>
      <td>-1.79</td>
    </tr>
    <tr>
      <th>6</th>
      <td>NaN</td>
      <td>-0.44</td>
      <td>NaN</td>
      <td>-0.48</td>
      <td>NaN</td>
      <td>-0.73</td>
      <td>NaN</td>
      <td>-0.28</td>
      <td>NaN</td>
      <td>-1.94</td>
    </tr>
    <tr>
      <th>7</th>
      <td>-2.73</td>
      <td>-0.22</td>
      <td>1.87</td>
      <td>0.92</td>
      <td>-0.02</td>
      <td>-0.44</td>
      <td>0.48</td>
      <td>1.48</td>
      <td>-1.62</td>
      <td>0.92</td>
    </tr>
    <tr>
      <th>8</th>
      <td>NaN</td>
      <td>-0.31</td>
      <td>NaN</td>
      <td>-0.58</td>
      <td>NaN</td>
      <td>0.46</td>
      <td>NaN</td>
      <td>0.10</td>
      <td>NaN</td>
      <td>0.81</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-1.36</td>
      <td>0.29</td>
      <td>-0.73</td>
      <td>0.34</td>
      <td>-1.85</td>
      <td>-1.64</td>
      <td>1.15</td>
      <td>-0.23</td>
      <td>-1.35</td>
      <td>1.11</td>
    </tr>
  </tbody>
</table>
</div>



### Checking for nulls

### Checking for missing or extra fields


```python
!datamash -t, check < fp2.csv
```

    11 lines, 10 fields



```python
%%writefile fp3.csv
C01,C02,C03
0,10,100
0000,0001,0010
0011,0100,0101,0110
0111,1000,1001
```

    Overwriting fp3.csv



```python
!datamash -t, check < fp3.csv
```

    line 3 (3 fields):
      0000,0001,0010
    line 4 (4 fields):
      0011,0100,0101,0110
    datamash: check failed: line 4 has 4 fields (previous line had 3)


### Checking for nulls


```python
!csvstat --nulls fp2.csv
```

      1. C00: True
      2. C01: False
      3. C02: True
      4. C03: False
      5. C04: True
      6. C05: False
      7. C06: True
      8. C07: False
      9. C08: True
     10. C09: False


### Filtering for rows with nulls


```python
!csvsql --query "SELECT * \
FROM fp2 \
WHERE C00 IS NULL" fp2.csv | csvlook
```

    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|
    |  C00 | C01   | C02 | C03   | C04 | C05   | C06 | C07   | C08 | C09    |
    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|
    |      | -0.04 |     | 2.58  |     | 0.65  |     | 0.45  |     | -0.47  |
    |      | 1.19  |     | 1.35  |     | -0.04 |     | 0.06  |     | -0.08  |
    |      | -1.7  |     | -0.38 |     | -0.93 |     | -1.17 |     | -0.22  |
    |      | 0.05  |     | 0.94  |     | -0.44 |     | 0.56  |     | -0.59  |
    |      | -1.7  |     | -2.03 |     | -1.15 |     | 1.84  |     | 0.11   |
    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|



```python
194.78.85.8
```


```python
# select rows where C00 isnull
!mlr --csv --rs lf cat  \
then filter 'is_null($C00)' fp2.csv | csvlook
```

    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|
    |  C00 | C01   | C02 | C03   | C04 | C05   | C06 | C07   | C08 | C09    |
    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|
    |      | -0.04 |     | 2.58  |     | 0.65  |     | 0.45  |     | -0.47  |
    |      | 1.19  |     | 1.35  |     | -0.04 |     | 0.06  |     | -0.08  |
    |      | -1.7  |     | -0.38 |     | -0.93 |     | -1.17 |     | -0.22  |
    |      | 0.05  |     | 0.94  |     | -0.44 |     | 0.56  |     | -0.59  |
    |      | -1.7  |     | -2.03 |     | -1.15 |     | 1.84  |     | 0.11   |
    |------+-------+-----+-------+-----+-------+-----+-------+-----+--------|



```python

```


```python
!mlr --csv --rs lf cat  \
then filter '$ArrDelay == "NA"' ../data/raw/flights.csv | head | csvcut -c ArrDelay,Origin,Dest | csvlook
```

    |-----------+--------+-------|
    |  ArrDelay | Origin | Dest  |
    |-----------+--------+-------|
    |  NA       | SNA    | LAS   |
    |  NA       | AUS    | DAL   |
    |  NA       | DAL    | AUS   |
    |  NA       | DAL    | HOU   |
    |  NA       | DAL    | HOU   |
    |  NA       | DAL    | HOU   |
    |  NA       | HOU    | DAL   |
    |  NA       | HOU    | DAL   |
    |  NA       | HOU    | DAL   |
    |-----------+--------+-------|



```python
!csvgrep -c ArrDelay -r NA ../data/raw/flights.csv | head | cut -d, -f5,7,12,15-18 | csvlook
```

    |----------+---------+-------------------+----------+----------+--------+-------|
    |  DepTime | ArrTime | ActualElapsedTime | ArrDelay | DepDelay | Origin | Dest  |
    |----------+---------+-------------------+----------+----------+--------+-------|
    |  NA      | NA      | NA                | NA       | NA       | SNA    | LAS   |
    |  NA      | NA      | NA                | NA       | NA       | AUS    | DAL   |
    |  NA      | NA      | NA                | NA       | NA       | DAL    | AUS   |
    |  NA      | NA      | NA                | NA       | NA       | DAL    | HOU   |
    |  NA      | NA      | NA                | NA       | NA       | DAL    | HOU   |
    |  NA      | NA      | NA                | NA       | NA       | DAL    | HOU   |
    |  NA      | NA      | NA                | NA       | NA       | HOU    | DAL   |
    |  NA      | NA      | NA                | NA       | NA       | HOU    | DAL   |
    |  NA      | NA      | NA                | NA       | NA       | HOU    | DAL   |
    |----------+---------+-------------------+----------+----------+--------+-------|



```python
!csvgrep -c ArrDelay,DepDelay,DepTime,ArrTime -r NA ../data/raw/flights.csv | wc -l
```

    160749



```python
!csvgrep -c ArrDelay,DepDelay,DepTime,ArrTime -r '^NA$' ../data/raw/flights.csv | wc -l
```

    160749


### Marking/Isolating rows with Nulls


```python
!mlr --csv --rs lf cat  \
then put '$C00_isnull = is_null($C00)' fp2.csv | csvlook
```

    |--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------------|
    |  C00   | C01   | C02   | C03   | C04   | C05   | C06   | C07   | C08   | C09   | C00_isnull  |
    |--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------------|
    |        | -0.04 |       | 2.58  |       | 0.65  |       | 0.45  |       | -0.47 | true        |
    |  0.66  | -0.75 | 1.26  | 0.07  | 0.18  | -1.09 | 0.9   | -1.92 | 0.04  | -1.02 | false       |
    |        | 1.19  |       | 1.35  |       | -0.04 |       | 0.06  |       | -0.08 | true        |
    |  0.37  | 0.79  | -0.63 | -0.18 | 1.51  | -1.55 | -0.82 | 0.46  | 0.47  | 1.02  | false       |
    |        | -1.7  |       | -0.38 |       | -0.93 |       | -1.17 |       | -0.22 | true        |
    |  0.89  | 1.46  | -2.24 | -1.29 | -0.79 | 0.51  | 1.28  | 1.75  | 0.64  | -1.8  | false       |
    |        | 0.05  |       | 0.94  |       | -0.44 |       | 0.56  |       | -0.59 | true        |
    |  -1.04 | 0.4   | 1.67  | -1.06 | 0.81  | 0.19  | 0.3   | 0.18  | -0.37 | -1.79 | false       |
    |        | -1.7  |       | -2.03 |       | -1.15 |       | 1.84  |       | 0.11  | true        |
    |  1.24  | 0.29  | 0.72  | -1.67 | -0.16 | 1.7   | 0.5   | 0.09  | -0.77 | -0.49 | false       |
    |--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------------|


## `crosstabs, pivot tables`


```python

```


```python
!datamash crosstab --help
```

    Usage: datamash [OPTION] op [fld] [op fld ...]
    
    Performs numeric/string operations on input from stdin.
    
    'op' is the operation to perform.  If a primary operation is used,
    it must be listed first, optionally followed by other operations.
    'fld' is the input field to use.  'fld' can be a number (1=first field),
    or a field name when using the -H or --header-in options.
    Multiple fields can be listed with a comma (e.g. 1,6,8).  A range of
    fields can be listed with a dash (e.g. 2-8).  Use colons for operations
    which require a pair of fields (e.g. 'pcov 2:6').
    
    
    Primary operations:
      groupby, crosstab, transpose, reverse, check
    Line-Filtering operations:
      rmdup
    Per-Line operations:
      base64, debase64, md5, sha1, sha256, sha512,
      bin, strbin, round, floor, ceil, trunc, frac
    Numeric Grouping operations:
      sum, min, max, absmin, absmax
    Textual/Numeric Grouping operations:
      count, first, last, rand, unique, collapse, countunique
    Statistical Grouping operations:
      mean, median, q1, q3, iqr, mode, antimode, pstdev, sstdev, pvar,
      svar, mad, madraw, pskew, sskew, pkurt, skurt, dpo, jarque,
      scov, pcov, spearson, ppearson
    
    
    Grouping Options:
      -f, --full                print entire input line before op results
                                  (default: print only the grouped keys)
      -g, --group=X[,Y,Z]       group via fields X,[Y,Z];
                                  equivalent to primary operation 'groupby'
          --header-in           first input line is column headers
          --header-out          print column headers as first line
      -H, --headers             same as '--header-in --header-out'
      -i, --ignore-case         ignore upper/lower case when comparing text;
                                  this affects grouping, and string operations
      -s, --sort                sort the input before grouping; this removes the
                                  need to manually pipe the input through 'sort'
    File Operation Options:
          --no-strict           allow lines with varying number of fields
          --filler=X            fill missing values with X (default %s)
    
    General Options:
      -t, --field-separator=X   use X instead of TAB as field delimiter
          --narm                skip NA/NaN values
      -W, --whitespace          use whitespace (one or more spaces and/or tabs)
                                  for field delimiters
      -z, --zero-terminated     end lines with 0 byte, not newline
          --help     display this help and exit
          --version  output version information and exit
    
    
    Examples:
    
    Print the sum and the mean of values from column 1:
      $ seq 10 | datamash sum 1 mean 1
      55  5.5
    
    Transpose input:
      $ seq 10 | paste - - | datamash transpose
      1    3    5    7    9
      2    4    6    8    10
    
    For detailed usage information and examples, see
      man GNU datamash
    The manual and more examples are available at
      http://www.gnu.org/software/datamash
    



```python
!man datamash | grep crosstab
```

    <standard input>:161: a space character is not allowed in an escape name
                  groupby, crosstab, transpose, reverse, check
           numbers  (groupby,  crosstab) while others do not (reverse,check,trans‐
           crosstab X,Y [op fld ...]
                  $ datamash -s crosstab 1,2 < input.txt
                  $ datamash -s crosstab 1,2 sum 3 < input.txt
                  $ datamash -s crosstab 1,2 unique 3 < input.txt



```python

```


```python
!cat ../data/raw/fromPandas.csv | datamash -t, -s -H crosstab 1,2 | sed '1d' | csvlook
```

    |-----+---------+----------+--------+-----------|
    |     | Alert   | Critical | Ignore | Shutdown  |
    |-----+---------+----------+--------+-----------|
    |  AR | 2700486 | 2274768  | 29093  | 15405     |
    |  EN | 775     | 682      | 7      | 4         |
    |  ES | 2171    | 1762     | 17     | 17        |
    |  FR | 291865  | 246750   | 3147   | 1652      |
    |  PO | 2225076 | 1874976  | 24232  | 12440     |
    |  RU | 158732  | 133364   | 1661   | 918       |
    |-----+---------+----------+--------+-----------|


### Checking for nulls


```python
!cat ../data/raw/fromPandas.csv | datamash -t, -s -H crosstab C00,D01
# default aggfunc is `count`
```

    datamash: src/column-headers.c:63: get_input_field_name: Assertion `field_num > 0 && field_num <= num_input_column_headers' failed.
    GroupBy(C00),GroupBy(D01),Aborted (core dumped)



```python

```


```python
!cat ../data/raw/fromPandas.csv | datamash -t, -s -H crosstab 1,2 mean 3 | sed '1d' | csvlook
```

    |-----+---------------------+----------------------+---------------------+---------------------|
    |     | Alert               | Critical             | Ignore              | Shutdown            |
    |-----+---------------------+----------------------+---------------------+---------------------|
    |  AR | 0.00096527810179353 | 0.00045535193039466  | -0.0031327123363008 | 0.0037702044790652  |
    |  EN | -0.016554838709677  | 0.049560117302053    | 0.24714285714286    | -0.0575             |
    |  ES | 0.011879318286504   | 0.07194665153235     | -0.028823529411765  | 0.16117647058824    |
    |  FR | 0.00023079163311805 | -0.0020542249240122  | 0.0017572291070861  | -0.018807506053269  |
    |  PO | 2.670470581679e-05  | 0.00029508644377315  | -0.012478128095081  | 0.011842443729904   |
    |  RU | 0.0020377743618174  | -6.1860772022435e-05 | 9.59528713759e-21   | -0.012320261437908  |
    |-----+---------------------+----------------------+---------------------+---------------------|



```python
!mlr cut -h
```

    Usage: mlr cut [options]
    Passes through input records with specified fields included/excluded.
    -f {a,b,c}       Field names to include for cut.
    -o               Retain fields in the order specified here in the argument list.
                     Default is to retain them in the order found in the input data.
    -x|--complement  Exclude, rather than include, field names specified by -f.
    -r               Treat field names as regular expressions. "ab", "a.*b" will
                     match any field name containing the substring "ab" or matching
                     "a.*b", respectively; anchors of the form "^ab$", "^a.*b$" may
                     be used. The -o flag is ignored when -r is present.
    Examples:
      mlr cut -f hostname,status
      mlr cut -x -f hostname,status
      mlr cut -r -f '^status$,sda[0-9]'
      mlr cut -r -f '^status$,"sda[0-9]"'
      mlr cut -r -f '^status$,"sda[0-9]"i' (this is case-insensitive)



```python
!csvcut -c 1-6,42 ../data/raw/kdd.csv | csvstat
```

      1. duration
    	<type 'int'>
    	Nulls: False
    	Min: 0
    	Max: 58329
    	Sum: 236802060
    	Mean: 48.342430464
    	Median: 0
    	Standard Deviation: 723.329737422
    	Unique values: 9883
    	5 most frequent values:
    		0:	4779492
    		1:	23886
    		2:	8139
    		3:	6016
    		5:	5576
      2. protocol_type
    	<type 'unicode'>
    	Nulls: False
    	Values: udp, icmp, tcp
      3. service
    	<type 'unicode'>
    	Nulls: False
    	Unique values: 70
    	5 most frequent values:
    		ecr_i:	2811660
    		private:	1100831
    		http:	623091
    		smtp:	96554
    		other:	72653
    	Max length: 11
      4. flag
    	<type 'unicode'>
    	Nulls: False
    	Unique values: 11
    	5 most frequent values:
    		SF:	3744328
    		S0:	869829
    		REJ:	268874
    		RSTR:	8094
    		RSTO:	5344
    	Max length: 6
      5. src_bytes
    	<type 'int'>
    	Nulls: False
    	Min: 0
    	Max: 1379963888
    	Sum: 8986765238
    	Mean: 1834.62117523
    	Median: 520
    	Standard Deviation: 941430.978396
    	Unique values: 7195
    	5 most frequent values:
    		1032:	2280245
    		0:	1152546
    		520:	527731
    		105:	73899
    		147:	27324
      6. dst_bytes
    	<type 'int'>
    	Nulls: False
    	Min: 0
    	Max: 1309937401
    	Sum: 5357035893
    	Mean: 1093.62281371
    	Median: 0
    	Standard Deviation: 645012.267904
    	Unique values: 21493
    	5 most frequent values:
    		0:	4064854
    		105:	44713
    		147:	24910
    		146:	22536
    		145:	9500
      7. interaction_type
    	<type 'unicode'>
    	Nulls: False
    	Unique values: 23
    	5 most frequent values:
    		smurf.:	2807886
    		neptune.:	1072017
    		normal.:	972781
    		satan.:	15892
    		ipsweep.:	12481
    	Max length: 16
    
    Row count: 4898431



```python
!csvcut -c 1-6,42 ../data/raw/kdd.csv \
| datamash -t, -sHi crosstab 4,2 mean 1 \
| sed '1d' | csvlook
```

    |---------+------+--------------------+------------------|
    |         | icmp | tcp                | udp              |
    |---------+------+--------------------+------------------|
    |  OTH    | N/A  | 0                  | N/A              |
    |  REJ    | N/A  | 0.0012384983300728 | N/A              |
    |  RSTO   | N/A  | 56.963323353293    | N/A              |
    |  RSTOS0 | N/A  | 2876.7049180328    | N/A              |
    |  RSTR   | N/A  | 3323.1266370151    | N/A              |
    |  S0     | N/A  | 0                  | N/A              |
    |  S1     | N/A  | 0                  | N/A              |
    |  S2     | N/A  | 6.2670807453416    | N/A              |
    |  S3     | N/A  | 429.98             | N/A              |
    |  SF     | 0    | 8.5918701456395    | 1045.2031520217  |
    |  SH     | N/A  | 0                  | N/A              |
    |---------+------+--------------------+------------------|



```python
!csvcut -n ../data/raw/kdd.csv
```

      1: duration
      2: protocol_type
      3: service
      4: flag
      5: src_bytes
      6: dst_bytes
      7: land
      8: wrong_fragment
      9: urgent
     10: hot
     11: num_failed_logins
     12: logged_in
     13: num_compromised
     14: root_shell
     15: su_attempted
     16: num_root
     17: num_file_creations
     18: num_shells
     19: num_access_files
     20: num_outbound_cmds
     21: is_host_login
     22: is_guest_login
     23: count
     24: srv_count
     25: serror_rate
     26: srv_serror_rate
     27: rerror_rate
     28: srv_rerror_rate
     29: same_srv_rate
     30: diff_srv_rate
     31: srv_diff_host_rate
     32: dst_host_count
     33: dst_host_srv_count
     34: dst_host_same_srv_rate
     35: dst_host_diff_srv_rate
     36: dst_host_same_src_port_rate
     37: dst_host_srv_diff_host_rate
     38: dst_host_serror_rate
     39: dst_host_srv_serror_rate
     40: dst_host_rerror_rate
     41: dst_host_srv_rerror_rate
     42: interaction_type



```python
# crosstabs with columns created on-the-fly
!cat ../data/raw/kdd.csv \
| mlr --csv --rs lf put '$attack = $interaction_type!="normal."' \
| datamash -t, -sHi crosstab 2,43 mean 1 | sed '1d' | csvlook
```

    |-------+-----------------+---------------------|
    |       | false           | true                |
    |-------+-----------------+---------------------|
    |  icmp | 0               | 0                   |
    |  tcp  | 11.481294964029 | 22.602477657342     |
    |  udp  | 1061.2623387754 | 0.0013605442176871  |
    |-------+-----------------+---------------------|



```python
!cat ../data/raw/kdd.csv \
| mlr --csv --rs lf put '$attack = $interaction_type!="normal."' \
| datamash -t, -sHi crosstab 2,43 mean 1 sstdev 1 | csvlook
# only one aggfunc allowed at a time
```

    datamash: crosstab supports one operation, found 2
    


---
## `transpose`, `reverse` (columns/rows)


```python
!cat fp2.csv
```

    C00,C01,C02,C03,C04,C05,C06,C07,C08,C09
    ,-0.65,,-0.51,,2.1,,-0.01,,-0.11
    0.14,0.24,-0.91,-0.54,0.72,1.14,-0.07,0.02,-0.05,1.07
    ,0.81,,-1.1,,1.01,,-1.88,,-3.18
    1.14,-0.25,-2.19,0.4,1.34,-0.96,0.27,0.26,-1.02,-0.37
    ,0.34,,-0.81,,0.8,,1.13,,-0.15
    -2.23,-0.9,-0.52,0.54,-1.07,1.47,-0.58,-0.46,0.53,-1.79
    ,-0.44,,-0.48,,-0.73,,-0.28,,-1.94
    -2.73,-0.22,1.87,0.92,-0.02,-0.44,0.48,1.48,-1.62,0.92
    ,-0.31,,-0.58,,0.46,,0.1,,0.81
    -1.36,0.29,-0.73,0.34,-1.85,-1.64,1.15,-0.23,-1.35,1.11



```python
!datamash -t, transpose < fp2.csv | csvlook
```

    |------+-------+-------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  C00 |       | 0.14  |       | 1.14  |       | -2.23 |       | -2.73 |       | -1.36  |
    |------+-------+-------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  C01 | -0.65 | 0.24  | 0.81  | -0.25 | 0.34  | -0.9  | -0.44 | -0.22 | -0.31 | 0.29   |
    |  C02 |       | -0.91 |       | -2.19 |       | -0.52 |       | 1.87  |       | -0.73  |
    |  C03 | -0.51 | -0.54 | -1.1  | 0.4   | -0.81 | 0.54  | -0.48 | 0.92  | -0.58 | 0.34   |
    |  C04 |       | 0.72  |       | 1.34  |       | -1.07 |       | -0.02 |       | -1.85  |
    |  C05 | 2.1   | 1.14  | 1.01  | -0.96 | 0.8   | 1.47  | -0.73 | -0.44 | 0.46  | -1.64  |
    |  C06 |       | -0.07 |       | 0.27  |       | -0.58 |       | 0.48  |       | 1.15   |
    |  C07 | -0.01 | 0.02  | -1.88 | 0.26  | 1.13  | -0.46 | -0.28 | 1.48  | 0.1   | -0.23  |
    |  C08 |       | -0.05 |       | -1.02 |       | 0.53  |       | -1.62 |       | -1.35  |
    |  C09 | -0.11 | 1.07  | -3.18 | -0.37 | -0.15 | -1.79 | -1.94 | 0.92  | 0.81  | 1.11   |
    |------+-------+-------+-------+-------+-------+-------+-------+-------+-------+--------|



```python
!head ../data/raw/fromPandas.csv | csvlook
```

    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  C00 | D01      | C02   | D03   | D04   | A05   | A06   | B07   | A08   | C09    |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  PO  | Alert    | 0.08  | -0.29 | 1.04  | 0.5   | -0.19 | 0.92  | -1.18 | 0.46   |
    |  PO  | Alert    | 0.86  | 1.81  | 2.28  | 1.58  | 0.79  | 1.19  | 0.99  | -1.17  |
    |  PO  | Critical | -0.04 | 0.52  | -0.52 | 0.34  | 2.09  | -0.6  | 0.85  | -1.14  |
    |  AR  | Critical | -0.28 | 0.56  | 0.69  | 0.62  | -0.28 | -0.25 | 0.64  | -2.03  |
    |  AR  | Critical | 0.04  | -0.38 | -0.66 | -1.76 | -0.13 | 0.6   | -2.06 | 0.96   |
    |  PO  | Critical | 0.77  | 1.48  | 0.16  | -0.59 | 0.94  | 0.48  | -0.32 | -0.55  |
    |  AR  | Alert    | -0.15 | 0.03  | -2.05 | -0.56 | -1.04 | 1.29  | 0.51  | -0.01  |
    |  PO  | Alert    | -0.17 | -0.4  | -0.16 | 2.65  | -0.48 | 0.25  | -1.1  | 0.77   |
    |  AR  | Alert    | -0.57 | -0.31 | -0.14 | -2.89 | 0.52  | 0.18  | -0.03 | 0.47   |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|



```python
# transpose
!head ../data/raw/fromPandas.csv \
| datamash -t, transpose | csvlook
```

    |------+-------+-------+----------+----------+----------+----------+-------+-------+--------|
    |  C00 | PO    | PO    | PO       | AR       | AR       | PO       | AR    | PO    | AR     |
    |------+-------+-------+----------+----------+----------+----------+-------+-------+--------|
    |  D01 | Alert | Alert | Critical | Critical | Critical | Critical | Alert | Alert | Alert  |
    |  C02 | 0.08  | 0.86  | -0.04    | -0.28    | 0.04     | 0.77     | -0.15 | -0.17 | -0.57  |
    |  D03 | -0.29 | 1.81  | 0.52     | 0.56     | -0.38    | 1.48     | 0.03  | -0.4  | -0.31  |
    |  D04 | 1.04  | 2.28  | -0.52    | 0.69     | -0.66    | 0.16     | -2.05 | -0.16 | -0.14  |
    |  A05 | 0.5   | 1.58  | 0.34     | 0.62     | -1.76    | -0.59    | -0.56 | 2.65  | -2.89  |
    |  A06 | -0.19 | 0.79  | 2.09     | -0.28    | -0.13    | 0.94     | -1.04 | -0.48 | 0.52   |
    |  B07 | 0.92  | 1.19  | -0.6     | -0.25    | 0.6      | 0.48     | 1.29  | 0.25  | 0.18   |
    |  A08 | -1.18 | 0.99  | 0.85     | 0.64     | -2.06    | -0.32    | 0.51  | -1.1  | -0.03  |
    |  C09 | 0.46  | -1.17 | -1.14    | -2.03    | 0.96     | -0.55    | -0.01 | 0.77  | 0.47   |
    |------+-------+-------+----------+----------+----------+----------+-------+-------+--------|


> - By default, `transpose` verifies the input has the same number of fields in each line, and fails with an error otherwise
- Use `--no-strict` to allow missing values
- Use `--filler` to set the missing-field filler value


```python
# to reverse the order of columns
!head ../data/raw/fromPandas.csv \
| datamash -t, reverse | csvlook
```

    |--------+-------+-------+-------+-------+-------+-------+-------+----------+------|
    |  C09   | A08   | B07   | A06   | A05   | D04   | D03   | C02   | D01      | C00  |
    |--------+-------+-------+-------+-------+-------+-------+-------+----------+------|
    |  0.46  | -1.18 | 0.92  | -0.19 | 0.5   | 1.04  | -0.29 | 0.08  | Alert    | PO   |
    |  -1.17 | 0.99  | 1.19  | 0.79  | 1.58  | 2.28  | 1.81  | 0.86  | Alert    | PO   |
    |  -1.14 | 0.85  | -0.6  | 2.09  | 0.34  | -0.52 | 0.52  | -0.04 | Critical | PO   |
    |  -2.03 | 0.64  | -0.25 | -0.28 | 0.62  | 0.69  | 0.56  | -0.28 | Critical | AR   |
    |  0.96  | -2.06 | 0.6   | -0.13 | -1.76 | -0.66 | -0.38 | 0.04  | Critical | AR   |
    |  -0.55 | -0.32 | 0.48  | 0.94  | -0.59 | 0.16  | 1.48  | 0.77  | Critical | PO   |
    |  -0.01 | 0.51  | 1.29  | -1.04 | -0.56 | -2.05 | 0.03  | -0.15 | Alert    | AR   |
    |  0.77  | -1.1  | 0.25  | -0.48 | 2.65  | -0.16 | -0.4  | -0.17 | Alert    | PO   |
    |  0.47  | -0.03 | 0.18  | 0.52  | -2.89 | -0.14 | -0.31 | -0.57 | Alert    | AR   |
    |--------+-------+-------+-------+-------+-------+-------+-------+----------+------|



```python
# Remember that `tac` reverses the rows
!head ../data/raw/fromPandas.csv \
| tac |csvlook
```

    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  AR  | Alert    | -0.57 | -0.31 | -0.14 | -2.89 | 0.52  | 0.18  | -0.03 | 0.47   |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  PO  | Alert    | -0.17 | -0.4  | -0.16 | 2.65  | -0.48 | 0.25  | -1.1  | 0.77   |
    |  AR  | Alert    | -0.15 | 0.03  | -2.05 | -0.56 | -1.04 | 1.29  | 0.51  | -0.01  |
    |  PO  | Critical | 0.77  | 1.48  | 0.16  | -0.59 | 0.94  | 0.48  | -0.32 | -0.55  |
    |  AR  | Critical | 0.04  | -0.38 | -0.66 | -1.76 | -0.13 | 0.6   | -2.06 | 0.96   |
    |  AR  | Critical | -0.28 | 0.56  | 0.69  | 0.62  | -0.28 | -0.25 | 0.64  | -2.03  |
    |  PO  | Critical | -0.04 | 0.52  | -0.52 | 0.34  | 2.09  | -0.6  | 0.85  | -1.14  |
    |  PO  | Alert    | 0.86  | 1.81  | 2.28  | 1.58  | 0.79  | 1.19  | 0.99  | -1.17  |
    |  PO  | Alert    | 0.08  | -0.29 | 1.04  | 0.5   | -0.19 | 0.92  | -1.18 | 0.46   |
    |  C00 | D01      | C02   | D03   | D04   | A05   | A06   | B07   | A08   | C09    |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|


---

## `binning` (or `discretization`)


```python
!head ../data/raw/fromPandas.csv | csvlook
```

    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  C00 | D01      | C02   | D03   | D04   | A05   | A06   | B07   | A08   | C09    |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|
    |  PO  | Alert    | 0.08  | -0.29 | 1.04  | 0.5   | -0.19 | 0.92  | -1.18 | 0.46   |
    |  PO  | Alert    | 0.86  | 1.81  | 2.28  | 1.58  | 0.79  | 1.19  | 0.99  | -1.17  |
    |  PO  | Critical | -0.04 | 0.52  | -0.52 | 0.34  | 2.09  | -0.6  | 0.85  | -1.14  |
    |  AR  | Critical | -0.28 | 0.56  | 0.69  | 0.62  | -0.28 | -0.25 | 0.64  | -2.03  |
    |  AR  | Critical | 0.04  | -0.38 | -0.66 | -1.76 | -0.13 | 0.6   | -2.06 | 0.96   |
    |  PO  | Critical | 0.77  | 1.48  | 0.16  | -0.59 | 0.94  | 0.48  | -0.32 | -0.55  |
    |  AR  | Alert    | -0.15 | 0.03  | -2.05 | -0.56 | -1.04 | 1.29  | 0.51  | -0.01  |
    |  PO  | Alert    | -0.17 | -0.4  | -0.16 | 2.65  | -0.48 | 0.25  | -1.1  | 0.77   |
    |  AR  | Alert    | -0.57 | -0.31 | -0.14 | -2.89 | 0.52  | 0.18  | -0.03 | 0.47   |
    |------+----------+-------+-------+-------+-------+-------+-------+-------+--------|



```python
# returns the lower edge of the window
!head ../data/raw/fromPandas.csv | csvcut -c C02 \
| datamash -H --full bin:0.25  1 \
| mlr --csv --ifs tab --ofs ',' cat \
| csvlook
```

    |--------+-----------|
    |  C02   | bin(C02)  |
    |--------+-----------|
    |  0.08  | 0         |
    |  0.86  | 0.75      |
    |  -0.04 | -0.25     |
    |  -0.28 | -0.5      |
    |  0.04  | 0         |
    |  0.77  | 0.75      |
    |  -0.15 | -0.25     |
    |  -0.17 | -0.25     |
    |  -0.57 | -0.75     |
    |--------+-----------|


---

## `round, trunc, ceil, floor, frac`


```python
!head ../data/raw/fromPandas.csv | csvcut -c C02 \
| datamash -H --full round 1 trunc 1 ceil 1 floor 1 frac 1 \
| mlr --csv --ifs tab --ofs ',' cat \
| csvlook
```

    |--------+------------+------------+-----------+------------+------------|
    |  C02   | round(C02) | trunc(C02) | ceil(C02) | floor(C02) | frac(C02)  |
    |--------+------------+------------+-----------+------------+------------|
    |  0.08  | 0          | 0          | 1         | 0          | 0.08       |
    |  0.86  | 1          | 0          | 1         | 0          | 0.86       |
    |  -0.04 | 0          | 0          | 0         | -1         | -0.04      |
    |  -0.28 | 0          | 0          | 0         | -1         | -0.28      |
    |  0.04  | 0          | 0          | 1         | 0          | 0.04       |
    |  0.77  | 1          | 0          | 1         | 0          | 0.77       |
    |  -0.15 | 0          | 0          | 0         | -1         | -0.15      |
    |  -0.17 | 0          | 0          | 0         | -1         | -0.17      |
    |  -0.57 | -1         | 0          | 0         | -1         | -0.57      |
    |--------+------------+------------+-----------+------------+------------|


---

# `datamash` Analysis Examples


```python
!head ../data/raw/kdd.csv | cut -d, -f1-6,42 | csvlook
```

    |-----------+---------------+---------+------+-----------+-----------+-------------------|
    |  duration | protocol_type | service | flag | src_bytes | dst_bytes | interaction_type  |
    |-----------+---------------+---------+------+-----------+-----------+-------------------|
    |  0        | tcp           | http    | SF   | 215       | 45076     | normal.           |
    |  0        | tcp           | http    | SF   | 162       | 4528      | normal.           |
    |  0        | tcp           | http    | SF   | 236       | 1228      | normal.           |
    |  0        | tcp           | http    | SF   | 233       | 2032      | normal.           |
    |  0        | tcp           | http    | SF   | 239       | 486       | normal.           |
    |  0        | tcp           | http    | SF   | 238       | 1282      | normal.           |
    |  0        | tcp           | http    | SF   | 235       | 1337      | normal.           |
    |  0        | tcp           | http    | SF   | 234       | 1364      | normal.           |
    |  0        | tcp           | http    | SF   | 239       | 1295      | normal.           |
    |-----------+---------------+---------+------+-----------+-----------+-------------------|



```python
# frequency tables
!cat ../data/raw/kdd.csv | cut -d, -f1-6,42 \
| datamash -sHi -t, --group 7 count 7 | csvlook
```

    |----------------------------+--------------------------|
    |  GroupBy(interaction_type) | count(interaction_type)  |
    |----------------------------+--------------------------|
    |  back.                     | 2203                     |
    |  buffer_overflow.          | 30                       |
    |  ftp_write.                | 8                        |
    |  guess_passwd.             | 53                       |
    |  imap.                     | 12                       |
    |  ipsweep.                  | 12481                    |
    |  land.                     | 21                       |
    |  loadmodule.               | 9                        |
    |  multihop.                 | 7                        |
    |  neptune.                  | 1072017                  |
    |  nmap.                     | 2316                     |
    |  normal.                   | 972781                   |
    |  perl.                     | 3                        |
    |  phf.                      | 4                        |
    |  pod.                      | 264                      |
    |  portsweep.                | 10413                    |
    |  rootkit.                  | 10                       |
    |  satan.                    | 15892                    |
    |  smurf.                    | 2807886                  |
    |  spy.                      | 2                        |
    |  teardrop.                 | 979                      |
    |  warezclient.              | 1020                     |
    |  warezmaster.              | 20                       |
    |----------------------------+--------------------------|



```python
# countunique
!cat ../data/raw/kdd.csv | cut -d, -f1-6,42 \
| datamash -sHi -t, --group 2 countunique 7 | csvlook
```

    |-------------------------+--------------------------------|
    |  GroupBy(protocol_type) | countunique(interaction_type)  |
    |-------------------------+--------------------------------|
    |  icmp                   | 7                              |
    |  tcp                    | 20                             |
    |  udp                    | 5                              |
    |-------------------------+--------------------------------|



```python
# groupby 1
!cat ../data/raw/kdd.csv | cut -d, -f1-6,42 \
| datamash -sHi -t, --group 2 mean 5 sstdev 5 \
| csvlook
```

    |-------------------------+-----------------+--------------------|
    |  GroupBy(protocol_type) | mean(src_bytes) | sstdev(src_bytes)  |
    |-------------------------+-----------------+--------------------|
    |  icmp                   | 927.89168938556 | 216.02705205438    |
    |  tcp                    | 3388.5699653266 | 1523443.9737618    |
    |  udp                    | 97.227728938483 | 47.667234078966    |
    |-------------------------+-----------------+--------------------|



```python
# groupby 2
!cat ../data/raw/kdd.csv | cut -d, -f1-6,42 \
| mlr --csv --rs lf put '$attack = $interaction_type!="normal."' \
| datamash -sHi -t, --group 2,8 mean 1 sstdev 1 2
| csvlook
```

    |-------------------------+-----------------+--------------------+--------------------|
    |  GroupBy(protocol_type) | GroupBy(attack) | mean(duration)     | sstdev(duration)   |
    |-------------------------+-----------------+--------------------+--------------------|
    |  icmp                   | false           | 0                  | 0                  |
    |  icmp                   | true            | 0                  | 0                  |
    |  tcp                    | false           | 11.481294964029    | 376.54007768793    |
    |  tcp                    | true            | 22.602477657342    | 824.78914040215    |
    |  udp                    | false           | 1061.2623387754    | 2799.4403718827    |
    |  udp                    | true            | 0.0013605442176871 | 0.073771111356332  |
    |-------------------------+-----------------+--------------------+--------------------|



```python
# groupby 2
!cat ../data/raw/kdd.csv | cut -d, -f1-6,42 \
| mlr --csv --rs lf put '$attack = $interaction_type!="normal."' \
| datamash -sHi -t, --group 2,8 mean 1 sstdev 1 \
| csvlook
```

    |-------------------------+-----------------+--------------------+--------------------|
    |  GroupBy(protocol_type) | GroupBy(attack) | mean(duration)     | sstdev(duration)   |
    |-------------------------+-----------------+--------------------+--------------------|
    |  icmp                   | false           | 0                  | 0                  |
    |  icmp                   | true            | 0                  | 0                  |
    |  tcp                    | false           | 11.481294964029    | 376.54007768793    |
    |  tcp                    | true            | 22.602477657342    | 824.78914040215    |
    |  udp                    | false           | 1061.2623387754    | 2799.4403718827    |
    |  udp                    | true            | 0.0013605442176871 | 0.073771111356332  |
    |-------------------------+-----------------+--------------------+--------------------|

