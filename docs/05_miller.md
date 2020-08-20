# miller

---

- "Miller is like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON" 

- Github [repo](https://github.com/johnkerl/miller), [intro](http://johnkerl.org/miller/doc/10-min.html), 


---

## Installation

```bash
# remove preinstalled versions (usually outdated)
sudo apt remove miller

# download the new file
wget https://github.com/johnkerl/miller/releases/download/v5.1.0/mlr-5.1.0.tar.gz

# untar
tar -xzf mlr-5.1.0.tar.gz

# the usual
cd mlr-5.1.0.tar.gz
./configure
make
sudo make install

# check if the mlr executable is in /usr/bin (it could have been placed in /usr/local/bin)
# move it if required to /usr/bin/mlr
sudo cp /usr/local/bin/mlr /usr/bin/mlr
```

---

## Features

- useful for data cleaning, data reduction, statistical reporting, format conversion and so on.


- written in C

- is **format-aware**, and retains headers

- has high-throughput performance on par with the Unix toolkit

- complements `dplyr` and `pandas` by helping you clean-filter-aggregate your data for EDA

- **in-place** mutations to files

- But most importantly,

> Miller is **streaming**; most operations need only a single record in memory at a time (rather needing to hold the entire file in RAM). <br> Miller retains only as much data as needed for operations like `sort` and `stats`, so you can **operate on files which are larger than RAM**



> Miller complements **data-analysis tools** such as **R**, **pandas**, etc.:
you can use Miller to **clean** and **prepare** your data. While you can do
**basic statistics** entirely in Miller, its streaming-data feature and
single-pass algorithms enable you to **reduce very large data sets**.



---

## Commands

- Syntax

```bash
mlr <command> <options>
```

---

|Commands|Description|
|---|---|
|`cat, cut, grep, head, join, sort, tac, tail, top, uniq`|Analogs of their Unix-toolkit namesakes, discussed below as well as in Miller features in the context of the Unix toolkit|
|`filter, put, sec2gmt, sec2gmtdate, step, tee`|awk-like functionality|
|`bar, bootstrap, decimate, histogram, least-frequent, most-frequent, sample, shuffle, stats1, stats2`|Statistically oriented|
|`group-by, group-like, having-fields`|Particularly oriented toward Record-heterogeneity, although all Miller commands can handle heterogeneous records|
|`check, count-distinct, label, merge-fields, nest, nothing, rename, rename, reorder, reshape, seqgen`|These draw from other sources (see also How original is Miller?): count-distinct is SQL-ish, and rename can be done by sed (which does it faster: see Performance).|

---

All Verbs:

```
   bar bootstrap cat check count-distinct cut decimate filter grep group-by
   group-like having-fields head histogram join label least-frequent
   merge-fields most-frequent nest nothing fraction put regularize rename
   reorder repeat reshape sample sec2gmt sec2gmtdate seqgen shuffle sort stats1
   stats2 step tac tail tee top uniq unsparsify
```

Functions for the `filter` and `put` verbs:

```            
   + + - - * / // % ** | ^ & ~ << >> == != =~ !=~ > >= < <= && || ^^ ! ? : .
   gsub strlen sub substr tolower toupper abs acos acosh asin asinh atan atan2
   atanh cbrt ceil cos cosh erf erfc exp expm1 floor invqnorm log log10 log1p
   logifit madd max mexp min mmul msub pow qnorm round roundm sgn sin sinh sqrt
   tan tanh urand urand32 urandint dhms2fsec dhms2sec fsec2dhms fsec2hms
   gmt2sec hms2fsec hms2sec sec2dhms sec2gmt sec2gmt sec2gmtdate sec2hms
   strftime strptime systime is_absent is_bool is_boolean is_empty is_empty_map
   is_float is_int is_map is_nonempty_map is_not_empty is_not_map is_not_null
   is_null is_numeric is_present is_string asserting_absent asserting_bool
   asserting_boolean asserting_empty asserting_empty_map asserting_float
   asserting_int asserting_map asserting_nonempty_map asserting_not_empty
   asserting_not_map asserting_not_null asserting_null asserting_numeric
   asserting_present asserting_string boolean float fmtnum hexfmt int string
   typeof depth haskey joink joinkv joinv leafcount length mapdiff mapsum
   splitkv splitkvx splitnv splitnvx
```

---




---

## Options


- Use `--csv, --pprint` etc. when the input and output formats are the same.
- Use `--icsv --opprint`, etc. when you want format conversion
- Use the `mlr -I` flag **to process files in-place**, for example
- PLEASE USE `mlr --csv --rs lf` FOR NATIVE UN*X (LINEFEED-TERMINATED) CSV FILES.

```bash
mlr -I --csv cut -x -f <unwanted_column_name> mydata/*.csv 
# will remove unwanted_column_name from all your *.csv files in your mydata/ subdirectory.
```

---


## Examples


```bash
mlr --csv cut -f hostname,uptime mydata.csv
# Both input and output in csv

mlr --csv --rs lf --fs tab cut -f hostname,uptime file1.tsv file2.tsv
# Read tsv (--fs tab) created on unix (--rs lf) and retain named columns, concat into a csv files (--csv)


mlr --csv filter '$status != "down" && $upsec >= 10000' *.csv
# Retain specific rows

mlr --nidx put '$sum = $7 + 2.1*$8' *.dat
# NIDX: implicitly numerically indexed (Unix-toolkit style)
# create a new column from the values in the 7th and 8th columns

grep -v '^#' /etc/group | mlr --ifs : --nidx --opprint label group,pass,gid,member then sort -f group
# Ignore rows that begin with '#', input file is colon separated, rename columns, then sort and groupby

mlr join -j account_id -f accounts.dat then group-by account_name balances.dat
# 

mlr put '$attr = sub($attr, "([0-9]+)_([0-9]+)_.*", "\1:\2")' data/*
#

mlr stats1 -a min,mean,max,p10,p50,p90 -f flag,u,v data/*
#

mlr stats2 -a linreg-pca -f u,v -g shape data/*
#
```


---

## `mlr rename`

- Renames specified fields.
- Usage: mlr rename [options] {old1,new1,old2,new2,...}
    - use `-g` for global replacement, and `-r` for regex matching
    
    
```
Examples:
mlr rename old_name,new_name
mlr rename old_name_1,new_name_1,old_name_2,new_name_2
mlr rename -r 'Date_[0-9]+,Date,'  Rename all such fields to be "Date"
mlr rename -r '"Date_[0-9]+",Date' Same
mlr rename -r 'Date_([0-9]+).*,\1' Rename all such fields to be of the form 20151015
mlr rename -r '"name"i,Name'       Rename "name", "Name", "NAME", etc. to "Name"
```


```python
# replace spaces with underscores
!mlr --csv --ifs '|' --ofs ',' rename -g -r ' ,_' ./raw/Sales.txt > ./cleaned/Sales.csv
```


```python
!csvcut -n ./cleaned/Sales.csv
# or !xsv headers ./cleaned/Sales.csv
```

      1: POSSales_PK
      2: Date_FK
      3: Date
      4: Store_FK
      5: Item_FK
      6: Item_PK
      7: Promo_FK
      8: POSSales_Ticket_No
      9: POSSales_GiftList_No
     10: POSSales_GiftListLine_No
     11: POSSales_Sales_Quantity
     12: POSSales_Sales_AmountExVAT
     13: POSSales_Sales_AmountInVAT
     14: POSSales_Cost_Amount
     15: POSSales_Margin_Amount
     16: POSSales_Discount_Amount
     17: Store_No_BK
     18: POS_Terminal_No_BK
     19: Transaction_No_BK
     20: Line_No_BK


---

### `mlr cat, head, tail`

- `mlr head` and `mlr tail` count records rather than lines
- they always return the CSV header
    - `mlr head -n 5 myfile.csv` will return 6 lines.


```python
!mlr --csv cat flights.csv | head
```

    mlr: unacceptable empty CSV key at file "./raw/flights.csv" line 1.


---
- This is a very common error. 
- Caused becaused files generated on Unix-like systems have LF line terminators while RFC compliant CSVs have CRLF line terminators (default in miller)
- fix by including `--rs lf`
    - this says that the record separator (`rs`) is `lf`.


```python
!mlr --csv --rs lf head -n 5 flights.csv
```

    Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2007,1,1,1,1232,1225,1341,1340,WN,2891,N351,69,75,54,1,7,SMF,ONT,389,4,11,0,,0,0,0,0,0,0
    2007,1,1,1,1918,1905,2043,2035,WN,462,N370,85,90,74,8,13,SMF,PDX,479,5,6,0,,0,0,0,0,0,0
    2007,1,1,1,2206,2130,2334,2300,WN,1229,N685,88,90,73,34,36,SMF,PDX,479,6,9,0,,0,3,0,0,0,31
    2007,1,1,1,1230,1200,1356,1330,WN,1355,N364,86,90,75,26,30,SMF,PDX,479,3,8,0,,0,23,0,0,0,3
    2007,1,1,1,831,830,957,1000,WN,2278,N480,86,90,74,-3,1,SMF,PDX,479,3,9,0,,0,0,0,0,0,0


- read files with other delimiters by specifying `ifs` (or input field separator)
    - could be useful for file format conversion


```python
!mlr --csv --ifs '|' head -n 5 ./raw/Sales.txt
```

    POSSales_PK,Date_FK,Date,Store_FK,Item_FK,Item_PK,Promo_FK,POSSales_Ticket No,POSSales_GiftList No,POSSales_GiftListLine No,POSSales_Sales Quantity,POSSales_Sales AmountExVAT,POSSales_Sales AmountInVAT,POSSales_Cost Amount,POSSales_Margin Amount,POSSales_Discount Amount,Store No_BK,POS Terminal No_BK,Transaction No_BK,Line No_BK
    42169332,41639,2014-01-02 00:00:00,17,316213,20337325,806,3810195837,,0,"1,00000000000000000000","17,32231000000000000000","20,96000000000000000000","9,98000000000000000000","7,34231000000000000000","-8,99000000000000000000",S038,P0381,226847,10000
    42169333,41639,2014-01-02 00:00:00,17,274932,20194564,812,3810195837,,0,"1,00000000000000000000","43,38017000000000000000","52,49000000000000000000","35,86000000000000000000","7,52017000000000000000",",00000000000000000000",S038,P0381,226847,20000
    42169334,41639,2014-01-02 00:00:00,17,326727,20347663,63,3810195838,,0,"1,00000000000000000000","6,60331000000000000000","7,99000000000000000000","5,21000000000000000000","1,39331000000000000000",",00000000000000000000",S038,P0381,226848,10000
    42169335,41639,2014-01-02 00:00:00,17,311837,20332760,63,3810195838,,0,"1,00000000000000000000","24,78512000000000000000","29,99000000000000000000","12,23000000000000000000","12,55512000000000000000",",00000000000000000000",S038,P0381,226848,20000
    42169336,41639,2014-01-02 00:00:00,17,262025,20181754,63,3810195838,,0,"1,00000000000000000000","12,38843000000000000000","14,99000000000000000000","6,34000000000000000000","6,04843000000000000000",",00000000000000000000",S038,P0381,226848,30000



```python
# get the first record from every group that appears in the data
!mlr --csv --rs lf head -n 1 -g UniqueCarrier then cut -f Origin,Dest,UniqueCarrier,FlightNum flights.csv \
| head | csvlook
```

    |----------------+-----------+--------+-------|
    |  UniqueCarrier | FlightNum | Origin | Dest  |
    |----------------+-----------+--------+-------|
    |  WN            | 2891      | SMF    | ONT   |
    |  XE            | 2809      | CLE    | CLT   |
    |  YV            | 2827      | ABQ    | PHX   |
    |  OH            | 5026      | SAT    | CVG   |
    |  OO            | 3664      | SUN    | SLC   |
    |  UA            | 1         | ORD    | HNL   |
    |  US            | 290       | ABQ    | LAS   |
    |  DL            | 1772      | ATL    | PNS   |
    |  EV            | 4083      | ATL    | RDU   |
    |----------------+-----------+--------+-------|


---

### Chaining

- Output of one verb may be chained as input to another using "then", e.g.
  
```
mlr stats1 -a min,mean,max -f flag,u,v -g color then sort -f color
```

---
### `mlr cat`

- very useful for format conversion (`txt` -> `csv`)
    - fast!! (under a minute for a 4GB `txt` file)
    - and concatenating multiple same-schema CSV file
  
---  
    
```
mlr cat [options]
Passes input records directly to output. Most useful for format conversion.
Options:
-n                                 Prepend field "n" to each record with record-counter starting at 1
-g {comma-separated field name(s)} When used with -n/-N, writes record-counters
                                   keyed by specified field name(s).
-N {name}                          Prepend field {name} to each record with record-counter starting at 1
```

---


```python
import os 
os.chdir("/home/data")
```


```python
!ls | grep kdd
```

    kddcup.data
    kddcup.names



```python
!cat kddcup.names | sed 1d | cut -d: -f1
```

    duration
    protocol_type
    service
    flag
    src_bytes
    dst_bytes
    land
    wrong_fragment
    urgent
    hot
    num_failed_logins
    logged_in
    num_compromised
    root_shell
    su_attempted
    num_root
    num_file_creations
    num_shells
    num_access_files
    num_outbound_cmds
    is_host_login
    is_guest_login
    count
    srv_count
    serror_rate
    srv_serror_rate
    rerror_rate
    srv_rerror_rate
    same_srv_rate
    diff_srv_rate
    srv_diff_host_rate
    dst_host_count
    dst_host_srv_count
    dst_host_same_srv_rate
    dst_host_diff_srv_rate
    dst_host_same_src_port_rate
    dst_host_srv_diff_host_rate
    dst_host_serror_rate
    dst_host_srv_serror_rate
    dst_host_rerror_rate
    dst_host_srv_rerror_rate



```python
# converting pipe-delimited to csv
!mlr --csv --ifs '|' cat ./raw/Sales.txt > ./cleaned/Sales.csv
```


```python
!mlr --csv head -n 5 ./cleaned/Sales.csv
```

    POSSales_PK,Date_FK,Date,Store_FK,Item_FK,Item_PK,Promo_FK,POSSales_Ticket No,POSSales_GiftList No,POSSales_GiftListLine No,POSSales_Sales Quantity,POSSales_Sales AmountExVAT,POSSales_Sales AmountInVAT,POSSales_Cost Amount,POSSales_Margin Amount,POSSales_Discount Amount,Store No_BK,POS Terminal No_BK,Transaction No_BK,Line No_BK
    42169332,41639,2014-01-02 00:00:00,17,316213,20337325,806,3810195837,,0,"1,00000000000000000000","17,32231000000000000000","20,96000000000000000000","9,98000000000000000000","7,34231000000000000000","-8,99000000000000000000",S038,P0381,226847,10000
    42169333,41639,2014-01-02 00:00:00,17,274932,20194564,812,3810195837,,0,"1,00000000000000000000","43,38017000000000000000","52,49000000000000000000","35,86000000000000000000","7,52017000000000000000",",00000000000000000000",S038,P0381,226847,20000
    42169334,41639,2014-01-02 00:00:00,17,326727,20347663,63,3810195838,,0,"1,00000000000000000000","6,60331000000000000000","7,99000000000000000000","5,21000000000000000000","1,39331000000000000000",",00000000000000000000",S038,P0381,226848,10000
    42169335,41639,2014-01-02 00:00:00,17,311837,20332760,63,3810195838,,0,"1,00000000000000000000","24,78512000000000000000","29,99000000000000000000","12,23000000000000000000","12,55512000000000000000",",00000000000000000000",S038,P0381,226848,20000
    42169336,41639,2014-01-02 00:00:00,17,262025,20181754,63,3810195838,,0,"1,00000000000000000000","12,38843000000000000000","14,99000000000000000000","6,34000000000000000000","6,04843000000000000000",",00000000000000000000",S038,P0381,226848,30000



```python
# Create an index and extract a row from a specific index
!mlr --csv --rs lf head -n 10 then cat -n then filter '$n==2' flights.csv
```

    n,Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2,2007,1,1,1,2206,2130,2334,2300,WN,1229,N685,88,90,73,34,36,SMF,PDX,479,6,9,0,,0,3,0,0,0,31



```python
# Even numbered rows (creating an index isnt necessary)
!mlr --csv --rs lf head -n 10 then filter 'FNR%2==0' flights.csv
```

    Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2007,1,1,1,1918,1905,2043,2035,WN,462,N370,85,90,74,8,13,SMF,PDX,479,5,6,0,,0,0,0,0,0,0
    2007,1,1,1,1230,1200,1356,1330,WN,1355,N364,86,90,75,26,30,SMF,PDX,479,3,8,0,,0,23,0,0,0,3
    2007,1,1,1,1430,1420,1553,1550,WN,2386,N611SW,83,90,74,3,10,SMF,PDX,479,2,7,0,,0,0,0,0,0,0
    2007,1,1,1,944,935,1223,1225,WN,1131,N749SW,99,110,86,-2,9,SMF,PHX,647,4,9,0,,0,0,0,0,0,0
    2007,1,1,1,1318,1315,1603,1610,WN,2456,N630WN,105,115,92,-7,3,SMF,PHX,647,5,8,0,,0,0,0,0,0,0



```python
#provide implicit header (auto numeric) to headerless files

!cat flights.csv | sed 1d | cut -d, -f1-10 | head \
|mlr --csv --rs lf --implicit-csv-header cat \
|csvlook
```

    |-------+---+---+---+------+------+------+------+----+-------|
    |  1    | 2 | 3 | 4 | 5    | 6    | 7    | 8    | 9  | 10    |
    |-------+---+---+---+------+------+------+------+----+-------|
    |  2007 | 1 | 1 | 1 | 1232 | 1225 | 1341 | 1340 | WN | 2891  |
    |  2007 | 1 | 1 | 1 | 1918 | 1905 | 2043 | 2035 | WN | 462   |
    |  2007 | 1 | 1 | 1 | 2206 | 2130 | 2334 | 2300 | WN | 1229  |
    |  2007 | 1 | 1 | 1 | 1230 | 1200 | 1356 | 1330 | WN | 1355  |
    |  2007 | 1 | 1 | 1 | 831  | 830  | 957  | 1000 | WN | 2278  |
    |  2007 | 1 | 1 | 1 | 1430 | 1420 | 1553 | 1550 | WN | 2386  |
    |  2007 | 1 | 1 | 1 | 1936 | 1840 | 2217 | 2130 | WN | 409   |
    |  2007 | 1 | 1 | 1 | 944  | 935  | 1223 | 1225 | WN | 1131  |
    |  2007 | 1 | 1 | 1 | 1537 | 1450 | 1819 | 1735 | WN | 1212  |
    |  2007 | 1 | 1 | 1 | 1318 | 1315 | 1603 | 1610 | WN | 2456  |
    |-------+---+---+---+------+------+------+------+----+-------|
    cut: write error: Broken pipe



```python
# provide column names (if less than num_cols, the implicit names will be kept)

!cat flights.csv | sed 1d | cut -d, -f1-10 | head \
|mlr --csv --rs lf --implicit-csv-header label a,b,c,d \
|csvlook
```

    |-------+---+---+---+------+------+------+------+----+-------|
    |  a    | b | c | d | 5    | 6    | 7    | 8    | 9  | 10    |
    |-------+---+---+---+------+------+------+------+----+-------|
    |  2007 | 1 | 1 | 1 | 1232 | 1225 | 1341 | 1340 | WN | 2891  |
    |  2007 | 1 | 1 | 1 | 1918 | 1905 | 2043 | 2035 | WN | 462   |
    |  2007 | 1 | 1 | 1 | 2206 | 2130 | 2334 | 2300 | WN | 1229  |
    |  2007 | 1 | 1 | 1 | 1230 | 1200 | 1356 | 1330 | WN | 1355  |
    |  2007 | 1 | 1 | 1 | 831  | 830  | 957  | 1000 | WN | 2278  |
    |  2007 | 1 | 1 | 1 | 1430 | 1420 | 1553 | 1550 | WN | 2386  |
    |  2007 | 1 | 1 | 1 | 1936 | 1840 | 2217 | 2130 | WN | 409   |
    |  2007 | 1 | 1 | 1 | 944  | 935  | 1223 | 1225 | WN | 1131  |
    |  2007 | 1 | 1 | 1 | 1537 | 1450 | 1819 | 1735 | WN | 1212  |
    |  2007 | 1 | 1 | 1 | 1318 | 1315 | 1603 | 1610 | WN | 2456  |
    |-------+---+---+---+------+------+------+------+----+-------|
    cut: write error: Broken pipe


---

### `mlr cut`

- select columns by name with `-f`
- select all columns except some with `-x`


```python
# Print only Origin,Dest
!head -n 10 flights.csv \
| mlr --csv --rs lf  cut -f Origin,Dest \
| csvlook
```

    |---------+-------|
    |  Origin | Dest  |
    |---------+-------|
    |  SMF    | ONT   |
    |  SMF    | PDX   |
    |  SMF    | PDX   |
    |  SMF    | PDX   |
    |  SMF    | PDX   |
    |  SMF    | PDX   |
    |  SMF    | PHX   |
    |  SMF    | PHX   |
    |  SMF    | PHX   |
    |---------+-------|



```python
# print all except Origin, Dest
!head -n 5 flights.csv \
| mlr --csv --rs lf  cut -x -f Origin,Dest
```

    Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2007,1,1,1,1232,1225,1341,1340,WN,2891,N351,69,75,54,1,7,389,4,11,0,,0,0,0,0,0,0
    2007,1,1,1,1918,1905,2043,2035,WN,462,N370,85,90,74,8,13,479,5,6,0,,0,0,0,0,0,0
    2007,1,1,1,2206,2130,2334,2300,WN,1229,N685,88,90,73,34,36,479,6,9,0,,0,3,0,0,0,31
    2007,1,1,1,1230,1200,1356,1330,WN,1355,N364,86,90,75,26,30,479,3,8,0,,0,23,0,0,0,3



```python
!mlr --csv head -n 10 then cut -r -f "Amount" ./cleaned/Sales.csv | xsv headers
```

    1   POSSales_Sales_AmountExVAT
    2   POSSales_Sales_AmountInVAT
    3   POSSales_Cost_Amount
    4   POSSales_Margin_Amount
    5   POSSales_Discount_Amount



```python
!mlr --csv head -n 10 then cut -r -f "Quantity" ./cleaned/Sales.csv | xsv headers
```

    1   POSSales_Sales_Quantity



```python
!mlr --csv head -n 10 then having-fields --all-matching 'Quantity' ./cleaned/Sales.csv 
```

---

### `mlr filter`

- retain specific records

```
Examples:
  mlr filter 'log10($count) > 4.0'
  mlr filter 'FNR == 2'
  mlr filter 'urand() < 0.001'
  mlr filter '$color != "blue" && $value > 4.2'
  mlr filter '($x<.5 && $y<.5) || ($x>.5 && $y>.5)'
  mlr filter '($name =~ "^sys.*east$") || ($name =~ "^dev.[0-9]+"i)'
  mlr filter '$ab = $a+$b; $cd = $c+$d; $ab != $cd'
```


```python
# single condition
!mlr --csv --rs lf filter '$Origin == "SFO"' flights.csv \
|csvcut -c Origin,Dest | head | csvlook
```

    |---------+-------|
    |  Origin | Dest  |
    |---------+-------|
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |  SFO    | PHX   |
    |---------+-------|



```python
# compound logic
!mlr --csv --rs lf filter '$Origin == "SFO" && $Dest == "DFW"' flights.csv \
|csvcut -c UniqueCarrier,FlightNum,Origin,Dest | head | csvlook
```

    |----------------+-----------+--------+-------|
    |  UniqueCarrier | FlightNum | Origin | Dest  |
    |----------------+-----------+--------+-------|
    |  UA            | 136       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |  UA            | 336       | SFO    | DFW   |
    |----------------+-----------+--------+-------|


---

### `mlr put`

- derive new columns on the fly from existing ones
- Adds/updates specified field(s). Expressions are semicolon-separated and must either be assignments, or evaluate to boolean.
- Please use a dollar sign for field names and double-quotes for string literals.
- Miller built-in variables are NF NR FNR FILENUM FILENAME PI E, and ENV


```
Examples:
  mlr put '$y = log10($x); $z = sqrt($y)'
  mlr put '$x>0.0 { $y=log10($x); $z=sqrt($y) }' # does {...} only if $x > 0.0
  mlr put '$x>0.0;  $y=log10($x); $z=sqrt($y)'   # does all three statements
  mlr put '$a =~ "([a-z]+)_([0-9]+);  $b = "left_\1"; $c = "right_\2"'
  mlr put '$a =~ "([a-z]+)_([0-9]+) { $b = "left_\1"; $c = "right_\2" }'
  mlr put '$filename = FILENAME'
  mlr put '$colored_shape = $color . "_" . $shape'
  mlr put '$y = cos($theta); $z = atan2($y, $x)'
  mlr put '$name = sub($name, "http.*com"i, "")'
  mlr put -q '@sum += $x; end {emit @sum}'
  mlr put -q '@sum[$a] += $x; end {emit @sum, "a"}'
  mlr put -q '@sum[$a][$b] += $x; end {emit @sum, "a", "b"}'
  mlr put -q '@min=min(@min,$x);@max=max(@max,$x); end{emitf @min, @max}'
  mlr put -q 'is_null(@xmax) || $x > @xmax {@xmax=$x; @recmax=$*}; end {emit @recmax}'
```


---


```python
!csvcut -c Origin,Dest,Distance flights.csv | head \
| mlr --csv --rs lf put '$Distance_2 = $Distance/100;' \
| csvlook
```

    |---------+------+----------+-------------|
    |  Origin | Dest | Distance | Distance_2  |
    |---------+------+----------+-------------|
    |  SMF    | ONT  | 389      | 3.890000    |
    |  SMF    | PDX  | 479      | 4.790000    |
    |  SMF    | PDX  | 479      | 4.790000    |
    |  SMF    | PDX  | 479      | 4.790000    |
    |  SMF    | PDX  | 479      | 4.790000    |
    |  SMF    | PDX  | 479      | 4.790000    |
    |  SMF    | PHX  | 647      | 6.470000    |
    |  SMF    | PHX  | 647      | 6.470000    |
    |  SMF    | PHX  | 647      | 6.470000    |
    |---------+------+----------+-------------|



```python
!cat ./raw/het-bool.csv
```

    name,reachable
    barney,false
    betty,true
    fred,true
    wilma,1



```python
!mlr --icsv --rs lf --opprint put '$reachable = boolean($reachable)' ./raw/het-bool.csv
```

    name   reachable
    barney false
    betty  true
    fred   true
    wilma  true



```python
!mlr --icsv --rs lf --opprint put '$reachable = float(boolean($reachable))' ./raw/het-bool.csv
```

    name   reachable
    barney 0.000000
    betty  1.000000
    fred   1.000000
    wilma  1.000000



```python
# Creating an index field
!mlr --icsv --rs lf --opprint put '$index = NR' ./raw/het-bool.csv
```

    name   reachable index
    barney false     1
    betty  true      2
    fred   true      3
    wilma  1         4



```python

```


```python

```

---

### Functions to use with `put, filter`


```python
!mlr -F | tr '\n' '\t' 
```

    +	+	-	-	*	/	//	%	**	|	^	&	~	<<	>>	==	!=	=~	!=~	>	>=	<	<=	&&	||	^^	!	? :	.	gsub	strlen	sub	substr	tolower	toupper	abs	acos	acosh	asin	asinh	atan	atan2	atanh	cbrt	ceil	cos	cosh	erf	erfc	exp	expm1	floor	invqnorm	log	log10	log1p	logifit	madd	max	mexp	min	mmul	msub	pow	qnorm	round	roundm	sgn	sin	sinh	sqrt	tan	tanh	urand	urand32	urandint	dhms2fsec	dhms2sec	fsec2dhms	fsec2hms	gmt2sec	hms2fsec	hms2sec	sec2dhms	sec2gmt	sec2gmt	sec2gmtdate	sec2hms	strftime	strptime	systime	is_absent	is_bool	is_boolean	is_empty	is_empty_map	is_float	is_int	is_map	is_nonempty_map	is_not_empty	is_not_map	is_not_null	is_null	is_numeric	is_present	is_string	asserting_absent	asserting_bool	asserting_boolean	asserting_empty	asserting_empty_map	asserting_float	asserting_int	asserting_map	asserting_nonempty_map	asserting_not_empty	asserting_not_map	asserting_not_null	asserting_null	asserting_numeric	asserting_present	asserting_string	boolean	float	fmtnum	hexfmt	int	string	typeof	depth	haskey	joink	joinkv	joinv	leafcount	length	mapdiff	mapsum	splitkv	splitkvx	splitnv	splitnvx	


```python
!mlr -f 
```

    + (class=arithmetic #args=2): Addition.
    
    
    + (class=arithmetic #args=1): Unary plus.
    
    
    - (class=arithmetic #args=2): Subtraction.
    
    
    - (class=arithmetic #args=1): Unary minus.
    
    
    * (class=arithmetic #args=2): Multiplication.
    
    
    / (class=arithmetic #args=2): Division.
    
    
    // (class=arithmetic #args=2): Integer division: rounds to negative (pythonic).
    
    
    % (class=arithmetic #args=2): Remainder; never negative-valued (pythonic).
    
    
    ** (class=arithmetic #args=2): Exponentiation; same as pow, but as an infix
    operator.
    
    
    | (class=arithmetic #args=2): Bitwise OR.
    
    
    ^ (class=arithmetic #args=2): Bitwise XOR.
    
    
    & (class=arithmetic #args=2): Bitwise AND.
    
    
    ~ (class=arithmetic #args=1): Bitwise NOT. Beware '$y=~$x' since =~ is the
    regex-match operator: try '$y = ~$x'.
    
    
    << (class=arithmetic #args=2): Bitwise left-shift.
    
    
    >> (class=arithmetic #args=2): Bitwise right-shift.
    
    
    == (class=boolean #args=2): String/numeric equality. Mixing number and string
    results in string compare.
    
    
    != (class=boolean #args=2): String/numeric inequality. Mixing number and string
    results in string compare.
    
    
    =~ (class=boolean #args=2): String (left-hand side) matches regex (right-hand
    side), e.g. '$name =~ "^a.*b$"'.
    
    
    !=~ (class=boolean #args=2): String (left-hand side) does not match regex
    (right-hand side), e.g. '$name !=~ "^a.*b$"'.
    
    
    > (class=boolean #args=2): String/numeric greater-than. Mixing number and string
    results in string compare.
    
    
    >= (class=boolean #args=2): String/numeric greater-than-or-equals. Mixing number
    and string results in string compare.
    
    
    < (class=boolean #args=2): String/numeric less-than. Mixing number and string
    results in string compare.
    
    
    <= (class=boolean #args=2): String/numeric less-than-or-equals. Mixing number
    and string results in string compare.
    
    
    && (class=boolean #args=2): Logical AND.
    
    
    || (class=boolean #args=2): Logical OR.
    
    
    ^^ (class=boolean #args=2): Logical XOR.
    
    
    ! (class=boolean #args=1): Logical negation.
    
    
    ? : (class=boolean #args=3): Ternary operator.
    
    
    . (class=string #args=2): String concatenation.
    
    
    gsub (class=string #args=3): Example: '$name=gsub($name, "old", "new")'
    (replace all).
    
    
    strlen (class=string #args=1): String length.
    
    
    sub (class=string #args=3): Example: '$name=sub($name, "old", "new")'
    (replace once).
    
    
    substr (class=string #args=3): substr(s,m,n) gives substring of s from 0-up position m to n 
    inclusive. Negative indices -len .. -1 alias to 0 .. len-1.
    
    
    tolower (class=string #args=1): Convert string to lowercase.
    
    
    toupper (class=string #args=1): Convert string to uppercase.
    
    
    abs (class=math #args=1): Absolute value.
    
    
    acos (class=math #args=1): Inverse trigonometric cosine.
    
    
    acosh (class=math #args=1): Inverse hyperbolic cosine.
    
    
    asin (class=math #args=1): Inverse trigonometric sine.
    
    
    asinh (class=math #args=1): Inverse hyperbolic sine.
    
    
    atan (class=math #args=1): One-argument arctangent.
    
    
    atan2 (class=math #args=2): Two-argument arctangent.
    
    
    atanh (class=math #args=1): Inverse hyperbolic tangent.
    
    
    cbrt (class=math #args=1): Cube root.
    
    
    ceil (class=math #args=1): Ceiling: nearest integer at or above.
    
    
    cos (class=math #args=1): Trigonometric cosine.
    
    
    cosh (class=math #args=1): Hyperbolic cosine.
    
    
    erf (class=math #args=1): Error function.
    
    
    erfc (class=math #args=1): Complementary error function.
    
    
    exp (class=math #args=1): Exponential function e**x.
    
    
    expm1 (class=math #args=1): e**x - 1.
    
    
    floor (class=math #args=1): Floor: nearest integer at or below.
    
    
    invqnorm (class=math #args=1): Inverse of normal cumulative distribution
    function. Note that invqorm(urand()) is normally distributed.
    
    
    log (class=math #args=1): Natural (base-e) logarithm.
    
    
    log10 (class=math #args=1): Base-10 logarithm.
    
    
    log1p (class=math #args=1): log(1-x).
    
    
    logifit (class=math #args=3): Given m and b from logistic regression, compute
    fit: $yhat=logifit($x,$m,$b).
    
    
    madd (class=math #args=3): a + b mod m (integers)
    
    
    max (class=math variadic): max of n numbers; null loses
    
    
    mexp (class=math #args=3): a ** b mod m (integers)
    
    
    min (class=math variadic): Min of n numbers; null loses
    
    
    mmul (class=math #args=3): a * b mod m (integers)
    
    
    msub (class=math #args=3): a - b mod m (integers)
    
    
    pow (class=math #args=2): Exponentiation; same as **.
    
    
    qnorm (class=math #args=1): Normal cumulative distribution function.
    
    
    round (class=math #args=1): Round to nearest integer.
    
    
    roundm (class=math #args=2): Round to nearest multiple of m: roundm($x,$m) is
    the same as round($x/$m)*$m
    
    
    sgn (class=math #args=1): +1 for positive input, 0 for zero input, -1 for
    negative input.
    
    
    sin (class=math #args=1): Trigonometric sine.
    
    
    sinh (class=math #args=1): Hyperbolic sine.
    
    
    sqrt (class=math #args=1): Square root.
    
    
    tan (class=math #args=1): Trigonometric tangent.
    
    
    tanh (class=math #args=1): Hyperbolic tangent.
    
    
    urand (class=math #args=0): Floating-point numbers on the unit interval.
    Int-valued example: '$n=floor(20+urand()*11)'.
    
    
    urand32 (class=math #args=0): Integer uniformly distributed 0 and 2**32-1
    inclusive.
    
    
    urandint (class=math #args=2): Integer uniformly distributed between inclusive
    integer endpoints.
    
    
    dhms2fsec (class=time #args=1): Recovers floating-point seconds as in
    dhms2fsec("5d18h53m20.250000s") = 500000.250000
    
    
    dhms2sec (class=time #args=1): Recovers integer seconds as in
    dhms2sec("5d18h53m20s") = 500000
    
    
    fsec2dhms (class=time #args=1): Formats floating-point seconds as in
    fsec2dhms(500000.25) = "5d18h53m20.250000s"
    
    
    fsec2hms (class=time #args=1): Formats floating-point seconds as in
    fsec2hms(5000.25) = "01:23:20.250000"
    
    
    gmt2sec (class=time #args=1): Parses GMT timestamp as integer seconds since
    the epoch.
    
    
    hms2fsec (class=time #args=1): Recovers floating-point seconds as in
    hms2fsec("01:23:20.250000") = 5000.250000
    
    
    hms2sec (class=time #args=1): Recovers integer seconds as in
    hms2sec("01:23:20") = 5000
    
    
    sec2dhms (class=time #args=1): Formats integer seconds as in sec2dhms(500000)
    = "5d18h53m20s"
    
    
    sec2gmt (class=time #args=1): Formats seconds since epoch (integer part)
    as GMT timestamp, e.g. sec2gmt(1440768801.7) = "2015-08-28T13:33:21Z".
    Leaves non-numbers as-is.
    
    
    sec2gmt (class=time #args=2): Formats seconds since epoch as GMT timestamp with n
    decimal places for seconds, e.g. sec2gmt(1440768801.7,1) = "2015-08-28T13:33:21.7Z".
    Leaves non-numbers as-is.
    
    
    sec2gmtdate (class=time #args=1): Formats seconds since epoch (integer part)
    as GMT timestamp with year-month-date, e.g. sec2gmtdate(1440768801.7) = "2015-08-28".
    Leaves non-numbers as-is.
    
    
    sec2hms (class=time #args=1): Formats integer seconds as in
    sec2hms(5000) = "01:23:20"
    
    
    strftime (class=time #args=2): Formats seconds since the epoch as timestamp, e.g.
    strftime(1440768801.7,"%Y-%m-%dT%H:%M:%SZ") = "2015-08-28T13:33:21Z", and
    strftime(1440768801.7,"%Y-%m-%dT%H:%M:%3SZ") = "2015-08-28T13:33:21.700Z".
    Format strings are as in the C library (please see "man strftime" on your system),
    with the Miller-specific addition of "%1S" through "%9S" which format the seocnds
    with 1 through 9 decimal places, respectively. ("%S" uses no decimal places.)
    
    
    strptime (class=time #args=2): Parses timestamp as floating-point seconds since the epoch,
    e.g. strptime("2015-08-28T13:33:21Z","%Y-%m-%dT%H:%M:%SZ") = 1440768801.000000,
    and  strptime("2015-08-28T13:33:21.345Z","%Y-%m-%dT%H:%M:%SZ") = 1440768801.345000.
    
    
    systime (class=time #args=0): Floating-point seconds since the epoch,
    e.g. 1440768801.748936.
    
    
    is_absent (class=typing #args=1): False if field is present in input, false otherwise
    
    
    is_bool (class=typing #args=1): True if field is present with boolean value. Synonymous with is_boolean.
    
    
    is_boolean (class=typing #args=1): True if field is present with boolean value. Synonymous with is_bool.
    
    
    is_empty (class=typing #args=1): True if field is present in input with empty string value, false otherwise.
    
    
    is_empty_map (class=typing #args=1): True if argument is a map which is empty.
    
    
    is_float (class=typing #args=1): True if field is present with value inferred to be float
    
    
    is_int (class=typing #args=1): True if field is present with value inferred to be int 
    
    
    is_map (class=typing #args=1): True if argument is a map.
    
    
    is_nonempty_map (class=typing #args=1): True if argument is a map which is non-empty.
    
    
    is_not_empty (class=typing #args=1): False if field is present in input with empty value, false otherwise
    
    
    is_not_map (class=typing #args=1): True if argument is not a map.
    
    
    is_not_null (class=typing #args=1): False if argument is null (empty or absent), true otherwise.
    
    
    is_null (class=typing #args=1): True if argument is null (empty or absent), false otherwise.
    
    
    is_numeric (class=typing #args=1): True if field is present with value inferred to be int or float
    
    
    is_present (class=typing #args=1): True if field is present in input, false otherwise.
    
    
    is_string (class=typing #args=1): True if field is present with string (including empty-string) value
    
    
    asserting_absent (class=typing #args=1): Returns argument if it is absent in the input data, else
    throws an error.
    
    
    asserting_bool (class=typing #args=1): Returns argument if it is present with boolean value, else
    throws an error.
    
    
    asserting_boolean (class=typing #args=1): Returns argument if it is present with boolean value, else
    throws an error.
    
    
    asserting_empty (class=typing #args=1): Returns argument if it is present in input with empty value,
    else throws an error.
    
    
    asserting_empty_map (class=typing #args=1): Returns argument if it is a map with empty value, else
    throws an error.
    
    
    asserting_float (class=typing #args=1): Returns argument if it is present with float value, else
    throws an error.
    
    
    asserting_int (class=typing #args=1): Returns argument if it is present with int value, else
    throws an error.
    
    
    asserting_map (class=typing #args=1): Returns argument if it is a map, else throws an error.
    
    
    asserting_nonempty_map (class=typing #args=1): Returns argument if it is a non-empty map, else throws
    an error.
    
    
    asserting_not_empty (class=typing #args=1): Returns argument if it is present in input with non-empty
    value, else throws an error.
    
    
    asserting_not_map (class=typing #args=1): Returns argument if it is not a map, else throws an error.
    
    
    asserting_not_null (class=typing #args=1): Returns argument if it is non-null (non-empty and non-absent),
    else throws an error.
    
    
    asserting_null (class=typing #args=1): Returns argument if it is null (empty or absent), else throws
    an error.
    
    
    asserting_numeric (class=typing #args=1): Returns argument if it is present with int or float value,
    else throws an error.
    
    
    asserting_present (class=typing #args=1): Returns argument if it is present in input, else throws
    an error.
    
    
    asserting_string (class=typing #args=1): Returns argument if it is present with string (including
    empty-string) value, else throws an error.
    
    
    boolean (class=conversion #args=1): Convert int/float/bool/string to boolean.
    
    
    float (class=conversion #args=1): Convert int/float/bool/string to float.
    
    
    fmtnum (class=conversion #args=2): Convert int/float/bool to string using
    printf-style format string, e.g. '$s = fmtnum($n, "%06lld")'.
    
    
    hexfmt (class=conversion #args=1): Convert int to string, e.g. 255 to "0xff".
    
    
    int (class=conversion #args=1): Convert int/float/bool/string to int.
    
    
    string (class=conversion #args=1): Convert int/float/bool/string to string.
    
    
    typeof (class=conversion #args=1): Convert argument to type of argument (e.g.
    MT_STRING). For debug.
    
    
    depth (class=maps #args=1): Prints maximum depth of hashmap: ''. Scalars have depth 0.
    
    
    haskey (class=maps #args=2): True/false if map has/hasn't key, e.g. 'haskey($*, "a")' or
    'haskey(mymap, mykey)'. Error if 1st argument is not a map.
    
    
    joink (class=maps #args=2): Makes string from map keys. E.g. 'joink($*, ",")'.
    
    
    joinkv (class=maps #args=3): Makes string from map key-value pairs. E.g. 'joinkv(@v[2], "=", ",")'
    
    
    joinv (class=maps #args=2): Makes string from map keys. E.g. 'joinv(mymap, ",")'.
    
    
    leafcount (class=maps #args=1): Counts total number of terminal values in hashmap. For single-level maps,
    same as length.
    
    
    length (class=maps #args=1): Counts number of top-level entries in hashmap. Scalars have length 1.
    
    
    mapdiff (class=maps variadic): With 0 args, returns empty map. With 1 arg, returns copy of arg.
    With 2 or more, returns copy of arg 1 with all keys from any of remaining argument maps removed.
    
    
    mapsum (class=maps variadic): With 0 args, returns empty map. With >= 1 arg, returns a map with
    key-value pairs from all arguments. Rightmost collisions win, e.g. 'mapsum({1:2,3,4},{1:5})' is '{1:5,3:4}'.
    
    
    splitkv (class=maps #args=3): Splits string by separators into map with type inference.
    E.g. 'splitkv("a=1,b=2,c=3", "=", ",")' gives '{"a" : 1, "b" : 2, "c" : 3}'.
    
    
    splitkvx (class=maps #args=3): Splits string by separators into map without type inference (keys and
    values are strings). E.g. 'splitkv("a=1,b=2,c=3", "=", ",")' gives
    '{"a" : "1", "b" : "2", "c" : "3"}'.
    
    
    splitnv (class=maps #args=2): Splits string by separator into integer-indexed map with type inference.
    E.g. 'splitnv("a,b,c" , ",")' gives '{1 : "a", 2 : "b", 3 : "c"}'.
    
    
    splitnvx (class=maps #args=2): Splits string by separator into integer-indexed map without type
    inference (values are strings). E.g. 'splitnv("4,5,6" , ",")' gives '{1 : "4", 2 : "5", 3 : "6"}'.
    
    To set the seed for urand, you may specify decimal or hexadecimal 32-bit
    numbers of the form "mlr --seed 123456789" or "mlr --seed 0xcafefeed".
    Miller's built-in variables are NF, NR, FNR, FILENUM, and FILENAME (awk-like)
    along with the mathematical constants PI and E.



```python
!xsv headers ./cleaned/Sales.csv
```

    1   POSSales_PK
    2   Date_FK
    3   Date
    4   Store_FK
    5   Item_FK
    6   Item_PK
    7   Promo_FK
    8   POSSales_Ticket_No
    9   POSSales_GiftList_No
    10  POSSales_GiftListLine_No
    11  POSSales_Sales_Quantity
    12  POSSales_Sales_AmountExVAT
    13  POSSales_Sales_AmountInVAT
    14  POSSales_Cost_Amount
    15  POSSales_Margin_Amount
    16  POSSales_Discount_Amount
    17  Store_No_BK
    18  POS_Terminal_No_BK
    19  Transaction_No_BK
    20  Line_No_BK



```python
!mlr --csv head -n 10 \
then put '$POSSales_Sales_AmountExVAT2=float(gsub($POSSales_Sales_AmountExVAT,",","."))' \
then cut -r -f 'POSSales_Sales_AmountExVAT' ./cleaned/Sales.csv 
```

    POSSales_Sales_AmountExVAT,POSSales_Sales_AmountExVAT2
    "17,32231000000000000000",17.322310
    "43,38017000000000000000",43.380170
    "6,60331000000000000000",6.603310
    "24,78512000000000000000",24.785120
    "12,38843000000000000000",12.388430
    ",94340000000000000000",0.943400
    "2,22314000000000000000",2.223140
    "10,70248000000000000000",10.702480
    "3,29752000000000000000",3.297520
    "28,91736000000000000000",28.917360


---

### `sec2gmt, sec2gmtdate` for epoch timestamps

- Replaces a numeric field representing seconds since the epoch with the corresponding GMT timestamp

```
mlr sec2gmt time1,time2
# is the same as
mlr put '$time1=sec2gmt($time1);$time2=sec2gmt($time2)'
```


- Alternatively, use the following functions with `put`

```
strftime: Formats seconds since epoch (integer part) as timestamp, e.g.
    strftime(1440768801.7,"%Y-%m-%dT%H:%M:%SZ") = "2015-08-28T13:33:21Z".


strptime: Parses timestamp as integer seconds since epoch, e.g. 
    strptime("2015-08-28T13:33:21Z","%Y-%m-%dT%H:%M:%SZ") = 1440768801.
```


```python
!mlr --csv head -n 10 then cut -f 'Date' ./cleaned/Sales.csv
```

    Date
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00
    2014-01-02 00:00:00



```python
!mlr --csv head -n 10 \
then cut -f 'Date' \
then put '$epoch=strptime($Date, "%Y-%m-%d %H:%M:%S")' ./cleaned/Sales.csv \
| csvlook
```

    |----------------------+-------------|
    |  Date                | epoch       |
    |----------------------+-------------|
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |  2014-01-02 00:00:00 | 1388620800  |
    |----------------------+-------------|


---

### `mlr label`

- use `--implicit-csv-header` with `mlr cat` to auto-create numeric column names
- create column labels for files using `mlr <options> label <colnames>`


```python
!csvcut -c Origin,Dest,FlightNum flights.csv | head | sed 1d \
| mlr --csv --rs lf label col1,col2,col3
```

    col1,col2,col3
    SMF,PDX,462
    SMF,PDX,1229
    SMF,PDX,1355
    SMF,PDX,2278
    SMF,PDX,2386
    SMF,PHX,409
    SMF,PHX,1131
    SMF,PHX,1212


---

## `mlr rename`

- Renames specified fields.
- Usage: mlr rename [options] {old1,new1,old2,new2,...}
    - use `-g` for global replacement, and `-r` for regex matching
    
    
```
Examples:
mlr rename old_name,new_name
mlr rename old_name_1,new_name_1,old_name_2,new_name_2
mlr rename -r 'Date_[0-9]+,Date,'  Rename all such fields to be "Date"
mlr rename -r '"Date_[0-9]+",Date' Same
mlr rename -r 'Date_([0-9]+).*,\1' Rename all such fields to be of the form 20151015
mlr rename -r '"name"i,Name'       Rename "name", "Name", "NAME", etc. to "Name"
```


```python
# replace spaces with underscores
!mlr --csv --ifs '|' --ofs ',' rename -g -r ' ,_' ./raw/Sales.txt > ./cleaned/Sales.csv
```


```python
!csvcut -n ./cleaned/Sales.csv
# or !xsv headers ./cleaned/Sales.csv
```

      1: POSSales_PK
      2: Date_FK
      3: Date
      4: Store_FK
      5: Item_FK
      6: Item_PK
      7: Promo_FK
      8: POSSales_Ticket_No
      9: POSSales_GiftList_No
     10: POSSales_GiftListLine_No
     11: POSSales_Sales_Quantity
     12: POSSales_Sales_AmountExVAT
     13: POSSales_Sales_AmountInVAT
     14: POSSales_Cost_Amount
     15: POSSales_Margin_Amount
     16: POSSales_Discount_Amount
     17: Store_No_BK
     18: POS_Terminal_No_BK
     19: Transaction_No_BK
     20: Line_No_BK


---

### Random Sampling with `bootstrap, sample, shuffle`

- `bootstrap` is for sampling with replacement
- The canonical use for bootstrap sampling is to put **error bars** (or, `confints`) on statistical quantities, such as the mean.


```python
!mlr --csv --rs lf bootstrap -n 100 then stats1 -a mean -f WeatherDelay -g UniqueCarrier flights.csv
```

    UniqueCarrier,WeatherDelay_mean
    NW,0.000000
    OH,2.000000
    DL,0.000000
    9E,0.000000
    AA,0.000000
    WN,0.000000
    UA,0.000000
    FL,0.000000
    OO,0.000000
    EV,46.833333
    US,0.000000
    YV,0.000000
    MQ,0.000000
    XE,0.000000
    AS,0.000000
    CO,0.000000
    AQ,0.000000
    HA,0.000000
    B6,0.000000


---

- `sample` is for sampling `-k` records without replacement
- Stratified if groups are specified with a `-g` switch


```python
!mlr --csv --rs lf sample -k 4 flights.csv
```

    Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2007,4,20,5,3,2353,221,209,US,19,N601AW,138,136,116,12,10,LAS,PDX,762,3,19,0,,0,0,0,0,0,0
    2007,3,21,3,902,900,1242,1153,YV,7176,N37342,160,113,93,49,2,ORD,CAE,666,4,63,0,,0,49,0,0,0,0
    2007,8,3,5,2115,2028,2248,2218,FL,59,N932AT,93,110,72,30,47,IAD,ATL,533,9,12,0,,0,0,0,0,0,30
    2007,10,12,5,810,820,947,1005,AA,1895,N5FHAA,157,165,139,-18,-10,MCO,DFW,984,6,12,0,,0,0,0,0,0,0


---

### `mlr count-distinct`


```python
!mlr --csv --rs lf count-distinct -f Origin,Dest then sort -nr count then head -n 10 flights.csv | csvlook
```

    |---------+------+--------|
    |  Origin | Dest | count  |
    |---------+------+--------|
    |  OGG    | HNL  | 16099  |
    |  HNL    | OGG  | 15876  |
    |  LAX    | LAS  | 14385  |
    |  LAS    | LAX  | 13815  |
    |  HNL    | LIH  | 13156  |
    |  LIH    | HNL  | 13030  |
    |  SAN    | LAX  | 12779  |
    |  LAX    | SAN  | 12767  |
    |  BOS    | LGA  | 12263  |
    |  LAS    | PHX  | 12228  |
    |---------+------+--------|



```python
!cat flights.csv | cut -d, -f17 | sed 1d | sort | uniq | wc -l
```

    304


---

## `mlr merge-fields`

- like mlr stats1 but all accumulation is done across fields within each given record: horizontal rather than vertical statistics


```python
!mlr --csv --rs lf head -n 10 then cut -r -f "Time" flights.csv | csvlook
```

    |----------+------------+---------+------------+-------------------+----------------+----------|
    |  DepTime | CRSDepTime | ArrTime | CRSArrTime | ActualElapsedTime | CRSElapsedTime | AirTime  |
    |----------+------------+---------+------------+-------------------+----------------+----------|
    |  1232    | 1225       | 1341    | 1340       | 69                | 75             | 54       |
    |  1918    | 1905       | 2043    | 2035       | 85                | 90             | 74       |
    |  2206    | 2130       | 2334    | 2300       | 88                | 90             | 73       |
    |  1230    | 1200       | 1356    | 1330       | 86                | 90             | 75       |
    |  831     | 830        | 957     | 1000       | 86                | 90             | 74       |
    |  1430    | 1420       | 1553    | 1550       | 83                | 90             | 74       |
    |  1936    | 1840       | 2217    | 2130       | 101               | 110            | 89       |
    |  944     | 935        | 1223    | 1225       | 99                | 110            | 86       |
    |  1537    | 1450       | 1819    | 1735       | 102               | 105            | 90       |
    |  1318    | 1315       | 1603    | 1610       | 105               | 115            | 92       |
    |----------+------------+---------+------------+-------------------+----------------+----------|



```python
!mlr --csv --rs lf head -n 10 then \
cut -r -f "Time" then \
merge-fields -a sum -r 'Time' -k -o time \
flights.csv | csvlook
```

    |----------+------------+---------+------------+-------------------+----------------+---------+-----------|
    |  DepTime | CRSDepTime | ArrTime | CRSArrTime | ActualElapsedTime | CRSElapsedTime | AirTime | time_sum  |
    |----------+------------+---------+------------+-------------------+----------------+---------+-----------|
    |  1232    | 1225       | 1341    | 1340       | 69                | 75             | 54      | 5336      |
    |  1918    | 1905       | 2043    | 2035       | 85                | 90             | 74      | 8150      |
    |  2206    | 2130       | 2334    | 2300       | 88                | 90             | 73      | 9221      |
    |  1230    | 1200       | 1356    | 1330       | 86                | 90             | 75      | 5367      |
    |  831     | 830        | 957     | 1000       | 86                | 90             | 74      | 3868      |
    |  1430    | 1420       | 1553    | 1550       | 83                | 90             | 74      | 6200      |
    |  1936    | 1840       | 2217    | 2130       | 101               | 110            | 89      | 8423      |
    |  944     | 935        | 1223    | 1225       | 99                | 110            | 86      | 4622      |
    |  1537    | 1450       | 1819    | 1735       | 102               | 105            | 90      | 6838      |
    |  1318    | 1315       | 1603    | 1610       | 105               | 115            | 92      | 6158      |
    |----------+------------+---------+------------+-------------------+----------------+---------+-----------|


---

## `stats1`

- Computes univariate statistics for one or more given fields, accumulated across the input record stream.
- switch `-f {a,b,c}`  Value-field names on which to compute statistics
- switch `-g {d,e,f}`  Optional group-by-field names
- switch `-a {g,h,i}` with the listed stats


```
  count     Count instances of fields
  mode      Find most-frequently-occurring values for fields; first-found wins tie
  antimode  Find least-frequently-occurring values for fields; first-found wins tie
  sum       Compute sums of specified fields
  mean      Compute averages (sample means) of specified fields
  stddev    Compute sample standard deviation of specified fields
  var       Compute sample variance of specified fields
  meaneb    Estimate error bars for averages (assuming no sample autocorrelation)
  skewness  Compute sample skewness of specified fields
  kurtosis  Compute sample kurtosis of specified fields
  min       Compute minimum values of specified fields
  max       Compute maximum values of specified fields
  
Examples -

mlr stats1 -a min,p10,p50,p90,max -f value -g size,shape
mlr stats1 -a count,mode -f size
mlr stats1 -a count,mode -f size -g shape
  
```




```python
!mlr --csv --rs lf filter '$ArrDelay!="NA"' \
then stats1 -a mean,stddev -f ArrDelay -g Origin \
then sort -nr ArrDelay_mean \
then head -n 10 \
flights.csv | csvlook
```

    |---------+---------------+------------------|
    |  Origin | ArrDelay_mean | ArrDelay_stddev  |
    |---------+---------------+------------------|
    |  ACK    | 46.115523     | 82.715645        |
    |  SOP    | 40.464865     | 61.941857        |
    |  PIR    | 35.750000     | 33.260337        |
    |  MKC    | 25.000000     |                  |
    |  CEC    | 24.763527     | 47.427527        |
    |  MCN    | 24.087607     | 79.076628        |
    |  SPI    | 21.591925     | 62.123661        |
    |  EWN    | 21.486532     | 53.500822        |
    |  HHH    | 20.648305     | 61.881898        |
    |  MEI    | 20.529141     | 52.402560        |
    |---------+---------------+------------------|



```python
!mlr --csv --rs lf filter '$ArrDelay!="NA"' \
then stats1 -a min,p05,p10,p90,p95,max -f ArrDelay -g Origin \
then sort -f Origin \
then head -n 10 \
flights.csv | csvlook
```

    |---------+--------------+--------------+--------------+--------------+--------------+---------------|
    |  Origin | ArrDelay_min | ArrDelay_p05 | ArrDelay_p10 | ArrDelay_p90 | ArrDelay_p95 | ArrDelay_max  |
    |---------+--------------+--------------+--------------+--------------+--------------+---------------|
    |  ABE    | -44          | -22          | -18          | 39           | 83           | 690           |
    |  ABI    | -32          | -14          | -12          | 39           | 78           | 695           |
    |  ABQ    | -61          | -19          | -15          | 29           | 54           | 1049          |
    |  ABY    | -27          | -15          | -12          | 45           | 79           | 336           |
    |  ACK    | -51          | -37          | -31          | 163          | 234          | 386           |
    |  ACT    | -32          | -17          | -14          | 33           | 67           | 366           |
    |  ACV    | -30          | -17          | -14          | 62           | 96           | 498           |
    |  ACY    | -55          | -30          | -24          | 60           | 110          | 741           |
    |  ADK    | -83          | -73          | -65          | 56           | 78           | 160           |
    |  ADQ    | -31          | -19          | -16          | 41           | 66           | 275           |
    |---------+--------------+--------------+--------------+--------------+--------------+---------------|


---

## `stats2`

- for bivariate statistics

```
-a {linreg-ols,corr,...}  Names of accumulators: one or more of:
  linreg-pca   Linear regression using principal component analysis
  linreg-ols   Linear regression using ordinary least squares
  r2           Quality metric for linreg-ols (linreg-pca emits its own)
  logireg      Logistic regression
  corr         Sample correlation
  cov          Sample covariance
  covx         Sample-covariance matrix
-f {a,b,c,d}   Value-field name-pairs on which to compute statistics.
               There must be an even number of names.
-g {e,f,g}     Optional group-by-field names.
-v             Print additional output for linreg-pca.
-s             Print iterative stats. Useful in tail -f contexts (in which
               case please avoid pprint-format output since end of input
               stream will never be seen).
--fit          Rather than printing regression parameters, applies them to
               the input data to compute new fit fields. All input records are
               held in memory until end of input stream. Has effect only for
               linreg-ols, linreg-pca, and logireg.
Only one of -s or --fit may be used.

Examples
mlr stats2 -a linreg-pca -f x,y
mlr stats2 -a linreg-ols,r2 -f x,y -g size,shape
mlr stats2 -a corr -f x,y

```



```python
!mlr --csv --rs lf filter '$ArrDelay!="NA"' \
then stats2 -a corr -f ArrDelay,AirTime 
```

---

## `steps`

- Computes values dependent on the previous record, optionally grouped by category.
- useful for calculating `lagged` variables

> Most Miller commands are **record-at-a-time**, with the exception of `stats1, stats2`, and `histogram` which compute aggregate output. 

> The `step` command is intermediate: it allows the option of adding fields which are functions of fields from previous records. Rsum is short for running sum.




```
Options:
-a {delta,rsum,...}   Names of steppers: comma-separated, one or more of:
  delta    Compute differences in field(s) between successive records
  shift    Include value(s) in field(s) from previous record, if any
  from-first Compute differences in field(s) from first record
  ratio    Compute ratios in field(s) between successive records
  rsum     Compute running sums of field(s) between successive records
  counter  Count instances of field(s) between successive records
  ewma     Exponentially weighted moving average over successive records
-f {a,b,c} Value-field names on which to compute statistics
-g {d,e,f} Optional group-by-field names
-F         Computes integerable things (e.g. counter) in floating point.
-d {x,y,z} Weights for ewma. 1 means current sample gets all weight (no
           smoothing), near under under 1 is light smoothing, near over 0 is
           heavy smoothing. Multiple weights may be specified, e.g.
           "mlr step -a ewma -f sys_load -d 0.01,0.1,0.9". Default if omitted
           is "-d 0.5".
-o {a,b,c} Custom suffixes for EWMA output fields. If omitted, these default to
           the -d values. If supplied, the number of -o values must be the same
           as the number of -d values.

Examples:
  mlr step -a rsum -f request_size
  mlr step -a delta -f request_size -g hostname
  mlr step -a ewma -d 0.1,0.9 -f x,y
  mlr step -a ewma -d 0.1,0.9 -o smooth,rough -f x,y
  mlr step -a ewma -d 0.1,0.9 -o smooth,rough -f x,y -g group_name
```

---

## Also see

- `uniq` for uniques and frequency tables
- `top` for nlargest
- some [examples](http://johnkerl.org/miller/doc/data-examples.html)
- [DSL for `put`, `filter`](http://johnkerl.org/miller/doc/reference-dsl.html)
