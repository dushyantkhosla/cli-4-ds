# Working with Files Larger Than RAM

[TOC]

## Start here

- [Overview of tools](https://www.youtube.com/watch?v=RTiAMB2tQjo)
- [When to use Unix tools, Dask, Spark](http://slides.com/israelsaetaperez/distributed-computing-spark-dask/embed)

---
<br>

## 1. Break large flat file into many smaller files

- works well for time-series data
- allows for parallel processing

### Links

- Example on splitting a [large file](http://dsnotes.com/post/2017-02-07-large-data-feature-hashing-and-online-learning-part-2/)

---
<br>

## 2. Read file with `chunksize` and push to a DB

- Work entirely in Pandas
- Never hold more than, say 200MB in RAM
- Apply functions 
    - Clean     -    outliers and missing values 
    - Compress  -    use appropriate dtypes
    - Transform -    create or drop columns 
- Load file into a DB and query it
    - SQLite or PostgreSQL
    - HDF5store (Pytables)

### Links

- [The SO post that started it all, see for HDF5 workflow](http://stackoverflow.com/questions/14262433/large-data-work-flows-using-pandas)
- [Pandas + SQLite](https://plot.ly/python/big-data-analytics-with-pandas-and-sqlite/) 
- [Another SQLite](http://pythondata.com/working-large-csv-files-python/)
- [And another, with good advice on compression](http://sdsawtelle.github.io/blog/output/large-data-files-pandas-sqlite.html)
- [SQLite vs. MySQL vs. PostgreSQL](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)

---
<br>

## 3. Use `Dask`


> light-weight framework for working with chunked arrays or dataframes across a variety of computational backends. 

> If you’re running into memory issues or CPU boundaries on a single machine when using Pandas, NumPy, or other computations with Python, Dask can help you scale up on all of the cores on a single machine. 
Dask works well on a single machine to make use of all of the cores on your laptop and process larger-than-memory data

- Doesn't load the data into memory until you ask for an answer with `.compute()`
- the approach used here will straightforwardly scale to even larger datasets analyzed across multiple machines
- Useful, but for the long term a DB would be better


### Links

- [THE dask tutorial in .ipynb files](https://github.com/dask/dask-tutorial)
- [Read the Docs!](http://dask.pydata.org/en/latest/index.html)
- Dask [DataFrames](http://dask.pydata.org/en/latest/dataframe-overview.html) and [Machine Learning](http://dask.pydata.org/en/latest/machine-learning.html)
- [Simple Example](http://stackoverflow.com/questions/37979167/how-to-parallelize-many-fuzzy-string-comparisons-using-apply-in-pandas)
- [Example with 7.5GB NYC 311 Service Requests Data](http://pythondata.com/dask-large-csv-python/)
- [Jake VDP](https://jakevdp.github.io/blog/2015/08/14/out-of-core-dataframes-in-python/)
- [Dask on Single Machines, Clusters -- Continuum Anaytics](https://www.continuum.io/blog/developer-blog/high-performance-hadoop-anaconda-and-dask-your-cluster)
- [Distributed Pandas on a Cluster with Dask DataFrames](http://matthewrocklin.com/blog/work/2017/01/12/dask-dataframes)


---
<br>

## 4. Use `Spark`




- a
- b
- c














---


### Spark vs. Dask

<br>

> Apache Spark is an all-inclusive framework combining distributed computing, SQL queries, machine learning, and more that runs on the JVM and is commonly co-deployed with other Big Data frameworks like Hadoop. It was originally optimized for bulk data ingest and querying common in data engineering and business analytics but has since broadened out. Spark is typically used on small to medium sized cluster but also runs well on a single machine.

---

> Dask is a **parallel programming library** that combines with the Numeric Python ecosystem to **provides parallel arrays, dataframes**, machine learning, and custom algorithms. It is based on Python and the foundational C/Fortran stack. Dask was originally designed to complement other libraries with parallelism, particular for numeric computing and advanced analytics, but has since broadened out. Dask is **typically used on a single machine**, but also runs well on a distributed cluster.

> Dask is **smaller, lighter weight** than Spark. This means that it has **fewer features** and instead is intended to be **used in conjunction 
with other libraries** like Numpy and Pandas



For more, see [this](http://dask.pydata.org/en/latest/spark.html)

<br>
---

# Blaze


- [slides](http://chdoig.github.io/ep2015-blaze/#/)
- [tutorial](https://github.com/blaze/blaze-tutorial)
- [Read the Docs](http://blaze.readthedocs.io/en/latest/index.html)
- [Projects](http://blaze.pydata.org/pages/projects/)
- [Example - Pandas code vs. Blaze code](https://statcompute.wordpress.com/2015/03/27/a-comparison-between-blaze-and-pandas/)


---
