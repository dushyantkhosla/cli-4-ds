```python
import os
os.chdir("/home/data/")
```


```python
import subprocess as sbp
import sqlite3

import pandas as pd
import numpy as np
```


```python
run_on_bash = lambda i: sbp.check_output("{}".format(i), shell=True).decode('utf-8')
```

## Download and Unzip Data
!wget 'http://www.catalogueoflife.org/DCA_Export/zip-fixed/2018-02-26-archive-complete.zip"'
!dtrx 2018-02-26-archive-complete.zip

```python
os.listdir(os.getcwd())
```




    ['.DS_Store',
     '.ipynb_checkpoints',
     '.notifier',
     'chinook.db',
     'clean-kdd.py',
     'flights.csv',
     'get-csvs.sh',
     'get-nyc-taxi.sh',
     'hsperfdata_metabase',
     'hsperfdata_root',
     'kdd.csv',
     'life.db',
     'make-data.py',
     'tutorial.db',
     'zen.txt']



## Check files


```python
FILES = filter(lambda i: 'txt' in i or 'csv' in i, os.listdir(os.getcwd()))
dict_files = {}

for file in FILES:
    rows_ = int(run_on_bash("wc -l {}".format(file)).split(" ")[0])
    size_ = os.path.getsize(file)/10**6
    dict_files[file] = {
        'rows': rows_,
        'size': size_
    }
    print("{:25} is {:10.2f} MB and has {:10.0f} rows".format(file, size_, rows_))
```

    flights.csv               is     702.88 MB and has    7453216 rows
    get-csvs.sh               is       0.00 MB and has         37 rows
    kdd.csv                   is     742.58 MB and has    4898432 rows
    zen.txt                   is       0.00 MB and has         21 rows


## Create DB, Connection, Cursor


```python
if os.path.exists("life.db"):
    print("Connecting to Existing DB")
    conn = sqlite3.connect("life.db")
else:
    print("Initialising new SQLite DB")
    conn = sqlite3.connect("life.db")
```

    Connecting to Existing DB



```python
curs = conn.cursor()
```

## Import files into DB with pandas


```python
for file in dict_files:
    """
    For each file, check its size in MB
    If smaller than 250, read directly
    If larger, read in chunks
    Load the file into the database (.db file)
    """
    if dict_files.get(file).get('size') < 250:
        print("{} is a small file. Importing directly.".format(file))
        df_ = pd.read_csv(
            file, 
            sep="\t",
            low_memory=False,
            error_bad_lines=False
        )
        df_.to_sql(
            name=file.replace(".txt", ''), 
            con=conn, 
            index=False,
            if_exists='append'
        )
        print("Done.")
    else:
        print("{} is large. Importing in chunks.".format(file))
        size = int(np.ceil(dict_files.get(file).get('rows')/10))
        chunks = pd.read_csv(
            file, 
            sep="\t", 
            chunksize=size, 
            error_bad_lines=False,
            low_memory=False
        )
        for c in chunks:
            c.to_sql(
                name=file.replace(".txt", ''), 
                con=conn, 
                index=False,
                if_exists='append'
            )
        print("Done")    
```

    description.txt is a small file. Importing directly.
    Done.
    distribution.txt is a small file. Importing directly.
    Done.
    reference.txt is large. Importing in chunks.
    Done
    speciesprofile.txt is a small file. Importing directly.
    Done.
    taxa.txt is large. Importing in chunks.
    Done
    vernacular.txt is a small file. Importing directly.
    Done.


## Check DB


```python
print("The database is {:.2f} MB in size".format(os.path.getsize('life.db')/10**6))
```

    The database is 2236.95 MB in size



```python
curs.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
```




    [('description',),
     ('distribution',),
     ('reference',),
     ('speciesprofile',),
     ('taxa',),
     ('vernacular',)]



## Run Queries


```python
pd.read_sql_query(
    sql="""
    SELECT genus, count(*) 
    FROM taxa
    WHERE isExtinct = 0.0
      AND genus IS NOT NULL
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
    """,
    con=conn
)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>genus</th>
      <th>count(*)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Hieracium</td>
      <td>6029</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Astragalus</td>
      <td>3375</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Puccinia</td>
      <td>3193</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Carabus</td>
      <td>3125</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Cortinarius</td>
      <td>3066</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Agrilus</td>
      <td>3034</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Carex</td>
      <td>2670</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Tipula</td>
      <td>2507</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Taraxacum</td>
      <td>2423</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Euphorbia</td>
      <td>2416</td>
    </tr>
  </tbody>
</table>
</div>



## If you make changes to the DB, save them


```python
conn.commit()
conn.close()
```

## Improve Speed With a New Index

If you know you will be pulling records according to the value of a certain column(s) very frequently, make a new index for your database on that column. 

In the example below, we're setting the `id` column as the new and assigning the name `id_idx` to it.


```python
curs.execute("CREATE INDEX id_idx ON data (id);")
conn.commit()
```
