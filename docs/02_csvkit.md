# [csvkit](http://csvkit.readthedocs.io/latest/)

[TOC]

---

## Data

```python
import os
os.chdir("/home/data")
```


```python
ls -l --block-size=MB
```

    total 1446MB
    -rw------- 1 root root 703MB Mar  4 01:05 flights.csv
    -rw-r--r-- 1 root root   1MB Mar  4 01:26 flights_1k.csv
    -rw-r--r-- 1 root root   1MB Mar  4 01:01 get-csvs.sh
    -rw-r--r-- 1 root root   1MB Mar  4 01:13 kddcup-names
    -rw------- 1 root root 743MB Mar  4 01:00 kddcup.data



---

## csvlook


```python
!head flights.csv | cut -d, -f5-12 |  csvlook
```

    | DepTime | CRSDepTime | ArrTime | CRSArrTime | UniqueCarrier | FlightNum | TailNum | ActualElapsedTime |
    | ------- | ---------- | ------- | ---------- | ------------- | --------- | ------- | ----------------- |
    |   1,232 |      1,225 |   1,341 |      1,340 | WN            |     2,891 | N351    |                69 |
    |   1,918 |      1,905 |   2,043 |      2,035 | WN            |       462 | N370    |                85 |
    |   2,206 |      2,130 |   2,334 |      2,300 | WN            |     1,229 | N685    |                88 |
    |   1,230 |      1,200 |   1,356 |      1,330 | WN            |     1,355 | N364    |                86 |
    |     831 |        830 |     957 |      1,000 | WN            |     2,278 | N480    |                86 |
    |   1,430 |      1,420 |   1,553 |      1,550 | WN            |     2,386 | N611SW  |                83 |
    |   1,936 |      1,840 |   2,217 |      2,130 | WN            |       409 | N482    |               101 |
    |     944 |        935 |   1,223 |      1,225 | WN            |     1,131 | N749SW  |                99 |
    |   1,537 |      1,450 |   1,819 |      1,735 | WN            |     1,212 | N451    |               102 |



```python
# Again, but with an index
!head flights.csv | cut -d, -f5-12 |  csvlook -l
```

    | line_numbers | DepTime | CRSDepTime | ArrTime | CRSArrTime | UniqueCarrier | FlightNum | TailNum | ActualElapsedTime |
    | ------------ | ------- | ---------- | ------- | ---------- | ------------- | --------- | ------- | ----------------- |
    |            1 |   1,232 |      1,225 |   1,341 |      1,340 | WN            |     2,891 | N351    |                69 |
    |            2 |   1,918 |      1,905 |   2,043 |      2,035 | WN            |       462 | N370    |                85 |
    |            3 |   2,206 |      2,130 |   2,334 |      2,300 | WN            |     1,229 | N685    |                88 |
    |            4 |   1,230 |      1,200 |   1,356 |      1,330 | WN            |     1,355 | N364    |                86 |
    |            5 |     831 |        830 |     957 |      1,000 | WN            |     2,278 | N480    |                86 |
    |            6 |   1,430 |      1,420 |   1,553 |      1,550 | WN            |     2,386 | N611SW  |                83 |
    |            7 |   1,936 |      1,840 |   2,217 |      2,130 | WN            |       409 | N482    |               101 |
    |            8 |     944 |        935 |   1,223 |      1,225 | WN            |     1,131 | N749SW  |                99 |
    |            9 |   1,537 |      1,450 |   1,819 |      1,735 | WN            |     1,212 | N451    |               102 |


---

## csvcut

- **For column subsetting**

```

Options

  -n, --names           Display column names and indices from the input CSV
                        and exit.
  -c COLUMNS, --columns COLUMNS
                        A comma separated list of column indices or names to
                        be extracted. Defaults to all columns.
  -C NOT_COLUMNS, --not-columns NOT_COLUMNS
                        A comma separated list of column indices or names to
                        be excluded. Defaults to no columns.
  -x, --delete-empty-rows
                        After cutting, delete rows which are completely empty.
```


```python
# Get column names and positions
!csvcut -n flights.csv | head
```

      1: Year
      2: Month
      3: DayofMonth
      4: DayOfWeek
      5: DepTime
      6: CRSDepTime
      7: ArrTime
      8: CRSArrTime
      9: UniqueCarrier
     10: FlightNum



```python
# subset columns by name with -c
!head flights.csv | csvcut -c FlightNum,UniqueCarrier | csvlook
```

    | FlightNum | UniqueCarrier |
    | --------- | ------------- |
    |     2,891 | WN            |
    |       462 | WN            |
    |     1,229 | WN            |
    |     1,355 | WN            |
    |     2,278 | WN            |
    |     2,386 | WN            |
    |       409 | WN            |
    |     1,131 | WN            |
    |     1,212 | WN            |



