# README

---

This document serves as an accompanying guide/index to the command-line tools discussed in the notebooks. Here we have presented the relevant functions/verbs from command-line-tools that work with tabular data in the context of data-analysis tasks.

Expand each section for names of functions that help in performing said task, then access the respective notebook for specific examples.

---

# $00 - Import, Inspect$

## `conversion`

- _from/to csv_

---

```bash
in2csv, csv2json
csvtk csv2tab, space2tab, tab2csv
xsv fmt
mlr cat

## compressed data?
mlr --prepipe
```

---
## `display`

```bash
head, tail
csvlook
csvtk pretty
xsv table
mlr head, tail
```

---
## `count`

- _rows, columns_

```bash
wc
xsv count
```

---
## `types`

- _detect types, conversion_

---

```bash
mlr put is_*
mlr put boolean, int, float, string
```

---
## `column names`

```bash
csvcut -n
xsv headers
csvtk headers
mlr label
```

# $01 - Subset$

---
## `rename`

-  _one/many columns_



```bash
csvtk rename, rename2
mlr rename
```

---
## `index`

- _create row names/indentifiers_



```bash
nl
xsv index
```

---
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

---
## `subset rows` 

- _select/exclude rows_

```bash
cut
csvgrep
csvtk filter, filter2, grep
xsv search
mlr filter
```

---
## `sample`

- _with (bootstrap) or without replacement (permutation)_


```bash
shuf
csvtk sample
xsv sample
mlr bootstrap, sample, shuffle, decimate
```

---
## `split`

- _large file into smaller files_


---

```bash
split
csplit
xsv split
```


```python

```

# $02-Clean$

## `missing`


## _detect, count, replace_


---

```bash
awk
csvstat --nulls
mlr put is_null, is_not_null
```

## `duplicates`

## _identify, remove dups_

---

```bash
mlr repeat # create dups
datamash rmdup
```


```python

```

# $03-Mutate$

---

## `mutate`

- _create/drop rows, cols_


```bash
awk
mlr put
csvtk mutate
```

---

## `format`

- _numerical formatting_

```bash
numfmt
datamash round, ceil, floor, trunc, frac
```

---

## `time conversions`

-  _from/to epoch_

```bash
mlr put with strftime, strptime
mlr sec2gmt, sec2gmtdate
```

---

## `functions`

- _apply, map_


```bash
awk
mlr put

```

---

## `discretize`


- _cut numerics into categoricals_


---

```bash
datamash bin
mlr histogram --nbins
```

---

## `reshape`


- _long/wide to wide/long_


```bash
paste
csvtk transpose
datamash transpose

# pandas-like reshape
mlr reshape
```

---

# $04-Merge/Join/Concat$

---
## ` join`

- _merge tables_


```bash
join
csvtk join
xsv join
```

---
## `concat`

- _append/concat tables_


```bash
cat
csvstack
xsv cat

# concat when cols are not same
mlr unsparsify
```

---
## ` compare, intersect`

- _rows in A & B, rows in A not in B etc._


```bash
comm
csvtk intersect
```

# $05-Explore$ 

## `aggregate`

- _group-by, pivot_


```bash
datamash
mlr
```

---
## `sort`

```bash
sort
csvsort
```

---
## `uniques`



```bash
uniq
csvtk uniq
```

---
## `frequencies`


```bash
uniq -c
csvtk freq
xsv frequency
mlr top
mlr least-frequent, most-frequent
mlr fraction # convert frequencies to percentages
```

---
## `crosstabs`


```bash
datamash crosstab
```

---

# $06-Analyze/Visualize$

---
## `univariate`

- _mean/stddev, median, percentiles, skewness/kurtosis, mode, min/max_

```bash
csvstat
csvtk stats, stats2
xsv stats
mlr stats1, stats2
datamash
```

---
## `bivariate`

- _correlation/covariance, regression, r-squared_

```bash
mlr stats2
```

---
## `visualize`

