```python
import os
os.chdir("/home/data")
```


```python
ls | grep kdd | xargs wc -l
```

           42 kddcup-names
      4898431 kddcup.data
      4898473 total


## Basic Info on a File


```python
!cat kddcup.data | csvtk stats
```

    file   num_cols    num_rows
    -            42   4,898,430



```python

```


```python
!echo 'interaction_type' >> ../data/raw/kdd.csv
```


```python
!cat ../data/raw/kdd.csv
```

    duration,protocol_type,service,flag,src_bytes,dst_bytes,land,wrong_fragment,urgent,hot,num_failed_logins,logged_in,num_compromised,root_shell,su_attempted,num_root,num_file_creations,num_shells,num_access_files,num_outbound_cmds,is_host_login,is_guest_login,count,srv_count,serror_rate,srv_serror_rate,rerror_rate,srv_rerror_rate,same_srv_rate,diff_srv_rate,srv_diff_host_rate,dst_host_count,dst_host_srv_count,dst_host_same_srv_rate,dst_host_diff_srv_rate,dst_host_same_src_port_rate,dst_host_srv_diff_host_rate,dst_host_serror_rate,dst_host_srv_serror_rate,dst_host_rerror_rate,dst_host_srv_rerror_rate,interaction_type



```python
!cat kddcup.data >> ../data/raw/kdd.csv
```


```python
!head ../data/raw/kdd.csv | cut -d, -f30-42 | sed '1d' 
```

    0.00,0.00,0,0,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,1,1,1.00,0.00,1.00,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,2,2,1.00,0.00,0.50,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,3,3,1.00,0.00,0.33,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,4,4,1.00,0.00,0.25,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,5,5,1.00,0.00,0.20,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,6,6,1.00,0.00,0.17,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,7,7,1.00,0.00,0.14,0.00,0.00,0.00,0.00,0.00,normal.
    0.00,0.00,8,8,1.00,0.00,0.12,0.00,0.00,0.00,0.00,0.00,normal.


# `q: text as data`

- http://harelba.github.io/q/index.html

- q allows performing SQL-like statements on tabular text data.
- Its purpose is to bring SQL expressive power to manipulating text data using the Linux command line.
- Basic usage is `q "<sql like query>"` where table names are just regular file names
- When the input contains a header row, use `-H`, and column names will be set according to the header row content. 
    - If there isn't a header row, then columns will automatically be named `c1..cN`
- Column types are detected automatically. Use `-A` in order to see the column name/type analysis.
- Delimiter can be set using the `-d` (or `-t`) option. 
    - Output delimiter can be set using `-D`
- All sqlite3 SQL constructs are supported.

> - Please note that column names that include spaces need to be used in the query with back-ticks, as per the sqlite standard.
- Full type detection is implemented, so there is no need for any casting
- Multiple Files
    - Multiple files can be concatenated by using one of both of the following ways:
    - Separating the filenames with a + sign: SELECT * FROM datafile1+datafile2+datefile3.
    - Using glob matching: SELECT * FROM mydata*.dat


```python
!ls ../data/raw/ | grep csv
```

    countrynames.csv
    Crimes_Chicago.csv
    Flight_Delays.csv
    fromPandas.csv
    het-bool.csv
    kdd.csv
    millionSongsSample.csv
    NYC__311Requests.csv
    worldcitiespop.csv



```python
!ls ../data/raw/ | grep txt
```

    Fun__Item.txt
    Fun__Sales.txt
    kddcup.names.txt
    MusicXMatch__Test.txt
    MusicXMatch__Train.txt
    Stock_Export.txt



```python
!cat ../data/raw/kdd.csv | q -H -d, """SELECT distinct(interaction_type), count(*) from - group by 1 order by 2 desc"""
```

    smurf.,2807886
    neptune.,1072017
    normal.,972781
    satan.,15892
    ipsweep.,12481
    portsweep.,10413
    nmap.,2316
    back.,2203
    warezclient.,1020
    teardrop.,979
    pod.,264
    guess_passwd.,53
    buffer_overflow.,30
    land.,21
    warezmaster.,20
    imap.,12
    rootkit.,10
    loadmodule.,9
    ftp_write.,8
    multihop.,7
    phf.,4
    perl.,3
    spy.,2



```python
!head ../data/raw/kdd.csv | q -H -d, """SELECT interaction_type, case when interaction_type = 'normal.' then 0 else 1 end as attack \
from -"""
```

    normal.,0
    normal.,0
    normal.,0
    normal.,0
    normal.,0
    normal.,0
    normal.,0
    normal.,0
    normal.,0

