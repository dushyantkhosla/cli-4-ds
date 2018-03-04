## CLI tools for Data Science

- Use the `docker/` folder to build an image that contains the following tools

  - **GNU Coreutils** (sed, awk, grep ...)
    - [awk](https://www.gnu.org/software/gawk/manual/gawk.html) is a _programming language_ designed for text processing and typically used as a data extraction and reporting tool
  - **GNU Datamash**, a command-line program which performs basic numeric,textual and statistical operations on input textual data files.
  - **xsv**, A fast CSV toolkit written in Rust. [repo](https://github.com/BurntSushi/xsv), [installation](https://github.com/BurntSushi/xsv/releases/latest)
  - **csvkit** is a suite of command-line tools for converting to and working with CSV. Written in Python. [docs](http://csvkit.readthedocs.io/en/1.0.2/)
  - **Miller** Miller is like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON. Written in C. [repo](https://github.com/johnkerl/miller), [docs](http://johnkerl.org/miller/doc/)
  - **csvtk** A cross-platform, efficient, practical and pretty CSV/TSV toolkit in Golang. [docs](http://bioinf.shenwei.me/csvtk/)
  - **textql** Execute SQL against structured text like CSV or TSV. Written in Golang. [repo](https://github.com/dinedal/textql)
    - SQLlite-like [datetime](https://www.sqlite.org/lang_datefunc.html) support!
  - **q** allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files).  [install](http://harelba.github.io/q/examples.html), [tutorial](http://harelba.github.io/q/tutorial.html)

- Also contains

  - Miniconda3
  - A conda environment `ds-py3` configured with the PyData stack (`pandas`, `scikit-learn` ...)

- Build the docker image like so

```
cd docker/
docker build -t cli4ds .
```

- Run a container with the image

```
docker run -it -v $(pwd):/home -p 8888:8888 -p 5000:5000 -p 3128:3128 cli4ds
```

- Learn how to use these tools using the notebooks in `tutorials/`
- Run the `start.sh` script to see helpful messages

## Get the Data

- To generate data for these tutorials, `cd` into the `data/` directory and
  - Run the `get-csvs.sh` script to download `flightDelays` and `KDDCup` datasets
    - PS: This will download ~1.5GB data
  - Run the `make-data.py` to create a synthetic dataset with 10 million rows

## SQL Analytics with Metabase

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
