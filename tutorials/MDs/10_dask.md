```python
from dask.distributed import Client, LocalCluster
```


```python
client = Client(LocalCluster())
```

    /Users/dkhosla/miniconda2/envs/dask-test/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)



```python
client
```




<table style="border: 2px solid white;">
<tr>
<td style="vertical-align: top; border: 0px solid white">
<h3>Client</h3>
<ul>
  <li><b>Scheduler: </b>tcp://127.0.0.1:57034
  <li><b>Dashboard: </b><a href='http://127.0.0.1:8787/status' target='_blank'>http://127.0.0.1:8787/status</a>
</ul>
</td>
<td style="vertical-align: top; border: 0px solid white">
<h3>Cluster</h3>
<ul>
  <li><b>Workers: </b>4</li>
  <li><b>Cores: </b>4</li>
  <li><b>Memory: </b>17.18 GB</li>
</ul>
</td>
</tr>
</table>




```python
import dask.dataframe as dd
```


```python
!ls | grep csv | xargs wc -l
```

     9710126 yellow_tripdata_2017-01.csv
     9168827 yellow_tripdata_2017-02.csv
     10294630 yellow_tripdata_2017-03.csv
     10046190 yellow_tripdata_2017-04.csv
     10102126 yellow_tripdata_2017-05.csv
     9656995 yellow_tripdata_2017-06.csv
     8539479 yellow_tripdata_2017-07.csv
     67518373 total



```python
df_nyc = dd.read_csv("yellow_tripdata_2017-*.csv")
```


```python
df_nyc.head(2)
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
      <th>VendorID</th>
      <th>tpep_pickup_datetime</th>
      <th>tpep_dropoff_datetime</th>
      <th>passenger_count</th>
      <th>trip_distance</th>
      <th>RatecodeID</th>
      <th>store_and_fwd_flag</th>
      <th>PULocationID</th>
      <th>DOLocationID</th>
      <th>payment_type</th>
      <th>fare_amount</th>
      <th>extra</th>
      <th>mta_tax</th>
      <th>tip_amount</th>
      <th>tolls_amount</th>
      <th>improvement_surcharge</th>
      <th>total_amount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>2017-01-09 11:13:28</td>
      <td>2017-01-09 11:25:45</td>
      <td>1</td>
      <td>3.3</td>
      <td>1</td>
      <td>N</td>
      <td>263</td>
      <td>161</td>
      <td>1</td>
      <td>12.5</td>
      <td>0.0</td>
      <td>0.5</td>
      <td>2.00</td>
      <td>0.0</td>
      <td>0.3</td>
      <td>15.30</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>2017-01-09 11:32:27</td>
      <td>2017-01-09 11:36:01</td>
      <td>1</td>
      <td>0.9</td>
      <td>1</td>
      <td>N</td>
      <td>186</td>
      <td>234</td>
      <td>1</td>
      <td>5.0</td>
      <td>0.0</td>
      <td>0.5</td>
      <td>1.45</td>
      <td>0.0</td>
      <td>0.3</td>
      <td>7.25</td>
    </tr>
  </tbody>
</table>
</div>




```python
df_nyc.payment_type.value_counts().head()
```




    1    40646179
    2    19382463
    3      315223
    4       91611
    5           3
    Name: payment_type, dtype: int64




```python
len(df_nyc)
```




    60435479




```python
(df_nyc
 .groupby('passenger_count')
 .apply(lambda gr: gr['trip_distance'].mean().compute())
)
```

## Writing to Parquet


```python
df = df_nyc.astype({'VendorID': 'uint8',
                    'passenger_count': 'uint8',
                    'RateCodeID': 'uint8',
                    'payment_type': 'uint8'})

df.to_parquet('s3://dask-data/nyc-taxi/tmp/parquet',
              compression='snappy',
              has_nulls=False,
              object_encoding='utf8',
              fixed_text={'store_and_fwd_flag': 1})
```
