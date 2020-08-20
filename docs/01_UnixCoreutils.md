# GNU Coreutils

These constitute one of most useful of all [GNU Packages](https://en.wikipedia.org/wiki/List_of_GNU_packages) that are a intergral part of the daily work of millions of programmers/scientists. <br>(Other well known packages include `grep`, `screen`, `gzip`, `tar`, `time` etc. Oh, and the `R` programming language.)

> "_The GNU Core Utilities are the basic file, shell and **text manipulation** utilities of the GNU operating system.These are the core utilities which are expected to **exist on every OS**._"

Examples include

|Manipulate|Utils
|---|---|
|files | `chgrp, chown, chmod, cp, dd, df, dir, du, ln, ls, mkdir, mkfifo, mknod, mv, rm` etc.
|text | `cat, cksum, head, tail, md5sum, nl, od, pr, tsort, join, wc, tac, paste` etc.
|shell | `basename, chroot, date, dirname, echo, env, groups, hostname, nice, nohup, printf, sleep` etc.


---

## Getting Help

Documentation is built-in, so whenever you can't remember something, look it up using 

```bash
COMMAND --help
# or
man COMMAND
```

---

## Know your system

```bash
# Kernel Info 
uname -a # all 
uname -r # exact

# Linux Version
lsb_release -a    # all
lsb_release -r    # exact
lsb_release -a -u # for derived distros like elementary

# HDD Partition Info
fdisk -l 
lsblk -o NAME,SIZE # human readable tree

# LOCALE
# List what locales currently defined for the current user 
locale

# if needed, generate missing locale and reconfigure
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales

# ENVIRONMENT VARIABLES
# list all active variables
env
# add a new variable to the list
EXPORT ENV_VAR=val

# PATH
# list the programs on the path
echo $PATH
# add optional binary to the end of the path
PATH=$PATH:~/opt/bin
# add something ot the beginning
PATH=~/opt/bin:$PATH

```

---

## Shortcuts

| | |
| --- | --- |
| `Ctrl + U` | Clears the line from the cursor point back to the beginning. |
| `Ctrl + A` | Moves the cursor to the beginning of the line. |
| `Ctrl + E` | Moves the cursor to the end of the line. |
| `Ctrl + R` | Allows you to search through the previous commands |

---

## Why Coreutils?


The basic tenet of UNIX philosophy is to 

>  _"create programs (or processes) that do one thing, and do that one thing well."_ <br><br>
It is a philosophy demanding careful thought about interfaces and ways of _joining these smaller (hopefully more simple) processes together to create useful results_. 

Normally text data flows between these interfaces. More advanced text processing tools and languages (like perl, python, and ruby) have been developed, which though very capable in their own right, **are not always available, especially in a production environment.**

These coreutils therefore become an indespensable tool in the data scientist's toolbox if he wants to build systems that work beyond his laptop.


---

### Common Util Options

- can appear in any order (recommended: `options` before `operands`)
- options can be long (begin with `--`) or abbreviated (begin wiht `-`)
- available to all programs (eg. `--help`, `--version`) 

> _Nearly every command invocation yields an integral **exit status** that can be used to change how other commands work. For the vast majority of commands, an exit status of **zero indicates success, nonzero indicates failure**._

Alright, enough talk, let's dive in. Like most things on the internet these days, our story begins with a ... 

---



## cat, tac

- Copies file/stdin to file/stdout (careful with large files!!)
- Useful in piping text to other programns, and to write output to files


```python
!cat --help
```

    Usage: cat [OPTION]... [FILE]...
    Concatenate FILE(s) to standard output.
    
    With no FILE, or when FILE is -, read standard input.
    
      -A, --show-all           equivalent to -vET
      -b, --number-nonblank    number nonempty output lines, overrides -n
      -e                       equivalent to -vE
      -E, --show-ends          display $ at end of each line
      -n, --number             number all output lines
      -s, --squeeze-blank      suppress repeated empty output lines
      -t                       equivalent to -vT
      -T, --show-tabs          display TAB characters as ^I
      -u                       (ignored)
      -v, --show-nonprinting   use ^ and M- notation, except for LFD and TAB
          --help     display this help and exit
          --version  output version information and exit
    
    Examples:
      cat f - g  Output f's contents, then standard input, then g's contents.
      cat        Copy standard input to standard output.
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/cat>
    or available locally via: info '(coreutils) cat invocation'



```python
%%writefile f01.txt
1 2 3
4 5 6

7 8 9


10 11 12
```

    Writing f01.txt



```python
# create an index
!cat -n f01.txt
```

         1	1 2 3
         2	4 5 6
         3	
         4	7 8 9
         5	
         6	
         7	10 11 12


```python
# create index for nonmissing
!cat -b f01.txt
```

         1	1 2 3
         2	4 5 6
    
         3	7 8 9


​    
​         4	10 11 12


```python
# squeeze multiple blank lines to 1
!cat -bs f01.txt
```

         1	1 2 3
         2	4 5 6
    
         3	7 8 9
    
         4	10 11 12


```python
# reverse rows
!tac f01.txt
```

    10 11 12
    
    7 8 9
    
    4 5 6
    1 2 3


## cat

** To append Structured Files **


- Concatenating files (same number of columns in the same order, no headers)

```bash
cat f1.csv f2.csv f3.csv > f1_f2_f3.csv
```
- Appending a file to an existing file using the `>>` operator, removing headers from subsequent files

```bash
cat f1.csv > concatenated.csv
cat f2.csv | sed "1 d" >> concatenated.csv
cat f3.csv | sed "1 d" >> concatenated.csv
```

- Create a new file with the last few records of an existing file

```bash
head -n 1 foo.csv > new_foo.csv
tail -n 9 foo.csv >> new_foo.csv
```



```python
# row binding
!seq 10 21 | paste -d, - - > f01.txt
!seq 80 89 | paste -d, - - > f02.txt`
!cat f01.txt f02.txt
```

    10,11
    12,13
    14,15
    16,17
    18,19
    20,21
    80,81
    82,83
    84,85
    86,87
    88,89


---

## nl

- add line numbers (generate and *index* like in `pandas`)
- see options with `nl --help`
  - `-s` to specify delimiter
  - `-b` to use regexs 

```bash
# for a csv
cat flights.csv | nl -s, | tail

# for a pipe-delimited file
cat sample_2.txt | nl -s'|' | tail
```

---

## head, tail

- display the first or last `n` rows (`n=10` by default) of a file (or many files)


```python
!head -n 3 flights.csv
```

    Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay
    2007,1,1,1,1232,1225,1341,1340,WN,2891,N351,69,75,54,1,7,SMF,ONT,389,4,11,0,,0,0,0,0,0,0
    2007,1,1,1,1918,1905,2043,2035,WN,462,N370,85,90,74,8,13,SMF,PDX,479,5,6,0,,0,0,0,0,0,0



```python
!tail -n 3 flights.csv
```

    2007,12,15,6,1024,1025,1750,1735,DL,61,N623DL,266,250,233,15,-1,LAX,ATL,1946,14,19,0,,0,0,0,15,0,0
    2007,12,15,6,1353,1315,1658,1622,DL,62,N970DL,125,127,100,36,38,DFW,ATL,732,11,14,0,,0,0,0,0,0,36
    2007,12,15,6,1824,1800,2001,1928,DL,63,N628DL,97,88,61,33,24,ATL,MCO,403,10,26,0,,0,24,0,9,0,0


---

## split

- creates output files containing consecutive or interleaved sections (1000 lines by default) of input
- files created are saved in the cd, named as PREFIXSUFFIX
    - PREFIX is supplied with the call
    - SUFFIX length is supplied (defaults to 2, so generates codes like `xaa, xab, xac` ...)


```python
!split --help
```

    Usage: split [OPTION]... [FILE [PREFIX]]
    Output pieces of FILE to PREFIXaa, PREFIXab, ...;
    default size is 1000 lines, and default PREFIX is 'x'.
    
    With no FILE, or when FILE is -, read standard input.
    
    Mandatory arguments to long options are mandatory for short options too.
      -a, --suffix-length=N   generate suffixes of length N (default 2)
          --additional-suffix=SUFFIX  append an additional SUFFIX to file names
      -b, --bytes=SIZE        put SIZE bytes per output file
      -C, --line-bytes=SIZE   put at most SIZE bytes of records per output file
      -d                      use numeric suffixes starting at 0, not alphabetic
          --numeric-suffixes[=FROM]  same as -d, but allow setting the start value
      -e, --elide-empty-files  do not generate empty output files with '-n'
          --filter=COMMAND    write to shell COMMAND; file name is $FILE
      -l, --lines=NUMBER      put NUMBER lines/records per output file
      -n, --number=CHUNKS     generate CHUNKS output files; see explanation below
      -t, --separator=SEP     use SEP instead of newline as the record separator;
                                '\0' (zero) specifies the NUL character
      -u, --unbuffered        immediately copy input to output with '-n r/...'
          --verbose           print a diagnostic just before each
                                output file is opened
          --help     display this help and exit
          --version  output version information and exit
    
    The SIZE argument is an integer and optional unit (example: 10K is 10*1024).
    Units are K,M,G,T,P,E,Z,Y (powers of 1024) or KB,MB,... (powers of 1000).
    
    CHUNKS may be:
      N       split into N files based on size of input
      K/N     output Kth of N to stdout
      l/N     split into N files without splitting lines/records
      l/K/N   output Kth of N to stdout without splitting lines/records
      r/N     like 'l' but use round robin distribution
      r/K/N   likewise but only output Kth of N to stdout
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/split>
    or available locally via: info '(coreutils) split invocation'



```python
!tail -n 1000 flights.csv > flights_1k.csv
```


```python
!split -n 3 flights_1k.csv
```


```python
ls | grep 'xa'
```

    xaa
    xab
    xac



```python
# provide prefix
!split -n 3 flights_1k.csv flights_1k_split_
```


```python
ls | grep 'split'
```

    flights_1k_split_aa
    flights_1k_split_ab
    flights_1k_split_ac



```python
# provide longer suffix if there are going to be many parts
! split -n 5 -a 4 flights_1k.csv Part_
```


```python
ls | grep '^Part_'
```

    Part_aaaa
    Part_aaab
    Part_aaac
    Part_aaad
    Part_aaae



```python
# Cleaning up
!ls | grep '_split_' | xargs rm
!ls | grep 'Part_' | xargs rm 
!ls | grep 'xa' | xargs rm
```

### csplit

- for _copy-till-you-see-this_ kind of splits


```python
!csplit --help
```

    Usage: csplit [OPTION]... FILE PATTERN...
    Output pieces of FILE separated by PATTERN(s) to files 'xx00', 'xx01', ...,
    and output byte counts of each piece to standard output.
    
    Read standard input if FILE is -
    
    Mandatory arguments to long options are mandatory for short options too.
      -b, --suffix-format=FORMAT  use sprintf FORMAT instead of %02d
      -f, --prefix=PREFIX        use PREFIX instead of 'xx'
      -k, --keep-files           do not remove output files on errors
          --suppress-matched     suppress the lines matching PATTERN
      -n, --digits=DIGITS        use specified number of digits instead of 2
      -s, --quiet, --silent      do not print counts of output file sizes
      -z, --elide-empty-files    remove empty output files
          --help     display this help and exit
          --version  output version information and exit
    
    Each PATTERN may be:
      INTEGER            copy up to but not including specified line number
      /REGEXP/[OFFSET]   copy up to but not including a matching line
      %REGEXP%[OFFSET]   skip to, but not including a matching line
      {INTEGER}          repeat the previous pattern specified number of times
      {*}                repeat the previous pattern as many times as possible
    
    A line OFFSET is a required '+' or '-' followed by a positive integer.
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/csplit>
    or available locally via: info '(coreutils) csplit invocation'


---

## wc

- counts the Number of bytes, characters, whitespace-separated words, and newlines


```python
!wc --help
```

    Usage: wc [OPTION]... [FILE]...
      or:  wc [OPTION]... --files0-from=F
    Print newline, word, and byte counts for each FILE, and a total line if
    more than one FILE is specified.  A word is a non-zero-length sequence of
    characters delimited by white space.
    
    With no FILE, or when FILE is -, read standard input.
    
    The options below may be used to select which counts are printed, always in
    the following order: newline, word, character, byte, maximum line length.
      -c, --bytes            print the byte counts
      -m, --chars            print the character counts
      -l, --lines            print the newline counts
          --files0-from=F    read input from the files specified by
                               NUL-terminated names in file F;
                               If F is - then read names from standard input
      -L, --max-line-length  print the maximum display width
      -w, --words            print the word counts
          --help     display this help and exit
          --version  output version information and exit
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/wc>
    or available locally via: info '(coreutils) wc invocation'



```python
# count and filename
!ls | grep csv | xargs wc -l
```

       7453216 flights.csv
            37 get-csvs.sh
       4898432 kdd.csv
      12351685 total



```python
run_on_bash('ls | grep csv | xargs wc -l')
```

       7453216 flights.csv
            37 get-csvs.sh
       4898432 kdd.csv
      12351685 total



## cut

- select columns by position (comma separated list or hyphenated ranges)


```bash
OPTIONS

-d, --delimiter=DELIM   use DELIM instead of TAB for field delimiter
-f, --fields=LIST       select only these fields
-s, --only-delimited    do not print lines not containing delimiters
    --output-delimiter=STRING  use STRING as the output delimiter
```


```python
!head -n 5 kdd.csv | cut -d, -f1-6,42 
```

    duration,protocol_type,service,flag,src_bytes,dst_bytes
    0,tcp,http,SF,215,45076,normal.
    0,tcp,http,SF,162,4528,normal.
    0,tcp,http,SF,236,1228,normal.
    0,tcp,http,SF,233,2032,normal.



```python
run_on_bash('head -n 5 flights.csv | cut -d, -f9-10,15-18 | csvlook')
```

    | UniqueCarrier | FlightNum | ArrDelay | DepDelay | Origin | Dest |
    | ------------- | --------- | -------- | -------- | ------ | ---- |
    | WN            |     2,891 |        1 |        7 | SMF    | ONT  |
    | WN            |       462 |        8 |       13 | SMF    | PDX  |
    | WN            |     1,229 |       34 |       36 | SMF    | PDX  |
    | WN            |     1,355 |       26 |       30 | SMF    | PDX  |



---

## sort

`sort` is quite versatile, and can be used to sort, sort & merge, randomize, and, deduplicate files.


- Useful `sort` options <br>
    - case insensitive with `-f`
    - numbers with `-n`
    - descending order with `-r`
    - if lines have leading blanks `-b`
    - sort by values in column 5 .... `-k5` (use `-t` for delimiter here)
    - sort in random order with `-R`
    - merge (sorted) multiple files with `-m`
    - remove dups with `-u`
    
> Note <br> when using `-k` the syntax is `-km,n` where `m` is the starting key and `n` is the ending key. <br> If the sorting is on the 5th field alone (for ex.), we speciy `-k5,5`  <br><br> Environment variables such as LC_ALL, LC_COLLATE, or LANG can affect the output of sort and other commands. 

**Example**<br> To sort a csv file numerically on the 2nd field in reverse order we'd use

```bash
sort -t"," -k2nr,2 file
```

More examples [here](https://www.gnu.org/software/coreutils/manual/coreutils.html#Operating-on-sorted-files)

### Sorting Large Files

> _The sort that you find on Linux comes from the coreutils package and implements an External R-Way merge. It splits up the data into chunks that it can handle in memory, stores them on disc and then merges them. The chunks are done in parallel, if the machine has the processors for that. So if there was to be a limit, it is the free disc space that sort can use to store the temporary files it has to merge, combined with the result._
[source](https://unix.stackexchange.com/questions/279096/scalability-of-sort-u-for-gigantic-files)


```python
!sort --help
```

    Usage: sort [OPTION]... [FILE]...
      or:  sort [OPTION]... --files0-from=F
    Write sorted concatenation of all FILE(s) to standard output.
    
    With no FILE, or when FILE is -, read standard input.
    
    Mandatory arguments to long options are mandatory for short options too.
    Ordering options:
    
      -b, --ignore-leading-blanks  ignore leading blanks
      -d, --dictionary-order      consider only blanks and alphanumeric characters
      -f, --ignore-case           fold lower case to upper case characters
      -g, --general-numeric-sort  compare according to general numerical value
      -i, --ignore-nonprinting    consider only printable characters
      -M, --month-sort            compare (unknown) < 'JAN' < ... < 'DEC'
      -h, --human-numeric-sort    compare human readable numbers (e.g., 2K 1G)
      -n, --numeric-sort          compare according to string numerical value
      -R, --random-sort           shuffle, but group identical keys.  See shuf(1)
          --random-source=FILE    get random bytes from FILE
      -r, --reverse               reverse the result of comparisons
          --sort=WORD             sort according to WORD:
                                    general-numeric -g, human-numeric -h, month -M,
                                    numeric -n, random -R, version -V
      -V, --version-sort          natural sort of (version) numbers within text
    
    Other options:
    
          --batch-size=NMERGE   merge at most NMERGE inputs at once;
                                for more use temp files
      -c, --check, --check=diagnose-first  check for sorted input; do not sort
      -C, --check=quiet, --check=silent  like -c, but do not report first bad line
          --compress-program=PROG  compress temporaries with PROG;
                                  decompress them with PROG -d
          --debug               annotate the part of the line used to sort,
                                  and warn about questionable usage to stderr
          --files0-from=F       read input from the files specified by
                                NUL-terminated names in file F;
                                If F is - then read names from standard input
      -k, --key=KEYDEF          sort via a key; KEYDEF gives location and type
      -m, --merge               merge already sorted files; do not sort
      -o, --output=FILE         write result to FILE instead of standard output
      -s, --stable              stabilize sort by disabling last-resort comparison
      -S, --buffer-size=SIZE    use SIZE for main memory buffer
      -t, --field-separator=SEP  use SEP instead of non-blank to blank transition
      -T, --temporary-directory=DIR  use DIR for temporaries, not $TMPDIR or /tmp;
                                  multiple options specify multiple directories
          --parallel=N          change the number of sorts run concurrently to N
      -u, --unique              with -c, check for strict ordering;
                                  without -c, output only the first of an equal run
      -z, --zero-terminated     line delimiter is NUL, not newline
          --help     display this help and exit
          --version  output version information and exit
    
    KEYDEF is F[.C][OPTS][,F[.C][OPTS]] for start and stop position, where F is a
    field number and C a character position in the field; both are origin 1, and
    the stop position defaults to the line's end.  If neither -t nor -b is in
    effect, characters in a field are counted from the beginning of the preceding
    whitespace.  OPTS is one or more single-letter ordering options [bdfgiMhnRrV],
    which override global ordering options for that key.  If no key is given, use
    the entire line as the key.  Use --debug to diagnose incorrect key usage.
    
    SIZE may be followed by the following multiplicative suffixes:
    % 1% of memory, b 1, K 1024 (default), and so on for M, G, T, P, E, Z, Y.
    
    *** WARNING ***
    The locale specified by the environment affects sort order.
    Set LC_ALL=C to get the traditional sort order that uses
    native byte values.
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/sort>
    or available locally via: info '(coreutils) sort invocation'



```python
# sort listing of all files in a directory by their size (human-readable)
!ls -lh | sort -k5,5 -h -r
```

    -rw------- 1 root root 709M Mar  4 01:00 kddcup.data
    -rw------- 1 root root 671M Mar  4 01:05 flights.csv
    -rw-r--r-- 1 root root  94K Mar  4 01:26 flights_1k.csv
    -rw-r--r-- 1 root root 1.3K Mar  4 01:13 kddcup-names
    -rw-r--r-- 1 root root 1.2K Mar  4 01:01 get-csvs.sh
    total 1.4G



```python
# top 10 durations in the kdd data
# Note
# sed '1d' removes the header
# cut is for retaining the first few columns
!cat kddcup.data | sed '1d' | sort -nr -k1,1 | cut -d, -f1-6 | head
```

    58329,udp,domain_u,SF,42,44
    42908,tcp,private,RSTR,1,0
    42888,tcp,private,RSTR,1,0
    42862,tcp,private,RSTR,1,0
    42837,tcp,private,RSTR,1,0
    42804,tcp,private,RSTR,1,0
    42778,tcp,private,RSTR,1,0
    42746,tcp,echo,RSTR,1,0
    42723,tcp,private,RSTR,1,0
    42699,tcp,discard,RSTR,1,0
    cut: write error: Broken pipe


> `sort` has a `-u` flag that removes duplicate rows so a sorted listing of unique rows is produced.<br><br> **Note** <br>The commands sort -u and sort | uniq are equivalent, but this equivalence does not extend to arbitrary sort options. For example, sort -n -u inspects only the value of the initial numeric string when checking for uniqueness, whereas sort -n | uniq inspects the entire line. 



---

## `shuf`

- useful for **permutations** and **random sampling**
- with or without **replacement** (_bootstrapped_ samples, anyone?)


```python
!shuf --help
```

    Usage: shuf [OPTION]... [FILE]
      or:  shuf -e [OPTION]... [ARG]...
      or:  shuf -i LO-HI [OPTION]...
    Write a random permutation of the input lines to standard output.
    
    With no FILE, or when FILE is -, read standard input.
    
    Mandatory arguments to long options are mandatory for short options too.
      -e, --echo                treat each ARG as an input line
      -i, --input-range=LO-HI   treat each number LO through HI as an input line
      -n, --head-count=COUNT    output at most COUNT lines
      -o, --output=FILE         write result to FILE instead of standard output
          --random-source=FILE  get random bytes from FILE
      -r, --repeat              output lines can be repeated
      -z, --zero-terminated     line delimiter is NUL, not newline
          --help     display this help and exit
          --version  output version information and exit
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/shuf>
    or available locally via: info '(coreutils) shuf invocation'



```python
# without replacement
!shuf -i1-9 -n 5
```

    8
    9
    5
    2
    3



```python
# Simulate a coin flip (with replacement)
!shuf -i0-1 -r -n 10  
```

    0
    1
    0
    1
    0
    0
    1
    1
    0
    1



```python
# random sample from a file
!cat kddcup.data | cut -d, -f1-6 | sed '1d' | shuf -n 5
```

    0,icmp,ecr_i,SF,1032,0
    0,icmp,ecr_i,SF,1032,0
    0,icmp,ecr_i,SF,1032,0
    0,icmp,ecr_i,SF,1032,0
    0,icmp,ecr_i,SF,1032,0


## uniq

- typically used to uniquely list lines from an input source
- find/remove duplicate rows in a file
- frequency tables


```bash
OPTIONS

-u, --unique          only print unique lines
-c, --count           prefix lines by the number of occurrences
-d, --repeated        only print duplicate lines, one for each group

-D                    print all duplicate lines
    --all-repeated[=METHOD]  like -D, but allow separating groups with an empty line;
                             METHOD={none(default),prepend,separate}
```

> To operate properly, duplicate lines must be contiguously positioned in the input. 
<br> So, normally the **input** to the `uniq` command **is first sorted.**


```python
# number of uniuqe rows for columns 1-6, 42 in the kdd data
!cat kddcup.data | sed '1d' | cut -d, -f1-6,42 | sort | uniq -u | wc -l
```

    198175



```python
# these rows have duplicates
!cat kddcup.data | sed '1d' | cut -d, -f3-6,42 | sort | uniq -d | head
```

    IRC,RSTO,0,0,normal.
    IRC,RSTR,1010,6365,normal.
    IRC,RSTR,4420,7766,normal.
    IRC,RSTR,62,116,normal.
    IRC,RSTR,73,16,normal.
    IRC,RSTR,76,18,normal.
    IRC,RSTR,77,18,normal.
    IRC,S1,0,0,normal.
    IRC,SF,66,17,normal.
    IRC,SF,66,18,normal.
    uniq: write error: Broken pipe



```python
# frequency table
!cat kddcup.data | sed '1d' | cut -d, -f42 | sort | uniq -c | sort -nr | head -n 5
```

    2807886 smurf.
    1072017 neptune.
     972780 normal.
      15892 satan.
      12481 ipsweep.



```python
# most number of flights?
!cat flights.csv | sed '1d' | cut -d, -f9,17-18 | sort | uniq -c | sort -nr | head -n 5
```

       9658 WN,HOU,DAL
       9631 WN,DAL,HOU
       7496 WN,LAX,OAK
       7467 WN,OAK,LAX
       7339 HA,OGG,HNL
    sort: write failed: standard output: Broken pipe
    sort: write error


## comm

- for comparing sorted files FILE1 and FILE2 line by line.
- With no options, produce three-column output.  
    - Column one contains lines unique to FILE1, 
    - column two contains lines unique to FILE2,
    - and column three contains lines common to both files.

```bash 
OPTIONS

  -1              suppress column 1 (lines unique to FILE1)
  -2              suppress column 2 (lines unique to FILE2)
  -3              suppress column 3 (lines that appear in both files)
  
EXAMPLES

comm -12 file1 file2  
# Print only lines present in both file1 and file2.

comm -3 file1 file2  
# Print lines in file1 not in file2, and vice versa.    
```


```python
# pull a random sample of 10k rows
!shuf -n 10000 kddcup.data | sort > kdd_10k.csv
```


```python
# keep the first 7.5k rows as the train set
!head -n 7500 kdd_10k.csv | sort > kdd_10k_train.csv
```


```python
# keep the other 2.5k as the test set
!comm -3 kdd_10k.csv kdd_10k_train.csv | sort > kdd_10k_test.csv
```


```python
# check no. of rows
!ls | grep '_10k' | xargs wc -l
```

      10000 kdd_10k.csv
       2500 kdd_10k_test.csv
       7500 kdd_10k_train.csv
      20000 total



```python
# see if we made a mistake
!comm -12 kdd_10k_train.csv kdd_10k_test.csv | wc -l
```

    0



```python
# delete created files
!ls | grep '_10k' | xargs rm
```

---

## paste

- naive, brute force long-to-wide!
- concat files (column binding)


```python
!paste --help
```

    Usage: paste [OPTION]... [FILE]...
    Write lines consisting of the sequentially corresponding lines from
    each FILE, separated by TABs, to standard output.
    
    With no FILE, or when FILE is -, read standard input.
    
    Mandatory arguments to long options are mandatory for short options too.
      -d, --delimiters=LIST   reuse characters from LIST instead of TABs
      -s, --serial            paste one file at a time instead of in parallel
      -z, --zero-terminated    line delimiter is NUL, not newline
          --help     display this help and exit
          --version  output version information and exit
    
    GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
    Full documentation at: <http://www.gnu.org/software/coreutils/paste>
    or available locally via: info '(coreutils) paste invocation'



```python
# join consecutive lines into a csv
!shuf -i0-99 -rn 25 | paste -d, - - - - - 
```

    54,58,50,44,6
    25,67,88,11,52
    94,75,7,77,83
    95,56,82,46,44
    2,58,28,18,90



```python
# fold data any which way
!seq 12 | paste -d, - - | paste -d':' - - -
```

    1,2:3,4:5,6
    7,8:9,10:11,12



```python
# column binding!
!seq 10 21 | paste -d, - - > f01.txt
!seq 80 89 | paste -d, - - > f02.txt
!paste -d, f01.txt f02.txt
```

    10,11,80,81
    12,13,82,83
    14,15,84,85
    16,17,86,87
    18,19,88,89
    20,21,



```python
!paste -d, -s f01.txt f02.txt
```

    10,11,12,13,14,15,16,17,18,19,20,21
    80,81,82,83,84,85,86,87,88,89



```python
!rm f01.txt f02.txt
```


```python
ls -lh --block-size=MB .
```

    total 1446MB
    -rw------- 1 root root 703MB Mar  4 01:05 flights.csv
    -rw-r--r-- 1 root root   1MB Mar  4 01:26 flights_1k.csv
    -rw-r--r-- 1 root root   1MB Mar  4 01:01 get-csvs.sh
    -rw-r--r-- 1 root root   1MB Mar  4 01:13 kddcup-names
    -rw------- 1 root root 743MB Mar  4 01:00 kddcup.data


## [numfmt](https://www.gnu.org/software/coreutils/manual/html_node/numfmt-invocation.html#numfmt-invocation)

- numfmt reads numbers in various representations and reformats them as requested
-  numfmt can optionally extract numbers from specific columns, maintaining proper line padding and alignment.

## Formatting floating point numbers


```python
!head Sales.txt  | sed '1d' | cut -d'|' -f12-15 | tr ',' '.' | xargs -d'|' numfmt --format="%0.4f" | xargs -n4 | tr ' ' ',' | xsv table
```

    17.3224                  20.9600  9.9800   7.3424
    43.38017000000000000000  52.4900  35.8600  7.5202
    6.60331000000000000000   7.9900   5.2100   1.3934
    24.78512000000000000000  29.9900  12.2300  12.5552
    12.38843000000000000000  14.9900  6.3400   6.0485
    .94340000000000000000    1.0000   0.4800   0.4634
    2.22314000000000000000   2.6900   0.9400   1.2832
    10.70248000000000000000  12.9500  5.6000   5.1025
    3.29752000000000000000   3.9900   0.9300   2.3676



### Looping over files in Bash

```bash
for f in *; 
do  
# do something, for example
# wc -l "$f"
; 
done
```

---

# Also see

The **tee command** copies standard input to standard output and also to any files given as arguments. This is useful when you want not only to send some data down a pipe, but also to save a copy.
