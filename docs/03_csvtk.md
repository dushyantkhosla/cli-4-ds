# csvtk

- A cross-platform, efficient, practical and pretty CSV/TSV toolkit in Golang
- [docs](http://bioinf.shenwei.me/csvtk/)
- [Usage](http://bioinf.shenwei.me/csvtk/usage/)
- [Tutorial](http://bioinf.shenwei.me/csvtk/tutorial/)

[TOC]

---

## Introduction


```python
!csvtk
```

    A cross-platform, efficient and practical CSV/TSV toolkit
    
    Version: 0.13.0
    
    Author: Wei Shen <shenwei356@gmail.com>
    
    Documents  : http://shenwei356.github.io/csvtk
    Source code: https://github.com/shenwei356/csvtk
    
    Attention:
    
        1. The CSV parser requires all the lines have same number of fields/columns.
           Even lines with spaces will cause error.
        2. By default, csvtk thinks your files have header row, if not, switch flag "-H" on.
        3. Column names better be unique.
        4. By default, lines starting with "#" will be ignored, if the header row
           starts with "#", please assign flag "-C" another rare symbol, e.g. '$'.
        5. By default, csvtk handles CSV files, use flag "-t" for tab-delimited files.
        6. If " exists in tab-delimited files, use flag "-l".
    
    Environment variables for frequently used global flags
    
        - "CSVTK_T" for flag "-t/--tabs"
        - "CSVTK_H" for flag "-H/--no-header-row"
    
    Usage:
      csvtk [command]
    
    Available Commands:
      collapse        collapse one field with selected fields as keys
      concat          concatenate CSV/TSV files by rows
      csv2md          convert CSV to markdown format
      csv2tab         convert CSV to tabular format
      cut             select parts of fields
      filter          filter rows by values of selected fields with artithmetic expression
      filter2         filter rows by awk-like artithmetic/string expressions
      freq            frequencies of selected fields
      gather          gather columns into key-value pairs
      genautocomplete generate shell autocompletion script
      grep            grep data by selected fields with patterns/regular expressions
      head            print first N records
      headers         print headers
      help            Help about any command
      inter           intersection of multiple files
      join            join multiple CSV files by selected fields
      mutate          create new column from selected fields by regular expression
      mutate2         create new column from selected fields by awk-like artithmetic/string expressions
      plot            plot common figures
      pretty          convert CSV to readable aligned table
      rename          rename column names
      rename2         rename column names by regular expression
      replace         replace data of selected fields by regular expression
      sample          sampling by proportion
      sort            sort by selected fields
      space2tab       convert space delimited format to CSV
      split           split CSV/TSV into multiple files according to column values
      splitxlsx       split XLSX sheet into multiple sheets according to column values
      stats           summary of CSV file
      stats2          summary of selected digital fields
      tab2csv         convert tabular format to CSV
      transpose       transpose CSV data
      uniq            unique data without sorting
      version         print version information and check for update
      xlsx2csv        convert XLSX to CSV format
    
    Flags:
      -c, --chunk-size int         chunk size of CSV reader (default 50)
      -C, --comment-char string    lines starting with commment-character will be ignored. if your header row starts with '#', please assign "-C" another rare symbol, e.g. '$' (default "#")
      -d, --delimiter string       delimiting character of the input CSV file (default ",")
      -h, --help                   help for csvtk
      -l, --lazy-quotes            if given, a quote may appear in an unquoted field and a non-doubled quote may appear in a quoted field
      -H, --no-header-row          specifies that the input CSV file does not have header row
      -j, --num-cpus int           number of CPUs to use (default value depends on your computer) (default 3)
      -D, --out-delimiter string   delimiting character of the output CSV file (default ",")
      -o, --out-file string        out file ("-" for stdout, suffix .gz for gzipped out) (default "-")
      -T, --out-tabs               specifies that the output is delimited with tabs. Overrides "-D"
      -t, --tabs                   specifies that the input CSV file is delimited with tabs. Overrides "-d" and "-D"
    
    Use "csvtk [command] --help" for more information about a command.

## Data

```python
import os
os.chdir("/home/data")
```


```python
ls | grep csv | xargs wc -l
```

       7453216 flights.csv
            10 flights_01.csv
            10 flights_02.csv
          1000 flights_1k.csv
      10000001 fromPandas.csv
            27 get-csvs.sh
      17454264 total



## See column names


```python
!csvtk headers fromPandas.csv
```

    # fromPandas.csv
    1	C00
    2	A01
    3	A02
    4	A03
    5	C04
    6	D05
    7	B06
    8	C07
    9	C08
    10	A09


## See first few rows


```python
!csvtk head -n 5 fromPandas.csv
```

    C00,A01,A02,A03,C04,D05,B06,C07,C08,A09
    PO,Critical,0.31,-0.02,0.15,0.52,-1.24,-1.12,-1.68,-0.7
    AR,Critical,1.33,-0.65,0.29,-1.31,0.32,-1.61,1.27,0.34
    AR,Critical,-2.4,-0.23,0.28,0.95,0.82,-0.18,-1.73,-1.44
    PO,Critical,0.16,-0.01,0.46,0.09,-0.43,-0.79,-1.5,0.87
    PO,Alert,-0.34,-0.37,0.17,0.62,-1.19,1.81,0.66,0.1


## `pretty`


```python
!csvtk pretty -h
```


```python
!csvtk head fromPandas.csv | csvtk pretty -r
```

## `sample`

- the `-H` switch removes the header, `-p` specifies proportion


```python
!csvtk sample -H -p 0.01 fromPandas.csv | wc -l
```


```python
!csvtk sample -p 0.001 fromPandas.csv | head
```

## `stats` 


```python
!csvtk stats fromPandas.csv
```

## `cut`


```python
!csvtk cut -h
```


```python
# by position, ranges
!head fromPandas.csv | csvtk cut -f 2,3,5-7 | csvtk pretty -r
```


```python
# by exact name
!head fromPandas.csv | csvtk cut -f A05,B07,C00,D04 | csvtk pretty -r
```


```python
# by fuzzy matching
!head fromPandas.csv | csvtk cut -F -f "A0*,D01" | csvtk pretty -r
```


```python
# ignoring columns by position, ranges
# csvtk cut -f -3--1 for discarding column 1,2,3
!head fromPandas.csv | csvtk cut -f -5--2,-10--9 | csvtk pretty -r
```

## `uniq`


```python
!csvtk uniq -h
```


```python
# will retain the rows corresponding to the first occurence of each value in column
!cat fromPandas.csv | csvtk uniq -f C00
```


```python
!cat fromPandas.csv | csvtk cut -f D01 | csvtk uniq -f 1
```

## `freq`


```python
!csvtk freq -h
```


```python
!cat fromPandas.csv | csvtk freq -f C00
```


```python
# sort by key
!cat fromPandas.csv | csvtk freq -f C00 -k | csvtk pretty
```


```python
# sort in descending order of count
!cat fromPandas.csv | csvtk freq -f C00 -n -r | csvtk pretty
```


```python
# combination of two variables
!cat fromPandas.csv | csvtk freq -f C00,D01 -n -r | csvtk pretty
```

---

## `plot`


```python
!csvtk plot -h
```

### Histogram


```python
!cat fromPandas.csv \
| csvtk sample -p 0.01 \
| csvtk plot hist -f "D04" -o hist.png
```


```python
Image('hist.png', width=400)
```

### Boxplots


```python
!cat fromPandas.csv \
| csvtk sample -p 0.01 \
| csvtk plot box -g "C00" -f "D04" -o box.png
```


```python
Image('box.png', width=400)
```


```python
!cat fromPandas.csv \
| csvtk sample -p 0.01 \
| csvtk plot box -g "C00" -f "D04" --horiz -o box2.png
```


```python
Image('box2.png', width=400)
```


```python
import pandas as pd
import numpy as np

%pylab inline

df = (pd.DataFrame({'x': range(5000)})
 .assign(Y = lambda df: np.random.randn(5000).round(2))
 .assign(Z = lambda df: 2 * df['x'] + 5)
 .assign(Grp = pd.Series(list('ABCD')).sample(5000, replace=True).values))

df.to_csv('line.csv', index=False)
```


```python
!csvtk plot line line.csv -x x -y Y -o lineplot.png
```


```python
Image('lineplot.png')
```

### ScatterPlot


```python
!cat line.csv \
| csvtk plot line -x x -y Y -g Grp --scatter -o scatter.png
```


```python
Image('scatter.png', width=400)
```

---

## `grep`


```python
!csvtk grep -h
```


```python
!cat fromPandas.csv | csvtk grep -f C00 -p EN | csvtk head | csvtk pretty -r
```


```python
# Remore rows containing missing data
!csvtk grep -F -f "*" -r -p "^$" -v
```

---

## `filter`


```python
!csvtk filter -h
```


```python
!cat fromPandas.csv | csvtk filter -f "D04>3.00" | wc -l
```


```python
!cat fromPandas.csv | csvtk filter -F -f "A*>1" | csvtk head | csvtk pretty
```

---

## `filter2`


```python
!csvtk filter2 -h
```


```python
!cat fromPandas.csv | csvtk filter2 -f '$A05>1 && $C00=="ES"' | csvtk head | csvtk pretty -r
```

---

## `rename`


```python
!csvtk rename -h
```


```python
!cat fromPandas.csv | csvtk rename -f 1,2 -n Lang,Msg | csvtk head | csvtk pretty -r
```


```python
!csvtk rename2 -h
```


```python
!head -5 fromPandas.csv \
| csvtk cut -f -2--1 \
| csvtk rename2 -F -f "*" -p "(.*)" -r 'Num_${1}' \
| csvtk pretty -r 
```

---

## `stats2`


```python
!csvtk stats2 -h
```


```python
!cat fromPandas.csv | csvtk stats2 -F -f 'A*'
```

---

## `mutate`


```python
!csvtk mutate -h
```


```python
!head fromPandas.csv | csvtk mutate -f C00 -n C00_copy
```

## `sort`


```python
!csvtk sort -h
```


```python

```