- _histograms, scatterplots_

```bash
csvtk plot
mlr bar
```

# $07-Advanced$

<br><br><br><br>

---
## `generate`


- _random data_

```
seq, shuf, pr
mlr seqgen
mlr put "urand(), urandint()"
```

---
## `query`


- _run sql queries_

```bash
csvsql
q -H -d, """query"""

# generate a CREATE TABLE query for your csv
# super useful when pushing data into a local db (mysql, postgresql etc.)
csvsql -i sqlite joined.csv
```

----
<br><br><br><br>

# $Appendix$

---

Expand the sections below to read through the help pages of these tools and for a list of the most frequently used verbs.

## `datamash`

---


```bash
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
```


```python
!datamash --help
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
    


## `mlr`

---


```bash
Verbs

   bar bootstrap cat check count-distinct cut decimate filter grep group-by
   group-like having-fields head histogram join label least-frequent
   merge-fields most-frequent nest nothing fraction put regularize rename
   reorder repeat reshape sample sec2gmt sec2gmtdate seqgen shuffle sort stats1
   stats2 step tac tail tee top uniq unsparsify

   Use "mlr {verb} -h" for help

Functions (for the `filter` and `put` verbs)

    # arithmetic, logical, conditional operators
   + + - - * / // % ** | ^ & ~ << >> == != =~ !=~ > >= < <= && || ^^ ! ? : .
   
   # string functions
   gsub strlen sub substr tolower toupper   
   
   # math
   abs ceil floor log log10 log1p
   max min msub exp pow qnorm  
   sgn sqrt cbrt
   
   # random numbers
   urand urand32 urandint 
 
   # date, time
   dhms2fsec dhms2sec fsec2dhms fsec2hms
   gmt2sec hms2fsec hms2sec sec2dhms sec2gmt sec2gmt sec2gmtdate sec2hms
   strftime strptime systime 
   
   # booleans
   is_absent is_bool is_boolean is_empty is_empty_map
   is_float is_int is_map is_nonempty_map is_not_empty is_not_map is_not_null
   is_null is_numeric is_present is_string 
  
   # type-conversoin, rounding, formatting 
   boolean float int string
   round roundm
   fmtnum hexfmt 
   
