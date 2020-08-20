```python
import os
os.chdir('/home/data/')

from time import time
```


```python
import sqlite3
import pandas as pd
import numpy as np

from sqlalchemy import create_engine
```

## Create an empty sqlite database file


```python
con = sqlite3.connect("sqlite.db")
```

- alternatively, use

```python
con = create_engine('sqlite:///tutorial.db')
```

## Create a _cursor_ object to interact with it


```python
cur = con.cursor()
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

---
# Loading Data into the Database

- This step might take a while if your CSV file is larger than a few GBs, 

- But the benefits outweigh the wait time;
    - you can use `pd.read_sql` tools to pull data from the database without worrying about memory constraints.
    - you can use tools like `Metabase` or any SQL editor to write aggregations and reductions on big data locally.  
    
    
- [Note] Avoid using `SELECT *` as it will load all data into memory. 

- Use `WHERE` statements and the `LIMIT` clause each time.

### Load KDD Data


```python
kdd_chunks = pd.read_csv(
    "kdd_flights/kdd.csv", 
    chunksize=10**6, 
    error_bad_lines=False
)
```


```python
t0 = time()
for chunk in kdd_chunks:
    """
    Fill the table by reading a large text file in chunks.
    Each chunk is just a pandas DataFrame
    Filter/transform the data as needed here.
    """
    (chunk
     .apply(convert_types)
     .to_sql(
         name='kdd', 
         con=con, 
         if_exists='append',
         index=False
    ))
    
print("Loading into db finished in {} seconds.".format(time()-t0))
```

    Loading into db finished in 35.13177156448364 seconds.


### Load Flights Data


```python
flights_chunks = pd.read_csv(
    'kdd_flights/flights.csv', 
    chunksize=10**6,
    error_bad_lines=False
)
```


```python
t0 = time()

for chunk in flights_chunks:
    """
    Fill the table by reading a large text file in chunks.
    Each chunk is just a pandas DataFrame
    Filter/transform the data as needed here.
    """
    (chunk
     .apply(convert_types)
     .to_sql(
         name='flightDelays', 
         con=con, 
         if_exists='append',
         index=False
    ))
    
print("Loading into db finished in {} seconds.".format(time()-t0))
```

    Loading into db finished in 80.80561757087708 seconds.


---
## Check if loading went well


```python
cur.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
```




    [('nyc_taxi',), ('kdd',), ('flightDelays',)]



---
## Run SQL queries


```python
pd.read_sql(
    """
    SELECT Origin,Dest,count(*) as Flights
    FROM flightDelays 
    GROUP BY 1,2
    ORDER BY 3 DESC
    LIMIT 10
    """, 
    con=con)
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
      <th>Origin</th>
      <th>Dest</th>
      <th>Flights</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>OGG</td>
      <td>HNL</td>
      <td>16099</td>
    </tr>
    <tr>
      <th>1</th>
      <td>HNL</td>
      <td>OGG</td>
      <td>15876</td>
    </tr>
    <tr>
      <th>2</th>
      <td>LAX</td>
      <td>LAS</td>
      <td>14385</td>
    </tr>
    <tr>
      <th>3</th>
      <td>LAS</td>
      <td>LAX</td>
      <td>13815</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HNL</td>
      <td>LIH</td>
      <td>13156</td>
    </tr>
    <tr>
      <th>5</th>
      <td>LIH</td>
      <td>HNL</td>
      <td>13030</td>
    </tr>
    <tr>
      <th>6</th>
      <td>SAN</td>
      <td>LAX</td>
      <td>12779</td>
    </tr>
    <tr>
      <th>7</th>
      <td>LAX</td>
      <td>SAN</td>
      <td>12767</td>
    </tr>
    <tr>
      <th>8</th>
      <td>BOS</td>
      <td>LGA</td>
      <td>12263</td>
    </tr>
    <tr>
      <th>9</th>
      <td>LAS</td>
      <td>PHX</td>
      <td>12228</td>
    </tr>
  </tbody>
</table>
</div>




```python
pd.read_sql("SELECT count(*) FROM kdd", con=con)
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
      <td>4898431</td>
    </tr>
  </tbody>
</table>
</div>


