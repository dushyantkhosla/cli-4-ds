## CLI tools for Data Science

- Use the `docker/` folder to build an image that contains the following tools

  - **GNU Coreutils** (sed, awk, grep ...)
    - [awk](https://www.gnu.org/software/gawk/manual/gawk.html) is a _programming language_ designed for text processing and typically used as a data extraction and reporting tool
  - **GNU Datamash**, a command-line program which performs basic numeric,textual and statistical operations on input textual data files.
  - **xsv**, A fast CSV toolkit written in Rust.
    - [repo](https://github.com/BurntSushi/xsv)
    - [installation](https://github.com/BurntSushi/xsv/releases/latest)
  - **csvkit** is a suite of command-line tools for converting to and working with CSV. Written in Python
    - [docs](http://csvkit.readthedocs.io/en/1.0.2/)
  - **Miller** Miller is like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON. Written in C
    - [repo](https://github.com/johnkerl/miller),
    - [docs](http://johnkerl.org/miller/doc/)
  - **csvtk** A cross-platform, efficient, practical and pretty CSV/TSV toolkit in Golang
    - [docs](http://bioinf.shenwei.me/csvtk/)
  - **textql** Execute SQL against structured text like CSV or TSV. Written in Golang
    - [repo](https://github.com/dinedal/textql)
    - SQLlite-like [datetime](https://www.sqlite.org/lang_datefunc.html) support!
  - **q** allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files).
    - [install](http://harelba.github.io/q/examples.html),
    - [tutorial](http://harelba.github.io/q/tutorial.html)

- Also contains

  - Miniconda3
  - A conda environment configured with the PyData stack (pandas, scikit-learn ...)

- Learn how to use these tools using the notebooks in `tutorials/`

- To generate data for these tutorials, run the `get-csvs.sh` script in `data/`
  - Instructions displayed when the container starts
  - PS: This will download ~1.5GB data
