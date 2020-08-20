```python
import os
os.chdir('/home/data/')

from time import time
```


```python
import numpy as np

import sqlite3
import pandas as pd

from sqlalchemy import create_engine
```

## Create an empty sqlite database file


```python
con = sqlite3.connect("sqlite.db")
```

## Create a _cursor_ object to interact with it


```python
cur = con.cursor()
```

---
# Loading Data into the Database

- This step might take a while if your CSV file is larger than a few GBs, 

- But the benefits outweigh the wait time;
    - you can use `pd.read_sql` tools to pull data from the database without worrying about memory constraints.
    - you can use tools like `Metabase` or any SQL editor to write aggregations and reductions on big data locally.  
    
    
- [Note] Avoid using `SELECT *` as it will load all data into memory. 

- Use `WHERE` statements and the `LIMIT` clause each time.

### Load NYC Taxi Data


```python
files = os.listdir("nyc-taxi/")
```


```python
def convert_types(COL):
    """
    If the passed COL is numeric,
    downcast it to the lowest size.
    Else,
    Return as-is.
    
    Parameters
    -----------
    COL: pandas.Series
        The Series to shrink
        
    Returns
    -------
    if numeric, a compressed series
    """
    if COL.dtype == np.int64:
        return pd.to_numeric(COL, downcast='integer', errors='ignore')
    elif COL.dtype == np.float64:
        return pd.to_numeric(COL, downcast='float', errors='ignore')
    else:
        return COL
```


```python
for f in files:
    """
    Read each csv in chunks
    For each chunk
        Compress
        Load into DB
    """
    t0 = time()
    print("Reading {}".format(f))
    
    f_chunks = pd.read_csv(
        "nyc-taxi/" + f, 
        chunksize=10**6, 
        error_bad_lines=False,
        parse_dates=['tpep_pickup_datetime', 'tpep_dropoff_datetime']
    )

    for chunk in f_chunks:
        """
        Fill the table by reading a large text file in chunks.
        Each chunk is just a pandas DataFrame
        Filter/transform the data as needed here.
        """
        (chunk
         .apply(convert_types)
         .to_sql(
            name='nyc_taxi', 
            con=con, 
            if_exists='append',
            index=False)
        )
    print("Loading into db finished in {} seconds.".format(time()-t0))
```

    Reading yellow_tripdata_2017-11.csv
    Loading into db finished in 169.0669174194336 seconds.
    Reading yellow_tripdata_2017-08.csv
    Loading into db finished in 154.18128442764282 seconds.
    Reading yellow_tripdata_2017-01.csv
    Loading into db finished in 176.58778619766235 seconds.
    Reading yellow_tripdata_2017-10.csv
    Loading into db finished in 183.2636420726776 seconds.
    Reading yellow_tripdata_2017-03.csv
    Loading into db finished in 186.8081409931183 seconds.
    Reading yellow_tripdata_2017-02.csv
    Loading into db finished in 164.89169430732727 seconds.
    Reading yellow_tripdata_2017-09.csv
    Loading into db finished in 161.81028938293457 seconds.
    Reading yellow_tripdata_2017-06.csv
    Loading into db finished in 175.87790322303772 seconds.
    Reading yellow_tripdata_2017-04.csv
    Loading into db finished in 181.84538388252258 seconds.
    Reading yellow_tripdata_2017-12.csv
    Loading into db finished in 174.8419873714447 seconds.
    Reading yellow_tripdata_2017-05.csv
    Loading into db finished in 183.7002031803131 seconds.
    Reading yellow_tripdata_2017-07.csv
    Loading into db finished in 156.459303855896 seconds.


---
## Check if loading went well


```python
cur.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
```




    [('nyc_taxi',), ('kdd',)]



---
## Run SQL queries


```python
pd.read_sql("SELECT count(*) FROM nyc_taxi", con=con)
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
      <th>count(*)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>113496874</td>
    </tr>
  </tbody>
</table>
</div>




```python
df_ = pd.read_sql("SELECT * FROM nyc_taxi LIMIT 10", con=con)
df_.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 10 entries, 0 to 9
    Data columns (total 17 columns):
    VendorID                 10 non-null int64
    tpep_pickup_datetime     10 non-null object
    tpep_dropoff_datetime    10 non-null object
    passenger_count          10 non-null int64
    trip_distance            10 non-null float64
    RatecodeID               10 non-null int64
    store_and_fwd_flag       10 non-null object
    PULocationID             10 non-null int64
    DOLocationID             10 non-null int64
    payment_type             10 non-null int64
    fare_amount              10 non-null float64
    extra                    10 non-null float64
    mta_tax                  10 non-null float64
    tip_amount               10 non-null float64
    tolls_amount             10 non-null float64
    improvement_surcharge    10 non-null float64
    total_amount             10 non-null float64
    dtypes: float64(8), int64(6), object(3)
    memory usage: 1.4+ KB

