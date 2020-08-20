# **`xsv`** 

- *A fast CSV toolkit written in Rust.* [repo](https://github.com/BurntSushi/xsv)

## Commands

    cat         Concatenate by row or column
    count       Count records
    fixlengths  Makes all records have same length
    flatten     Show one field per line
    fmt         Format CSV output (change field delimiter)
    frequency   Show frequency tables
    headers     Show header names
    help        Show this usage message.
    index       Create CSV index for faster access
    input       Read CSV data with special quoting rules
    join        Join CSV files
    sample      Randomly sample CSV data
    search      Search CSV data with regexes
    select      Select columns from CSV
    slice       Slice records from CSV
    sort        Sort CSV data
    split       Split CSV data into many files
    stats       Compute basic statistics
    table       Align CSV data into columns



## Install

```bash
# run
wget https://goo.gl/iZMmzX
# or download the tar file from 'https://github.com/BurntSushi/xsv/releases/latest'

# untar
tar -xzvf xsv-0.11.0-x86_64-unknown-linux-musl.tar.gz

# move the executable to the binaries folder
mv xsv /usr/bin/xsv

# run from anywhere
```


```python
### 0. View formatted
!head -n 10 flights.csv | cut -d, -f1-10 | xsv table
```

    Year  Month  DayofMonth  DayOfWeek  DepTime  CRSDepTime  ArrTime  CRSArrTime  UniqueCarrier  FlightNum
    2007  1      1           1          1232     1225        1341     1340        WN             2891
    2007  1      1           1          1918     1905        2043     2035        WN             462
    2007  1      1           1          2206     2130        2334     2300        WN             1229
    2007  1      1           1          1230     1200        1356     1330        WN             1355
    2007  1      1           1          831      830         957      1000        WN             2278
    2007  1      1           1          1430     1420        1553     1550        WN             2386
    2007  1      1           1          1936     1840        2217     2130        WN             409
    2007  1      1           1          944      935         1223     1225        WN             1131
    2007  1      1           1          1537     1450        1819     1735        WN             1212



```python
### 1. Count Rows (MUCH faster than `wc -l`, uses more CPU, excludes header)
!xsv count flights.csv
```

    7453215



```python
### 2. Get Column names
cols = !xsv headers flights.csv
[x.split(' ')[-1] for x in cols]
```




    ['Year',
     'Month',
     'DayofMonth',
     'DayOfWeek',
     'DepTime',
     'CRSDepTime',
     'ArrTime',
     'CRSArrTime',
     'UniqueCarrier',
     'FlightNum',
     'TailNum',
     'ActualElapsedTime',
     'CRSElapsedTime',
     'AirTime',
     'ArrDelay',
     'DepDelay',
     'Origin',
     'Dest',
     'Distance',
     'TaxiIn',
     'TaxiOut',
     'Cancelled',
     'CancellationCode',
     'Diverted',
     'CarrierDelay',
     'WeatherDelay',
     'NASDelay',
     'SecurityDelay',
     'LateAircraftDelay']




```python
### 5. Subset Columns
!xsv select Month,DayofMonth,UniqueCarrier,FlightNum,Origin,Dest flights.csv | head | csvlook
```

    |--------+------------+---------------+-----------+--------+-------|
    |  Month | DayofMonth | UniqueCarrier | FlightNum | Origin | Dest  |
    |--------+------------+---------------+-----------+--------+-------|
    |  1     | 1          | WN            | 2891      | SMF    | ONT   |
    |  1     | 1          | WN            | 462       | SMF    | PDX   |
    |  1     | 1          | WN            | 1229      | SMF    | PDX   |
    |  1     | 1          | WN            | 1355      | SMF    | PDX   |
    |  1     | 1          | WN            | 2278      | SMF    | PDX   |
    |  1     | 1          | WN            | 2386      | SMF    | PDX   |
    |  1     | 1          | WN            | 409       | SMF    | PHX   |
    |  1     | 1          | WN            | 1131      | SMF    | PHX   |
    |  1     | 1          | WN            | 1212      | SMF    | PHX   |
    |--------+------------+---------------+-----------+--------+-------|



```python
### 3. Create an index
!xsv index flights.csv
!ls *.idx
```

    flights.csv.idx



```python
### 4. Get Summary Stats (MUCH faster than `csvstat`)
!xsv stats flights.csv --everything | \
xsv select field,type,min,median,max,mean,stddev,mode | \
csvlook
```

    |--------------------+---------+-------+--------+--------+-----------------------+---------------------+-------|
    |  field             | type    | min   | median | max    | mean                  | stddev              | mode  |
    |--------------------+---------+-------+--------+--------+-----------------------+---------------------+-------|
    |  Year              | Integer | 2007  | 2007   | 2007   | 2007                  | 0                   | 2007  |
    |  Month             | Integer | 1     | 7      | 12     | 6.514876197721434     | 3.425117169491096   | 8     |
    |  DayofMonth        | Integer | 1     | 16     | 31     | 15.72588876075652     | 8.781153183533013   | 26    |
    |  DayOfWeek         | Integer | 1     | 4      | 7      | 3.9338042710427263    | 1.9922668348832397  | 1     |
    |  DepTime           | Unicode | 1     | 1255   | NA     |                       |                     | NA    |
    |  CRSDepTime        | Integer | 0     | 1322   | 2359   | 1330.5963490923104    | 464.70792314976785  | 600   |
    |  ArrTime           | Unicode | 1     | 1430   | NA     |                       |                     | NA    |
    |  CRSArrTime        | Integer | 0     | 1520   | 2400   | 1495.391906714091     | 481.59020392608437  | 1930  |
    |  UniqueCarrier     | Unicode | 9E    |        | YV     |                       |                     | WN    |
    |  FlightNum         | Integer | 1     | 1509   | 9602   | 2188.0992893670827    | 1971.9575313097869  | 16    |
    |  TailNum           | Unicode | 0     |        | NHZOAL |                       |                     | 0     |
    |  ActualElapsedTime | Unicode | 100   | 115    | NA     |                       |                     | NA    |
    |  CRSElapsedTime    | Unicode | -1240 | 100    | NA     |                       |                     | 75    |
    |  AirTime           | Unicode | 0     | 94     | NA     |                       |                     | NA    |
    |  ArrDelay          | Unicode | -1    | -2     | NA     |                       |                     | -5    |
    |  DepDelay          | Unicode | -1    | 1      | NA     |                       |                     | 0     |
    |  Origin            | Unicode | ABE   |        | YUM    |                       |                     | ATL   |
    |  Dest              | Unicode | ABE   |        | YUM    |                       |                     | ATL   |
    |  Distance          | Integer | 11    | 569    | 4962   | 719.805789045388      | 562.3050870976227   | 337   |
    |  TaxiIn            | Integer | 0     | 5      | 545    | 6.6919844657641026    | 5.151350775045749   | 4     |
    |  TaxiOut           | Integer | 0     | 14     | 530    | 16.300146178528344    | 11.833958552477231  | 10    |
    |  Cancelled         | Integer | 0     | 0      | 1      | 0.021567605389083436  | 0.14526680208108242 | 0     |
    |  CancellationCode  | Unicode | A     |        | D      |                       |                     |       |
    |  Diverted          | Integer | 0     | 0      | 1      | 0.0023049113704622683 | 0.04795413177231553 | 0     |
    |  CarrierDelay      | Integer | 0     | 0      | 2580   | 3.865235874719842     | 20.842403385965035  | 0     |
    |  WeatherDelay      | Integer | 0     | 0      | 1429   | 0.7700903569801583    | 9.619546393361475   | 0     |
    |  NASDelay          | Integer | 0     | 0      | 1386   | 3.783702200996463     | 16.176702958825693  | 0     |
    |  SecurityDelay     | Integer | 0     | 0      | 382    | 0.023735528895919497  | 1.084995425472959   | 0     |
    |  LateAircraftDelay | Integer | 0     | 0      | 1031   | 5.099133997878817     | 21.277529347496895  | 0     |
    |--------------------+---------+-------+--------+--------+-----------------------+---------------------+-------|



```python

```

---

### Random Sampling

- Randomly samples CSV data uniformly using memory proportional to the size of the sample.
- **When an index is present**, this command will use random indexing if the sample size is less than 10% of the total number of records. 
    - This allows for efficient sampling such that the entire CSV file is not parsed.
- Allows a user to work with **a CSV data set that is too big to fit into memory** (for example, for use with commands like `xsv frequency` or `xsv stats`). 

Usage:

    xsv sample [options] <sample-size> [<input>]
    xsv sample --help




```python
!xsv select Month,DayofMonth,UniqueCarrier,FlightNum,Origin,Dest flights.csv | xsv sample 10 | csvlook
```

    |--------+------------+---------------+-----------+--------+-------|
    |  Month | DayofMonth | UniqueCarrier | FlightNum | Origin | Dest  |
    |--------+------------+---------------+-----------+--------+-------|
    |  1     | 21         | OH            | 5315      | CVG    | PIT   |
    |  5     | 17         | WN            | 629       | LAS    | SMF   |
    |  3     | 27         | WN            | 962       | LAX    | TUS   |
    |  8     | 15         | FL            | 44        | SFO    | ATL   |
    |  11    | 4          | AQ            | 45        | ITO    | HNL   |
    |  1     | 31         | WN            | 57        | DAL    | HOU   |
    |  9     | 4          | OO            | 3790      | MSP    | ATL   |
    |  9     | 18         | AA            | 1411      | BOS    | ORD   |
    |  2     | 18         | OO            | 5766      | PDX    | RDM   |
    |  1     | 18         | OO            | 3873      | SLC    | MFR   |
    |--------+------------+---------------+-----------+--------+-------|


---

### Frequency Tables

- Computes a frequency table on CSV data formatted as `field,value,count` 
- The order and number of values can be tweaked with `--asc` and `--limit` respectively.
- memory proportional to the cardinality of each column is required.

Usage:

    xsv frequency [options] [<input>]

Options:

    -s, --select <arg>     Select a subset of columns to compute frequencies
    -l, --limit <arg>      Limit the frequency table to the N most common items. [default: 10]
    -a, --asc              Sort the frequency tables in ascending order by count. [default: descending]
    --no-nulls             Don't include NULLs in the frequency table.


```python
# For all columns
!xsv frequency flights.csv --limit 5 | head -n 15 | csvlook
```

    |-------------+-------+----------|
    |  field      | value | count    |
    |-------------+-------+----------|
    |  Year       | 2007  | 7453215  |
    |  Month      | 8     | 653279   |
    |  Month      | 7     | 648560   |
    |  Month      | 3     | 639209   |
    |  Month      | 5     | 631609   |
    |  Month      | 10    | 629992   |
    |  DayofMonth | 26    | 250136   |
    |  DayofMonth | 19    | 250092   |
    |  DayofMonth | 12    | 249773   |
    |  DayofMonth | 16    | 249034   |
    |  DayofMonth | 9     | 248415   |
    |  DayOfWeek  | 1     | 1112474  |
    |  DayOfWeek  | 5     | 1101689  |
    |  DayOfWeek  | 4     | 1097738  |
    |-------------+-------+----------|



```python
# For particular column(s)
!xsv frequency --select Origin --limit 5 flights.csv | csvlook
```

    |---------+-------+---------|
    |  field  | value | count   |
    |---------+-------+---------|
    |  Origin | ATL   | 413851  |
    |  Origin | ORD   | 375784  |
    |  Origin | DFW   | 297345  |
    |  Origin | DEN   | 240928  |
    |  Origin | LAX   | 237597  |
    |---------+-------+---------|


---

### Filter rows

Filters CSV data by whether the given regex matches a row.

The regex is applied to each field in each row, and if any field matches,
then the row is written to the output. The columns to search can be limited
with the '--select' flag (but the full row is still written to the output if
there is a match).

Usage:

    xsv search [options] <regex> [<input>]
    xsv search --help

search options:

    -i, --ignore-case      Case insensitive search. This is equivalent to
                           prefixing the regex with '(?i)'.
    -s, --select <arg>     Select the columns to search. See 'xsv select -h'
                           for the full syntax.
    -v, --invert-match     Select only rows that did not match



```python
!xsv search -s Origin 'ATL' flights.csv \
| xsv select Month,DayofMonth,UniqueCarrier,FlightNum,Origin,Dest \
| xsv sample 10 \
| csvlook
```

    |--------+------------+---------------+-----------+--------+-------|
    |  Month | DayofMonth | UniqueCarrier | FlightNum | Origin | Dest  |
    |--------+------------+---------------+-----------+--------+-------|
    |  6     | 26         | AA            | 1756      | ATL    | LGA   |
    |  8     | 1          | DL            | 522       | ATL    | LGA   |
    |  2     | 8          | DL            | 1253      | ATL    | DEN   |
    |  2     | 17         | DL            | 688       | ATL    | DCA   |
    |  8     | 22         | EV            | 4417      | ATL    | SDF   |
    |  2     | 15         | EV            | 4544      | ATL    | VLD   |
    |  2     | 10         | FL            | 163       | ATL    | TPA   |
    |  9     | 8          | DL            | 829       | ATL    | JAC   |
    |  9     | 27         | DL            | 1512      | ATL    | DTW   |
    |  11    | 20         | AA            | 1197      | ATL    | DFW   |
    |--------+------------+---------------+-----------+--------+-------|


---

### Joins

- Joins two sets of CSV data on the specified columns.
- The default join operation is an 'inner' join. 
- Joins are always done by ignoring leading and trailing whitespace. 
- By default, joins are done case sensitively, but this can be disabled with the `--no-case` flag.
- The `columns` arguments specify the columns to join for each input. 
    - Columns can be referenced by name or index, starting at 1. 
    - Specify multiple columns by separating them with a comma. 
    - Specify a range of columns with `-`. 
    - Both columns1 and columns2 must specify exactly the same number of columns.

Usage:

    xsv join [options] <columns1> <input1> <columns2> <input2>
    xsv join --help

join options:

    --no-case              When set, joins are done case insensitively.
    --left                 Do a 'left outer' join. 
    --right                Do a 'right outer' join.
    --nulls                When set, joins will work on empty fields.
                           Otherwise, empty fields are completely ignored.
                           (In fact, any row that has an empty field in the
                           key specified is ignored.)
                           
Get data

    !wget http://burntsushi.net/stuff/worldcitiespop.csv
    !wget https://gist.githubusercontent.com/anonymous/063cb470e56e64e98cf1/raw/98e2589b801f6ca3ff900b01a87fbb7452eb35c7/countrynames.csv


```python
!xsv join --no-case  Country worldcitiespop.csv Abbrev countrynames.csv | xsv sample 10 | csvlook
```

    |----------+-------------------+-------------------+--------+------------+-----------+------------+--------+--------------|
    |  Country | City              | AccentCity        | Region | Population | Latitude  | Longitude  | Abbrev | Country      |
    |----------+-------------------+-------------------+--------+------------+-----------+------------+--------+--------------|
    |  kr      | upori             | Upori             | 12     |            | 37.239167 | 126.105833 | KR     | South Korea  |
    |  id      | kaninggiduku      | Kaninggiduku      | 18     |            | -9.6191   | 119.3201   | ID     | Indonesia    |
    |  ua      | ivanovsk          | Ivanovsk          | 04     |            | 48.533572 | 34.158659  | UA     | Ukraine      |
    |  nl      | riscado           | Riscado           | 00     |            | 12.233333 | -68.366667 | NL     | Netherlands  |
    |  gr      | plazumista        | Plazumísta        | 09     |            | 40.3      | 21.2666667 | GR     | Greece       |
    |  pl      | myslowka          | Myslowka          | 74     |            | 52.028306 | 19.415481  | PL     | Poland       |
    |  hu      | csem              | Csém              | 12     |            | 47.685903 | 18.098287  | HU     | Hungary      |
    |  cn      | tungshan          | Tungshan          | 05     |            | 41.648889 | 127.275833 | CN     | China        |
    |  ir      | gilavard-e bozorg | Gilavard-e Bozorg | 35     |            | 36.585273 | 53.588776  | IR     | Iran         |
    |  be      | toutefays         | Toutefays         | 08     |            | 50.983333 | 3.666667   | BE     | Belgium      |
    |----------+-------------------+-------------------+--------+------------+-----------+------------+--------+--------------|


We have two columns named `Country`. Use `select` to get rid of it.


```python
!xsv join --no-case  Country worldcitiespop.csv Abbrev countrynames.csv \
| xsv select 'Country[1],AccentCity,Population' | xsv search -s Population '[0-9]' | xsv sample 5 | csvlook
```

    |----------+-------------------+-------------|
    |  Country | AccentCity        | Population  |
    |----------+-------------------+-------------|
    |  Mexico  | Cosoleacaque      | 20372       |
    |  Mexico  | Acolman           | 4998        |
    |  Turkey  | Amasya            | 82939       |
    |  Brazil  | Coração de Jesus  | 12410       |
    |  Brazil  | Ribeira do Pombal | 28236       |
    |----------+-------------------+-------------|

