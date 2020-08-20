```python
import os
os.chdir("/home/data")
```


```python
!man pr
```

    man: can't set the locale; make sure $LC_* and $LANG are correct
    No manual entry for pr
    See 'man 7 undocumented' for help when manual pages are not available.



```python
!csvcut -n flights.csv | pr -t -2
```

      1: Year			     16: DepDelay
      2: Month			     17: Origin
      3: DayofMonth			     18: Dest
      4: DayOfWeek			     19: Distance
      5: DepTime			     20: TaxiIn
      6: CRSDepTime			     21: TaxiOut
      7: ArrTime			     22: Cancelled
      8: CRSArrTime			     23: CancellationCode
      9: UniqueCarrier		     24: Diverted
     10: FlightNum			     25: CarrierDelay
     11: TailNum			     26: WeatherDelay
     12: ActualElapsedTime		     27: NASDelay
     13: CRSElapsedTime		     28: SecurityDelay
     14: AirTime			     29: LateAircraftDelay
     15: ArrDelay



```python
import subprocess as sbp
run_on_bash = lambda i: sbp.check_output("{}".format(i), shell=True).decode('utf-8').strip()

x = run_on_bash("""
seq 1 20 | awk 'BEGIN{OFS=","}{print rand(),rand(),rand()}'
""")

from io import StringIO
pd.read_csv(StringIO(x), header=None)
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
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.237788</td>
      <td>0.291066</td>
      <td>0.845814</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.152208</td>
      <td>0.585537</td>
      <td>0.193475</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.810623</td>
      <td>0.173531</td>
      <td>0.484983</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.151863</td>
      <td>0.366957</td>
      <td>0.491736</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.910094</td>
      <td>0.265257</td>
      <td>0.893188</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.220351</td>
      <td>0.631798</td>
      <td>0.571077</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.332158</td>
      <td>0.104455</td>
      <td>0.502931</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.567394</td>
      <td>0.854165</td>
      <td>0.040141</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0.108022</td>
      <td>0.639396</td>
      <td>0.013111</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.720184</td>
      <td>0.101814</td>
      <td>0.482945</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.254355</td>
      <td>0.676697</td>
      <td>0.896782</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.759896</td>
      <td>0.720292</td>
      <td>0.907623</td>
    </tr>
    <tr>
      <th>12</th>
      <td>0.928611</td>
      <td>0.377663</td>
      <td>0.899756</td>
    </tr>
    <tr>
      <th>13</th>
      <td>0.778880</td>
      <td>0.324255</td>
      <td>0.194231</td>
    </tr>
    <tr>
      <th>14</th>
      <td>0.995553</td>
      <td>0.161296</td>
      <td>0.708034</td>
    </tr>
    <tr>
      <th>15</th>
      <td>0.501519</td>
      <td>0.936301</td>
      <td>0.716323</td>
    </tr>
    <tr>
      <th>16</th>
      <td>0.105190</td>
      <td>0.209205</td>
      <td>0.559397</td>
    </tr>
    <tr>
      <th>17</th>
      <td>0.705432</td>
      <td>0.078234</td>
      <td>0.510530</td>
    </tr>
    <tr>
      <th>18</th>
      <td>0.196197</td>
      <td>0.274211</td>
      <td>0.638602</td>
    </tr>
    <tr>
      <th>19</th>
      <td>0.448208</td>
      <td>0.039872</td>
      <td>0.467251</td>
    </tr>
  </tbody>
</table>
</div>



# Quick Reference for awk


## Basic Syntax

```bash
awk <command-line options> <awk script> <parameters> <data file>
```
Awk can be written in two ways

- short awk statements enclosed within single quotes `'pattern { action }'` can be run directly

```bash
awk [-v var=value] [-Fr e] [- -] ’pattern { action }’ var=value datafile(s)
```  

- long awk programs can be placed within a `.awk` file and run with the `-f` option

```bash
# create the awk script as 
________________________
#! /usr/bin/awk -f
...functions...
...statements...
________________________

# run it
awk [-v var=value] [-Fr e] -f scriptfile [- -] var=value datafile(s)
```  

## Options, Parameters

- The `-v` option sets the variable var to value before the script is executed
- The `-F` option is used to specify a delimiter
    - This can also be done with the `BEGIN` statement inside a script
- the `--` option marks the end of **command-line options**

- **Parameters** can be passed into awk by specifying them on the command line _after_ the script
    - Can be a literal, a shell variable, or the result of a bash command  
    - These are not available until the first line of input is read, and thus cannot be accessed in the `BEGIN` procedure.

## Records and Fields

- Each line of input is split into **fields** and becomes a **record**
- By default, the field delimiter is one or more spaces and/or tabs. 
    - The delimiter can be changed using `-F` or with `OFS=`
- The default record separator is a newline.  
    - Can be changed with the `RS=` option in the `BEGIN` procedure
- Each field can be referenced by its position in the record. 
    - `$1` refers to the value of the first field; 
    - `$2` to the second field, and so on. 
    - `$0` refers to the entire record

## Writing awk Scripts

- A script is set of awk **statements**
- Each statement has
    - **patterns** which filter records to which actions apply
    - **actions** that are used for modifying or analysing data
- If no pattern is specified, the action is performed on every record
- If no action is specified, the default action, `print`, is performed on all matching records.
- **Functions** can be declared with the following syntax
    - Variables specified in the parameter-list are treated as local variables within the function. 
    - All other variables are global and can be accessed outside the function.

```bash
function some_func(parameters) { statements } 
```

- A line in an awk script is **terminated** by a newline or a semicolon
- **Flow control statements** (`do, if, for, while`) continue on the next line

```bash
if (NF > 1) { 
    name = $1
    total += $2
}
```
- A **comment** begins with a “#” and ends with a newline


## Patterns

- A pattern can be any of the following:

```
/regular expression/ 
relational expression 
BEGIN
END
pattern, pattern
```

- Regular expressions must be enclosed in slashes
- Relational expressions use Operators like `< <= > >= != ==` and `&& || ~ !~`
- The **BEGIN pattern** is applied before the first line of input is read
- the **END pattern** is applied after the last line of input is read.
    - BEGIN and END patterns must be associated with actions.
- Use `!` to negate a match

## Variables

- **User Defined**
    - The name of a variable cannot start with a digit.
    - Case matters
    - Can contain a string (must be quoted) or a numeric value
    - Does not need to be initialized (awk is a dynamically typed language)
        - An uninitialized variable has the empty string (“”) as its string value and 0 as its numeric value. 
        - Awk attempts to decide whether a value should be processed as a string or a number depending upon the operation.  
        

- **Built-in or system variables** 
    - Names consist of all capital letters.
    - 

- **Fields**
    - A field variable is referenced using `$n`, where n is any number 0 to NF
    - n can be supplied by 
        - a variable, such as `$NF` (meaning the last field), 
        - a constant, such as `$1` meaning the first field.
        
- **Arrays**
    - Arrays are variables that store a set of indexed values
    - Declared with
    - Arrays are _associative_, ie. exist as key-value pairs
        - The index can be string or numeric
    - Values are not stored in a particular order
    - Use a for loop to read the array
    - Use an if statement to check if an index exists
    - You can also delete individual elements of the array using the **delete** statement.
    
```bash

# creating an array
some_array[idx] = value

# accessing items
for (idx in array) {
    ...do something with idx or array[idx]...
}

# check if idx exists
if (idx in array) {
    ...do something...
}
```
    


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```