```python
# or by positions
!head flights.csv | csvcut -c 1-2,6,8 | csvlook
```

    |  Year | Month | CRSDepTime | CRSArrTime |
    | ----- | ----- | ---------- | ---------- |
    | 2,007 |  True |      1,225 |      1,340 |
    | 2,007 |  True |      1,905 |      2,035 |
    | 2,007 |  True |      2,130 |      2,300 |
    | 2,007 |  True |      1,200 |      1,330 |
    | 2,007 |  True |        830 |      1,000 |
    | 2,007 |  True |      1,420 |      1,550 |
    | 2,007 |  True |      1,840 |      2,130 |
    | 2,007 |  True |        935 |      1,225 |
    | 2,007 |  True |      1,450 |      1,735 |



```python
# drop columns with -C, by name or position
!head flights.csv \
| csvcut -c 10-15 \
| csvcut -C TailNum,CRSElapsedTime \
| csvlook
```

    | FlightNum | ActualElapsedTime | AirTime | ArrDelay |
    | --------- | ----------------- | ------- | -------- |
    |     2,891 |                69 |      54 |        1 |
    |       462 |                85 |      74 |        8 |
    |     1,229 |                88 |      73 |       34 |
    |     1,355 |                86 |      75 |       26 |
    |     2,278 |                86 |      74 |       -3 |
    |     2,386 |                83 |      74 |        3 |
    |       409 |               101 |      89 |       47 |
    |     1,131 |                99 |      86 |       -2 |
    |     1,212 |               102 |      90 |       44 |



```python
# Combinations work too
!head flights.csv \
| csvcut -c 1-2,FlightNum,ArrDelay\
| csvlook
```

    |  Year | Month | FlightNum | ArrDelay |
    | ----- | ----- | --------- | -------- |
    | 2,007 |  True |     2,891 |        1 |
    | 2,007 |  True |       462 |        8 |
    | 2,007 |  True |     1,229 |       34 |
    | 2,007 |  True |     1,355 |       26 |
    | 2,007 |  True |     2,278 |       -3 |
    | 2,007 |  True |     2,386 |        3 |
    | 2,007 |  True |       409 |       47 |
    | 2,007 |  True |     1,131 |       -2 |
    | 2,007 |  True |     1,212 |       44 |


---

## csvgrep

** Subset Rows **

```
Options

  -c COLUMNS, --columns COLUMNS
                        A comma separated list of column indices or names to
                        be searched.
  -m PATTERN, --match PATTERN
                        The string to search for.
  -r REGEX, --regex REGEX
                        If specified, must be followed by a regular expression
                        which will be tested against the specified columns.
  -f MATCHFILE, --file MATCHFILE
                        If specified, must be the path to a file. For each
                        tested row, if any line in the file (stripped of line
                        separators) is an exact match for the cell value, the
                        row will pass.
  -i, --invert-match    If specified, select non-matching instead of matching
                        rows.
```


```python
!csvcut -c Origin flights.csv | head
```

    Origin
    SMF
    SMF
    SMF
    SMF
    SMF
    SMF
    SMF
    SMF
    SMF



```python
# Filter for rows where origin is San Francisco
!csvgrep -c Origin -m SFO flights.csv \
| head -n 5 \
| csvcut -c 17-22 \
| csvlook
```

    | Origin | Dest | Distance | TaxiIn | TaxiOut | Cancelled |
    | ------ | ---- | -------- | ------ | ------- | --------- |
    | SFO    | PHX  |      651 |      4 |       4 |     False |
    | SFO    | PHX  |      651 |      7 |      21 |     False |
    | SFO    | PHX  |      651 |      7 |      13 |     False |
    | SFO    | PHX  |      651 |      5 |      16 |     False |



```python
# Filter for rows where Origin is not SFO
!csvgrep -ic Origin -m SFO flights.csv \
| head -n 5 \
| csvcut -c 17-22 \
| csvlook
```

    | Origin | Dest | Distance | TaxiIn | TaxiOut | Cancelled |
    | ------ | ---- | -------- | ------ | ------- | --------- |
    | SMF    | ONT  |      389 |      4 |      11 |     False |
    | SMF    | PDX  |      479 |      5 |       6 |     False |
    | SMF    | PDX  |      479 |      6 |       9 |     False |
    | SMF    | PDX  |      479 |      3 |       8 |     False |


---

## csvsort

