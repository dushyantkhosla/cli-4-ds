[TOC]

# Introduction

This document serves as an accompanying guide/index to the command-line tools discussed in the notebooks. Here we have presented the relevant functions/verbs from command-line-tools that work with tabular data in the context of data-analysis tasks.

# 00 - Import, Inspect

## `conversion`

- _from/to csv_

```bash
in2csv, csv2json
csvtk csv2tab, space2tab, tab2csv
xsv fmt
mlr cat

## compressed data?
mlr --prepipe
```


## `display`

```bash
head, tail
csvlook
csvtk pretty
xsv table
mlr head, tail
```


## `count`

- _rows, columns_

```bash
wc
xsv count
```


## `types`

- _detect types, conversion_

```bash
mlr put is_*
mlr put boolean, int, float, string
```


## `column names`

```bash
csvcut -n
xsv headers
csvtk headers
mlr label
```

# 01 - Subset​


## `rename`

-  _one/many columns_

```bash
csvtk rename, rename2
mlr rename
```


## `index`

- _create row names/indentifiers_

```bash
nl
xsv index
```


## `subset columns` 

- _select/exclude cols_


```bash
cut
csvcut
csvtk select
xsv select
mlr cut
mlr having-fields
```


## `subset rows` 

- _select/exclude rows_

```bash
cut
csvgrep
csvtk filter, filter2, grep
xsv search
mlr filter
```


## `sample`

- _with (bootstrap) or without replacement (permutation)_


```bash
shuf
csvtk sample
xsv sample
mlr bootstrap, sample, shuffle, decimate
```


## `split`

- _large file into smaller files_


```bash
split
csplit
xsv split
```

# 02-Clean​

## `missing values`


```bash
awk
csvstat --nulls
mlr put is_null, is_not_null
```

## `duplicates`

```bash
mlr repeat # create dups
datamash rmdup
```

# 03-Mutate​

## `mutate`

- _create/drop rows, cols_


```bash
awk
mlr put
csvtk mutate
```

## `format`

- _numerical formatting_

```bash
numfmt
datamash round, ceil, floor, trunc, frac
```

## `time conversions`

-  _from/to epoch_

```bash
mlr put with strftime, strptime
mlr sec2gmt, sec2gmtdate
```

## `functions`

- _apply, map_


```bash
awk
mlr put

```

## `discretize`


- _cut numerics into categoricals_


```bash
datamash bin
mlr histogram --nbins
```

## `reshape`


- _long/wide to wide/long_


```bash
paste
csvtk transpose
datamash transpose

# pandas-like reshape
mlr reshape
```

# 04-Merge/Join/Concat


## ` join`

- _merge tables_


```bash
join
csvtk join
xsv join
```


## `concat`

- _append/concat tables_


```bash
cat
csvstack
xsv cat

# concat when cols are not same
mlr unsparsify
```


## ` compare, intersect`

- _rows in A & B, rows in A not in B etc._


```bash
comm
csvtk intersect
```

# 05-Explore

## `aggregate`

- _group-by, pivot_


```bash
datamash
mlr
```


## `sort`

```bash
sort
csvsort
```


## `uniques`

```bash
uniq
csvtk uniq
```


## `frequencies`


```bash
uniq -c
csvtk freq
xsv frequency
mlr top
mlr least-frequent, most-frequent
mlr fraction # convert frequencies to percentages
```


## `crosstabs`


```bash
datamash crosstab
```



# 06-Analyze/Visualize​


## `univariate`

- _mean/stddev, median, percentiles, skewness/kurtosis, mode, min/max_

```bash
csvstat
csvtk stats, stats2
xsv stats
mlr stats1, stats2
datamash
```

## `bivariate`

- _correlation/covariance, regression, r-squared_

```bash
mlr stats2
```

## `visualize`

- _histograms, scatterplots_

```bash
csvtk plot
mlr bar
```

# 07-Advanced

## `generate`


- _random data_

```
seq, shuf, pr
mlr seqgen
mlr put "urand(), urandint()"
```

## `query`


- _run sql queries_

```bash
csvsql
q -H -d, """query"""

# generate a CREATE TABLE query for your csv
# super useful when pushing data into a local db (mysql, postgresql etc.)
csvsql -i sqlite joined.csv
```




