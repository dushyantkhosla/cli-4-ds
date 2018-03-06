## Introduction

Say a you have a `.csv` file with a few columns. You have to run basic descriptive statistics on these columns, and maybe a few group-by operations (okay, pivot-tables.) If the file is a few thousand rows (under 100MB in size), you will probably double-click on it straight away and run the analysis in Excel.  

Give yourself a pat on the back, you chose the right tool for the right job.  

_Who's a good analyst? Yes, you are!_

But what if the file was 750MB? Assuming you have enough RAM (8GB or more), of course you'll use `dplyr` in R, or `pandas` in Python or (gasp) write a data step in `SAS`.  

_Right? Excellent._

But what if the file was 6GB?

15GB?

If the word `Hadoop` is stuck in your throat, I implore you to swallow it.
This repository focues on open-source command-line utilities that can do the same.

Yes, there are Python libraries that allow you to work with larger-than-RAM files on a single machine (`Spark`, `Dask` and perhaps some more), but we'll keep that for later.

## Why

- Because I've met too many 'data scientists' who
  - have a complete lack of awareness of the limits of their own hardware.
    - See [Don't use Hadoop - your data isn't that big](https://www.chrisstucchio.com/blog/2013/hadoop_hatred.html)
  - are forgetting Statistics! Sometimes you can fit a model on a (representative) _sample_ of data, and you might not need distributed ML.
    - See [Don't use deep learning your data isn't that big](https://simplystatistics.org/2017/05/31/deeplearning-vs-leekasso/)
    - Also see [learning curves](http://scikit-learn.org/stable/auto_examples/model_selection/plot_learning_curve.html)
- Because there is an entire ecosystem of wonderful open-source software for data analysis
- Because renting servers with more RAM or more cores is now easier and cheaper than ever.
- Because too many businesses do not have massive data and are spending money and resources trying to solve their problems with the wrong (and expensive) tools
  - The closest analogy I can think of is someone trying to break a pebble with a sledgehammer. Of course, the pebble will break, but wouldn't you rather first try using the hammer hanging in your toolshed?  
- But mostly, because I like to teach! 😇

## Some Quotes

> "At Facebook, 90% of the jobs have input sizes under 100GB."

> "For workloads that process multi-GB rather than multi-TB, a big memory server will provide better performance-per-dollar than a cluster."

## Tools

  - [GNU Coreutils](https://www.gnu.org/software/coreutils/manual/coreutils.html) everyday tools like `grep`, `sed`, `cut`, `shuf` and `cat` for working on text-files
  - [GNU awk](https://www.gnu.org/software/gawk/manual/gawk.html), a _programming language_ designed for text processing and typically used as a data extraction and reporting tool
  - [GNU Datamash](https://www.gnu.org/software/datamash/manual/html_node/Usage-Examples.html), a command-line program which performs basic numeric, textual and statistical operations on input textual data files.
  - [xsv](https://github.com/BurntSushi/xsv), a fast CSV toolkit written in Rust
  - [csvkit](http://csvkit.readthedocs.io/en/1.0.2/), a suite of command-line tools for converting to and working with CSV. Written in Python
  - [Miller](http://johnkerl.org/miller/doc/) is like awk, sed, cut, join, and sort for _name-indexed data_ such as CSV, TSV, and tabular JSON. Written in C.
  - [csvtk](http://bioinf.shenwei.me/csvtk/) A cross-platform, efficient, practical and pretty CSV/TSV toolkit in Golang.
  - [textql](https://github.com/dinedal/textql) Execute SQL against structured text like CSV or TSV. Written in Golang.
    - SQLlite-like [datetime](https://www.sqlite.org/lang_datefunc.html) support!
  - [q](http://harelba.github.io/q/examples.html) allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files)


## Docker Image

- I've created a Docker image with all of these tools, and tutorials on how to use them.
- It also contains
  - Miniconda3
  - A conda environment `ds-py3` configured with the PyData stack (`pandas`, `scikit-learn` ...)

- Build (or pull) the docker image

```
cd docker/
docker build -t cli-4-ds .
# or
docker pull dushyantkhosla/cli-4-ds:latest
```

- Run a container with the image

```
docker run -it --privileged \
           -v $(pwd):/home \
           -p 8888:8888 \
           -p 5000:5000 \
           -p 3128:3128 \
           dushyantkhosla/cli-4-ds:latest
```

- Learn how to use these tools using the notebooks in `tutorials/`
  - There is a dedicated notebook for each of the tools above

- Run the `start.sh` script to see helpful messages

```
bash /root/start.sh
```

## Get the Data

- To generate data for these tutorials, `cd` into the `data/` directory and
  - Run the `get-csvs.sh` script to download `flightDelays` and `KDDCup` datasets
  - PS: This will download ~1.5GB data

```
cd data/
bash get-csvs.sh
python make-data.py
```

  - Run the `make-data.py` to create a synthetic dataset with 10 million rows

## SQL Analytics with [Metabase](https://www.metabase.com/)

- You might want to try out `Metabase`, which has a nice front-end for writing SQL

```
docker pull metabase/metabase:v0.19.0
```
  - I recommend this version against the latest because it works with SQLite
  - If you want to run other DBs like Postgresql, you can get the latest image instead

- Then, run a container

```
docker run -d -v $(pwd):/tmp -p 3000:3000 metabase/metabase:v0.19.0
```

- The `-d` switch is for running the container in _detached_ mode
- Navigate to `localhost:3000`, connect to a `.db` file or run another DB and connect to it

## Appendix

- There are no rules, of thumb; but we can try

Data Size|Remedy
---|---
up to 1GB | Pandas
up to 10GB | Get more RAM. Try Spark/Dask.
up to 100GB | Postgres
500GB+ | Hadoop

## TL;DR

As long as your data fits-on-disk (ie, a few hundred GBs or less,)

- For `filter` or `transform` jobs (like `WHERE` and `CASE WHEN`) , use
  - cli-tools or python scripts (line-by-line or stream processing)
  - break files into chunks, use pandas (chunk processing)

- For `reductions` or `groupby` jobs (like `AVERAGE` and `PIVOT`),
  - think deeply about your data, draw representative samples
    - _you're a better statistician than a programmer afterall, aren't you?_
  - use bootstrap measures to quantify uncertainty

- For `machine-learning` jobs,
  - Cluster your data, then pull samples from each group. (stratify)
  - Fit your first model on a 10% sample.
    - Build a Learning Curve.
    - Use cross-validated measures to quantify uncertainty


## Further Reading

- In a later post, I'd like to talk about extracting more juice out of your hardware with parallel-processing
  - For now, here's something to munch on http://randyzwitch.com/gnu-parallel-medium-data/