```
Options

  -c COLUMNS, --columns COLUMNS
                        A comma separated list of column indices or names to
                        sort by. Defaults to all columns.
  -r, --reverse         Sort in descending order.
  --no-inference        Disable type inference when parsing the input.

```


```python
# ascending
!head -n 1000 flights.csv \
| csvsort -c ArrDelay \
| csvcut -c 14-20 \
| head \
| csvlook
```

    | AirTime | ArrDelay | DepDelay | Origin | Dest | Distance | TaxiIn |
    | ------- | -------- | -------- | ------ | ---- | -------- | ------ |
    |     230 |      -51 |       -6 | CLE    | LAS  |    1,825 |      4 |
    |     202 |      -39 |        0 | BNA    | LAS  |    1,588 |      4 |
    |     290 |      -39 |        5 | BWI    | SAN  |    2,295 |      3 |
    |     208 |      -37 |       -3 | BNA    | LAS  |    1,588 |      3 |
    |     227 |      -37 |        2 | BNA    | LAX  |    1,797 |      8 |
    |     219 |      -37 |        3 | BNA    | SAN  |    1,751 |      2 |
    |     251 |      -37 |       -1 | BUF    | LAS  |    1,987 |      5 |
    |     224 |      -36 |       -4 | BNA    | ONT  |    1,751 |      5 |
    |     301 |      -36 |       -1 | BWI    | SAN  |    2,295 |      3 |



```python
# descending
!head -n 1000 flights.csv \
| csvsort -rc ArrDelay \
| csvcut -c 14-20 \
| head \
| csvlook
```

    | AirTime | ArrDelay | DepDelay | Origin | Dest | Distance | TaxiIn |
    | ------- | -------- | -------- | ------ | ---- | -------- | ------ |
    |         |          |          | SNA    | LAS  |      226 |      0 |
    |         |          |          | AUS    | DAL  |      189 |      0 |
    |         |          |          | DAL    | AUS  |      189 |      0 |
    |         |          |          | DAL    | HOU  |      239 |      0 |
    |         |          |          | DAL    | HOU  |      239 |      0 |
    |         |          |          | DAL    | HOU  |      239 |      0 |
    |      51 |      219 |      229 | CMH    | MDW  |      284 |      4 |
    |      50 |      165 |      162 | SNA    | LAS  |      226 |      4 |
    |      49 |      133 |      138 | BWI    | ALB  |      288 |      3 |


---

## csvstat