Use "mlr --help-function {function name}" for function-specific help.
```


```python
!mlr -h
```

    Usage: mlr [I/O options] {verb} [verb-dependent options ...] {zero or more file names}
    
    Command-line-syntax examples:
      mlr --csv cut -f hostname,uptime mydata.csv
      mlr --tsv --rs lf filter '$status != "down" && $upsec >= 10000' *.tsv
      mlr --nidx put '$sum = $7 < 0.0 ? 3.5 : $7 + 2.1*$8' *.dat
      grep -v '^#' /etc/group | mlr --ifs : --nidx --opprint label group,pass,gid,member then sort -f group
      mlr join -j account_id -f accounts.dat then group-by account_name balances.dat
      mlr --json put '$attr = sub($attr, "([0-9]+)_([0-9]+)_.*", "\1:\2")' data/*.json
      mlr stats1 -a min,mean,max,p10,p50,p90 -f flag,u,v data/*
      mlr stats2 -a linreg-pca -f u,v -g shape data/*
      mlr put -q '@sum[$a][$b] += $x; end {emit @sum, "a", "b"}' data/*
      mlr --from estimates.tbl put '
      for (k,v in $*) {
        if (is_numeric(v) && k =~ "^[t-z].*$") {
          $sum += v; $count += 1
        }
      }
      $mean = $sum / $count # no assignment if count unset'
      mlr --from infile.dat put -f analyze.mlr
      mlr --from infile.dat put 'tee > "./taps/data-".$a."-".$b, $*'
      mlr --from infile.dat put 'tee | "gzip > ./taps/data-".$a."-".$b.".gz", $*'
      mlr --from infile.dat put -q '@v=$*; dump | "jq .[]"'
      mlr --from infile.dat put  '(NR % 1000 == 0) { print > stderr, "Checkpoint ".NR}'
    
    Data-format examples:
      DKVP: delimited key-value pairs (Miller default format)
      +---------------------+
      | apple=1,bat=2,cog=3 | Record 1: "apple" => "1", "bat" => "2", "cog" => "3"
      | dish=7,egg=8,flint  | Record 2: "dish" => "7", "egg" => "8", "3" => "flint"
      +---------------------+
    
      NIDX: implicitly numerically indexed (Unix-toolkit style)
      +---------------------+
      | the quick brown     | Record 1: "1" => "the", "2" => "quick", "3" => "brown"
      | fox jumped          | Record 2: "1" => "fox", "2" => "jumped"
      +---------------------+
    
      CSV/CSV-lite: comma-separated values with separate header line
      +---------------------+
      | apple,bat,cog       |
      | 1,2,3               | Record 1: "apple => "1", "bat" => "2", "cog" => "3"
      | 4,5,6               | Record 2: "apple" => "4", "bat" => "5", "cog" => "6"
      +---------------------+
    
      Tabular JSON: nested objects are supported, although arrays within them are not:
      +---------------------+
      | {                   |
      |  "apple": 1,        | Record 1: "apple" => "1", "bat" => "2", "cog" => "3"
      |  "bat": 2,          |
      |  "cog": 3           |
      | }                   |
      | {                   |
      |   "dish": {         | Record 2: "dish:egg" => "7", "dish:flint" => "8", "garlic" => ""
      |     "egg": 7,       |
      |     "flint": 8      |
      |   },                |
      |   "garlic": ""      |
      | }                   |
      +---------------------+
    
      PPRINT: pretty-printed tabular
      +---------------------+
      | apple bat cog       |
      | 1     2   3         | Record 1: "apple => "1", "bat" => "2", "cog" => "3"
      | 4     5   6         | Record 2: "apple" => "4", "bat" => "5", "cog" => "6"
      +---------------------+
    
      XTAB: pretty-printed transposed tabular
      +---------------------+
      | apple 1             | Record 1: "apple" => "1", "bat" => "2", "cog" => "3"
      | bat   2             |
      | cog   3             |
      |                     |
      | dish 7              | Record 2: "dish" => "7", "egg" => "8"
      | egg  8              |
      +---------------------+
    
      Markdown tabular (supported for output only):
      +-----------------------+
      | | apple | bat | cog | |
      | | ---   | --- | --- | |
      | | 1     | 2   | 3   | | Record 1: "apple => "1", "bat" => "2", "cog" => "3"
      | | 4     | 5   | 6   | | Record 2: "apple" => "4", "bat" => "5", "cog" => "6"
      +-----------------------+
    
    Help options:
      -h or --help                 Show this message.
      --version                    Show the software version.
      {verb name} --help           Show verb-specific help.
      --help-all-verbs             Show help on all verbs.
      -l or --list-all-verbs       List only verb names.
      -L                           List only verb names, one per line.
      -f or --help-all-functions   Show help on all built-in functions.
      -F                           Show a bare listing of built-in functions by name.
      -k or --help-all-keywords    Show help on all keywords.
      -K                           Show a bare listing of keywords by name.
    
    Verbs:
       bar bootstrap cat check count-distinct cut decimate filter grep group-by
       group-like having-fields head histogram join label least-frequent
       merge-fields most-frequent nest nothing fraction put regularize rename
       reorder repeat reshape sample sec2gmt sec2gmtdate seqgen shuffle sort stats1
       stats2 step tac tail tee top uniq unsparsify
    
    Functions for the filter and put verbs:
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
    
    Please use "mlr --help-function {function name}" for function-specific help.
    
    Data-format options, for input, output, or both:
      --idkvp   --odkvp   --dkvp      Delimited key-value pairs, e.g "a=1,b=2"
                                      (this is Miller's default format).
    
      --inidx   --onidx   --nidx      Implicitly-integer-indexed fields
                                      (Unix-toolkit style).
    
      --icsv    --ocsv    --csv       Comma-separated value (or tab-separated
                                      with --fs tab, etc.)
    
      --itsv    --otsv    --tsv       Keystroke-savers for "--icsv --ifs tab",
                                      "--ocsv --ofs tab", "--csv --fs tab".
    
      --ipprint --opprint --pprint    Pretty-printed tabular (produces no
                                      output until all input is in).
                          --right     Right-justifies all fields for PPRINT output.
                          --barred    Prints a border around PPRINT output
                                      (only available for output).
    
                --omd                 Markdown-tabular (only available for output).
    
      --ixtab   --oxtab   --xtab      Pretty-printed vertical-tabular.
                          --xvright   Right-justifies values for XTAB format.
    
      --ijson   --ojson   --json      JSON tabular: sequence or list of one-level
                                      maps: {...}{...} or [{...},{...}].
        --json-map-arrays-on-input    JSON arrays are unmillerable. --json-map-arrays-on-input
        --json-skip-arrays-on-input   is the default: arrays are converted to integer-indexed
        --json-fatal-arrays-on-input  maps. The other two options cause them to be skipped, or
                                      to be treated as errors.  Please use the jq tool for full
                                      JSON (pre)processing.
                          --jvstack   Put one key-value pair per line for JSON
                                      output.
                          --jlistwrap Wrap JSON output in outermost [ ].
                        --jknquoteint Do not quote non-string map keys in JSON output.
                         --jvquoteall Quote map values in JSON output, even if they're
                                      numeric.
                  --jflatsep {string} Separator for flattening multi-level JSON keys,
                                      e.g. '{"a":{"b":3}}' becomes a:b => 3 for
                                      non-JSON formats. Defaults to :.
    
      -p is a keystroke-saver for --nidx --fs space --repifs
    
      Examples: --csv for CSV-formatted input and output; --idkvp --opprint for
      DKVP-formatted input and pretty-printed output.
    
    Format-conversion keystroke-saver options, for input, output, or both:
    As keystroke-savers for format-conversion you may use the following:
      --c2t --c2d --c2n --c2j --c2x --c2p --c2m
      --t2c       --t2d --t2n --t2j --t2x --t2p --t2m
      --d2c --d2t       --d2n --d2j --d2x --d2p --d2m
      --n2c --n2t --n2d       --n2j --n2x --n2p --n2m
      --j2c --j2t --j2d --j2n       --j2x --j2p --j2m
      --x2c --x2t --x2d --x2n --x2j       --x2p --x2m
      --p2c --p2t --p2d --p2n --p2j --p2x       --p2m
    The letters c t d n j x p m refer to formats CSV, TSV, DKVP, NIDX, JSON, XTAB,
    PPRINT, and markdown, respectively. Note that markdown format is available for
    output only.
    
    Compressed-data options:
      --prepipe {command} This allows Miller to handle compressed inputs. You can do
      without this for single input files, e.g. "gunzip < myfile.csv.gz | mlr ...".
      However, when multiple input files are present, between-file separations are
      lost; also, the FILENAME variable doesn't iterate. Using --prepipe you can
      specify an action to be taken on each input file. This pre-pipe command must
      be able to read from standard input; it will be invoked with
        {command} < {filename}.
      Examples:
        mlr --prepipe 'gunzip'
        mlr --prepipe 'zcat -cf'
        mlr --prepipe 'xz -cd'
        mlr --prepipe cat
      Note that this feature is quite general and is not limited to decompression
      utilities. You can use it to apply per-file filters of your choice.
      For output compression (or other) utilities, simply pipe the output:
        mlr ... | {your compression command}
    
    Separator options, for input, output, or both:
      --rs     --irs     --ors              Record separators, e.g. 'lf' or '\r\n'
      --fs     --ifs     --ofs  --repifs    Field separators, e.g. comma
      --ps     --ips     --ops              Pair separators, e.g. equals sign
    
      Notes about line endings:
      * Default line endings (--irs and --ors) are "auto" which means autodetect from
        the input file format, as long as the input file(s) have lines ending in either
        LF (also known as linefeed, '\n', 0x0a, Unix-style) or CRLF (also known as
        carriage-return/linefeed pairs, '\r\n', 0x0d 0x0a, Windows style).
      * If both irs and ors are auto (which is the default) then LF input will lead to LF
        output and CRLF input will lead to CRLF output, regardless of the platform you're
        running on.
      * The line-ending autodetector triggers on the first line ending detected in the input
        stream. E.g. if you specify a CRLF-terminated file on the command line followed by an
        LF-terminated file then autodetected line endings will be CRLF.
      * If you use --ors {something else} with (default or explicitly specified) --irs auto
        then line endings are autodetected on input and set to what you specify on output.
      * If you use --irs {something else} with (default or explicitly specified) --ors auto
        then the output line endings used are LF on Unix/Linux/BSD/MacOSX, and CRLF on Windows.
    
      Notes about all other separators:
      * IPS/OPS are only used for DKVP and XTAB formats, since only in these formats
        do key-value pairs appear juxtaposed.
      * IRS/ORS are ignored for XTAB format. Nominally IFS and OFS are newlines;
        XTAB records are separated by two or more consecutive IFS/OFS -- i.e.
        a blank line. Everything above about --irs/--ors/--rs auto becomes --ifs/--ofs/--fs
        auto for XTAB format. (XTAB's default IFS/OFS are "auto".)
      * OFS must be single-character for PPRINT format. This is because it is used
        with repetition for alignment; multi-character separators would make
        alignment impossible.
      * OPS may be multi-character for XTAB format, in which case alignment is
        disabled.
      * TSV is simply CSV using tab as field separator ("--fs tab").
      * FS/PS are ignored for markdown format; RS is used.
      * All FS and PS options are ignored for JSON format, since they are not relevant
        to the JSON format.
      * You can specify separators in any of the following ways, shown by example:
        - Type them out, quoting as necessary for shell escapes, e.g.
          "--fs '|' --ips :"
        - C-style escape sequences, e.g. "--rs '\r\n' --fs '\t'".
        - To avoid backslashing, you can use any of the following names:
          cr crcr newline lf lflf crlf crlfcrlf tab space comma pipe slash colon semicolon equals
      * Default separators by format:
          File format  RS       FS       PS
          dkvp         auto     ,        =
          json         auto     (N/A)    (N/A)
          nidx         auto     space    (N/A)
          csv          auto     ,        (N/A)
          csvlite      auto     ,        (N/A)
          markdown     auto     (N/A)    (N/A)
          pprint       auto     space    (N/A)
          xtab         (N/A)    auto     space
    
    Relevant to CSV/CSV-lite input only:
      --implicit-csv-header Use 1,2,3,... as field labels, rather than from line 1
                         of input files. Tip: combine with "label" to recreate
                         missing headers.
      --headerless-csv-output   Print only CSV data lines.
    
    Double-quoting for CSV output:
      --quote-all        Wrap all fields in double quotes
      --quote-none       Do not wrap any fields in double quotes, even if they have
                         OFS or ORS in them
      --quote-minimal    Wrap fields in double quotes only if they have OFS or ORS
                         in them (default)
      --quote-numeric    Wrap fields in double quotes only if they have numbers
                         in them
      --quote-original   Wrap fields in double quotes if and only if they were
                         quoted on input. This isn't sticky for computed fields:
                         e.g. if fields a and b were quoted on input and you do
                         "put '$c = $a . $b'" then field c won't inherit a or b's
                         was-quoted-on-input flag.
    
    Numerical formatting:
      --ofmt {format}    E.g. %.18lf, %.0lf. Please use sprintf-style codes for
                         double-precision. Applies to verbs which compute new
                         values, e.g. put, stats1, stats2. See also the fmtnum
                         function within mlr put (mlr --help-all-functions).
                         Defaults to %lf.
    
    Other options:
      --seed {n} with n of the form 12345678 or 0xcafefeed. For put/filter
                         urand()/urandint()/urand32().
      --nr-progress-mod {m}, with m a positive integer: print filename and record
                         count to stderr every m input records.
      --from {filename}  Use this to specify an input file before the verb(s),
                         rather than after. May be used more than once. Example:
                         "mlr --from a.dat --from b.dat cat" is the same as
                         "mlr cat a.dat b.dat".
      -n                 Process no input files, nor standard input either. Useful
                         for mlr put with begin/end statements only. (Same as --from
                         /dev/null.) Also useful in "mlr -n put -v '...'" for
                         analyzing abstract syntax trees (if that's your thing).
      -I                 Process files in-place. For each file name on the command
                         line, output is written to a temp file in the same
                         directory, which is then renamed over the original. Each
                         file is processed in isolation: if the output format is
                         CSV, CSV headers will be present in each output file;
                         statistics are only over each file's own records; and so on.
    
    Then-chaining:
    Output of one verb may be chained as input to another using "then", e.g.
      mlr stats1 -a min,mean,max -f flag,u,v -g color then sort -f color
    
    For more information please see http://johnkerl.org/miller/doc and/or
    http://github.com/johnkerl/miller. This is Miller version 5.1.0.


## `csvtk`

---


```python
!csvtk
```

    A cross-platform, efficient and practical CSV/TSV toolkit
    
    Version: 0.7.1
    
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
    
    Usage:
      csvtk [command]
    
    Available Commands:
      csv2md      convert CSV to markdown format
      csv2tab     convert CSV to tabular format
      cut         select parts of fields
      filter      filter rows by values of selected fields with artithmetic expression
      filter2     filter rows by awk-like artithmetic/string expressions
      freq        frequencies of selected fields
      grep        grep data by selected fields with patterns/regular expressions
      head        print first N records
      headers     print headers
      help        Help about any command
      inter       intersection of multiple files
      join        join multiple CSV files by selected fields
      mutate      create new column from selected fields by regular expression
      plot        plot common figures
      pretty      convert CSV to readable aligned table
      rename      rename column names
      rename2     rename column names by regular expression
      replace     replace data of selected fields by regular expression
      sample      sampling by proportion
      sort        sort by selected fields
      space2tab   convert space delimited format to CSV
      stats       summary of CSV file
      stats2      summary of selected digital fields
      tab2csv     convert tabular format to CSV
      transpose   transpose CSV data
      uniq        unique data without sorting
      version     print version information and check for update
    
    Flags:
      -c, --chunk-size int         chunk size of CSV reader (default 50)
      -C, --comment-char string    lines starting with commment-character will be ignored. if your header row starts with '#', please assign "-C" another rare symbol, e.g. '$' (default "#")
      -d, --delimiter string       delimiting character of the input CSV file (default ",")
      -l, --lazy-quotes            if given, a quote may appear in an unquoted field and a non-doubled quote may appear in a quoted field
      -H, --no-header-row          specifies that the input CSV file does not have header row
      -j, --num-cpus int           number of CPUs to use (default value depends on your computer) (default 8)
      -D, --out-delimiter string   delimiting character of the output CSV file (default ",")
      -o, --out-file string        out file ("-" for stdout, suffix .gz for gzipped out) (default "-")
      -T, --out-tabs               specifies that the output is delimited with tabs. Overrides "-D"
      -t, --tabs                   specifies that the input CSV file is delimited with tabs. Overrides "-d"
    
    Use "csvtk [command] --help" for more information about a command.


## `xsv`

---


```python
!xsv
```

    xsv is a suite of CSV command line utilities.
    
    Please choose one of the following commands:
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
    