- Outputs the statistical summary of all/particular columns
- Default action is to provide a lot of information (you can choose either all or one.

> - Tells you if there are nulls ina a column (will hog the memory - maybe run inside Docker?)
- Gives you info on the dtypes
- Frequency table for free!
- !!!---painfully slow---!!! (I would crontab this to run overnight)


<br>

```
Options

  --max                 Only output max.
  --min                 Only output min.
  --sum                 Only output sum.
  --mean                Only output mean.
  --median              Only output median.
  --stdev               Only output standard deviation.
  --nulls               Only output whether column contains nulls.
  --unique              Only output unique values.
  --freq                Only output frequent values.
  --len                 Only output max value length.
  --count               Only output row count
```


```python
!csvstat -c src_bytes,dst_bytes kddcup.data
```

    Killed



```python
# Returns top 5 by default
!csvstat -c Origin --freq flights.csv
```

    Killed


---

## csvstack

```
Options

  -g GROUPS, --groups GROUPS
                        A comma-seperated list of values to add as "grouping
                        factors", one for each CSV being stacked. These will
                        be added to the stacked CSV as a new column. You may
                        specify a name for the grouping column using the -n
                        flag.
  -n GROUP_NAME, --group-name GROUP_NAME
                        A name for the grouping column, e.g. "year". Only used
                        when also specifying -g.
  --filenames           Use the filename of each input file as its grouping
                        value. When specified, -g will be ignored.
```


```python
# Create files (only one should have the header)
!head flights.csv > flights_01.csv
!tail flights.csv > flights_02.csv

!csvstack flights_01.csv flights_02.csv | csvcut -c 15-20 | csvlook
```

    | ArrDelay | DepDelay | Origin | Dest | Distance | TaxiIn |
    | -------- | -------- | ------ | ---- | -------- | ------ |
    |        1 |        7 | SMF    | ONT  |      389 |      4 |
    |        8 |       13 | SMF    | PDX  |      479 |      5 |
    |       34 |       36 | SMF    | PDX  |      479 |      6 |
    |       26 |       30 | SMF    | PDX  |      479 |      3 |
    |       -3 |        1 | SMF    | PDX  |      479 |      3 |
    |        3 |       10 | SMF    | PDX  |      479 |      2 |
    |       47 |       56 | SMF    | PHX  |      647 |      5 |
    |       -2 |        9 | SMF    | PHX  |      647 |      4 |
    |       44 |       47 | SMF    | PHX  |      647 |      5 |
    |       24 |       45 | ATL    | SFO  |    2,139 |     10 |
    |        1 |        6 | SLC    | CVG  |    1,449 |      8 |
    |       -9 |        1 | CVG    | SLC  |    1,449 |      6 |
    |        9 |       -1 | CVG    | ATL  |      373 |     13 |
    |       13 |       -7 | MCO    | ATL  |      403 |     14 |
    |        5 |       11 | ATL    | SLC  |    1,589 |      6 |
    |       15 |       -1 | LAX    | ATL  |    1,946 |     14 |
    |       36 |       38 | DFW    | ATL  |      732 |     11 |
    |       33 |       24 | ATL    | MCO  |      403 |     10 |



```python
# globbing allowed
!csvstack flights_*.csv | csvcut -c 15-20 | head |csvlook 
```

    | ArrDelay | DepDelay | Origin | Dest | Distance | TaxiIn |
    | -------- | -------- | ------ | ---- | -------- | ------ |
    |        1 |        7 | SMF    | ONT  |      389 |      4 |
    |        8 |       13 | SMF    | PDX  |      479 |      5 |
    |       34 |       36 | SMF    | PDX  |      479 |      6 |
    |       26 |       30 | SMF    | PDX  |      479 |      3 |
    |       -3 |        1 | SMF    | PDX  |      479 |      3 |
    |        3 |       10 | SMF    | PDX  |      479 |      2 |
    |       47 |       56 | SMF    | PHX  |      647 |      5 |
    |       -2 |        9 | SMF    | PHX  |      647 |      4 |
    |       44 |       47 | SMF    | PHX  |      647 |      5 |



```python
# Keep track of things
!csvstack -g head,tail -n source_dataframe flights_0* | csvcut -c 1,15-20 | head | csvlook 
```

    | source_dataframe | AirTime | ArrDelay | DepDelay | Origin | Dest | Distance |
    | ---------------- | ------- | -------- | -------- | ------ | ---- | -------- |
    | head             |      54 |        1 |        7 | SMF    | ONT  |      389 |
    | head             |      74 |        8 |       13 | SMF    | PDX  |      479 |
    | head             |      73 |       34 |       36 | SMF    | PDX  |      479 |
    | head             |      75 |       26 |       30 | SMF    | PDX  |      479 |
    | head             |      74 |       -3 |        1 | SMF    | PDX  |      479 |
    | head             |      74 |        3 |       10 | SMF    | PDX  |      479 |
    | head             |      89 |       47 |       56 | SMF    | PHX  |      647 |
    | head             |      86 |       -2 |        9 | SMF    | PHX  |      647 |
    | head             |      90 |       44 |       47 | SMF    | PHX  |      647 |



```python
!csvstack --filenames flights_0* |  csvcut -c 1,15-20 | head | csvlook 
```

    | group          | AirTime | ArrDelay | DepDelay | Origin | Dest | Distance |
    | -------------- | ------- | -------- | -------- | ------ | ---- | -------- |
    | flights_01.csv |      54 |        1 |        7 | SMF    | ONT  |      389 |
    | flights_01.csv |      74 |        8 |       13 | SMF    | PDX  |      479 |
    | flights_01.csv |      73 |       34 |       36 | SMF    | PDX  |      479 |
    | flights_01.csv |      75 |       26 |       30 | SMF    | PDX  |      479 |
    | flights_01.csv |      74 |       -3 |        1 | SMF    | PDX  |      479 |
    | flights_01.csv |      74 |        3 |       10 | SMF    | PDX  |      479 |
    | flights_01.csv |      89 |       47 |       56 | SMF    | PHX  |      647 |
    | flights_01.csv |      86 |       -2 |        9 | SMF    | PHX  |      647 |
    | flights_01.csv |      90 |       44 |       47 | SMF    | PHX  |      647 |


---

## csvsql

- Generate SQL CREATE TABLE statements for one or more CSV files (**very useful!**)
    - Execute these statements directly on a database
- Execute one or more SQL queries.


```
OPTIONS

-i {access,sybase,sqlite,informix,firebird,mysql,oracle,maxdb,postgresql,mssql}, --dialect {access,sybase,sqlite,informix,firebird,mysql,oracle,maxdb,postgresql,mssql}
                        Dialect of SQL to generate. Only valid when --db is
                        not specified.
  --db CONNECTION_STRING
                        If present, a sqlalchemy connection string to use to
                        directly execute generated SQL on a database.
  --query QUERY         Execute one or more SQL queries delimited by ";" and
                        output the result of the last query as CSV.
  --insert              In addition to creating the table, also insert the
                        data into the table. Only valid when --db is
                        specified.
  --tables TABLE_NAMES  Specify one or more names for the tables to be
                        created. If omitted, the filename (minus extension) or
                        "stdin" will be used.
  --no-constraints      Generate a schema without length limits or null
                        checks. Useful when sampling big tables.
  --no-create           Skip creating a table. Only valid when --insert is
                        specified.
  --blanks              Do not coerce empty strings to NULL values.
  --no-inference        Disable type inference when parsing the input.
  --db-schema DB_SCHEMA
                        Optional name of database schema to create table(s)
                        in.
        
```


```python
!head flights.csv | csvsql -i sqlite .
```

    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    [Errno 21] Is a directory: '.'



```python
!head -n 10000 flights.csv | csvsql -i postgresql
```

    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    CREATE TABLE stdin (
    	"Year" DECIMAL NOT NULL, 
    	"Month" BOOLEAN NOT NULL, 
    	"DayofMonth" DECIMAL NOT NULL, 
    	"DayOfWeek" DECIMAL NOT NULL, 
    	"DepTime" DECIMAL, 
    	"CRSDepTime" DECIMAL NOT NULL, 
    	"ArrTime" DECIMAL, 
    	"CRSArrTime" DECIMAL NOT NULL, 
    	"UniqueCarrier" VARCHAR(2) NOT NULL, 
    	"FlightNum" DECIMAL NOT NULL, 
    	"TailNum" VARCHAR(6) NOT NULL, 
    	"ActualElapsedTime" DECIMAL, 
    	"CRSElapsedTime" DECIMAL NOT NULL, 
    	"AirTime" DECIMAL, 
    	"ArrDelay" DECIMAL, 
    	"DepDelay" DECIMAL, 
    	"Origin" VARCHAR(3) NOT NULL, 
    	"Dest" VARCHAR(3) NOT NULL, 
    	"Distance" DECIMAL NOT NULL, 
    	"TaxiIn" DECIMAL NOT NULL, 
    	"TaxiOut" DECIMAL NOT NULL, 
    	"Cancelled" BOOLEAN NOT NULL, 
    	"CancellationCode" VARCHAR(1), 
    	"Diverted" BOOLEAN NOT NULL, 
    	"CarrierDelay" DECIMAL NOT NULL, 
    	"WeatherDelay" DECIMAL NOT NULL, 
    	"NASDelay" DECIMAL NOT NULL, 
    	"SecurityDelay" DECIMAL NOT NULL, 
    	"LateAircraftDelay" DECIMAL NOT NULL
    );



```python
!head -n 1000 kddcup.data \
| csvsql --query """SELECT distinct(interaction_type), count(*) \
                   FROM kdd \
                   WHERE src_bytes > 1000 \
                   GROUP BY 1 \
                   ORDER BY 2 DESC""" \
| csvlook
```

    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/importlib/_bootstrap_external.py:426: ImportWarning: Not importing directory /miniconda/envs/ds-py3/lib/python3.6/site-packages/mpl_toolkits: missing __init__
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_2".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_3".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_4".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_5".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_6".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_7".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_8".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_9".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_10".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_11".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_12".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_13".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_14".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_15".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_16".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "1" already exists in Table. Column will be renamed to "1_2".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "1" already exists in Table. Column will be renamed to "1_3".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_2".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_3".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_4".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_5".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_6".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_17".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0" already exists in Table. Column will be renamed to "0_18".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_7".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_8".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_9".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_10".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_11".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_12".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_13".
    /miniconda/envs/ds-py3/lib/python3.6/site-packages/agate/utils.py:291: DuplicateColumnWarning: Column name "0.00" already exists in Table. Column will be renamed to "0.00_14".
    (sqlite3.OperationalError) no such table: kdd [SQL: 'SELECT distinct(interaction_type), count(*)                    FROM kdd                    WHERE src_bytes > 1000                    GROUP BY 1                    ORDER BY 2 DESC'] (Background on this error at: http://sqlalche.me/e/e3q8)




```python
# Create a table and import data from the CSV directly into Postgres:
# to be tested
!createdb test
!csvsql --db postgresql:///test --table fy09 --insert examples/realdata/FY09_EDU_Recipients_by_State.csv
```


```python
# Create tables for an entire folder of CSVs and import data from those files directly into Postgres:
# to be tested
!createdb test
!csvsql --db postgresql:///test --insert examples/*.csv
```
