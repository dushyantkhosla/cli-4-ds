## 0 - Why awk

Say a client handed you a `.csv` file with a few columns. You have to run basic descriptive statistics on these columns, and maybe a few group-by operations (okay, pivot-tables.) If the file is a few thousand rows (under 100MB in size), you will probably double-click on it straight away and run the analysis in Excel. Give yourself a pat on the back, you chose the right tool for the right job. _Who's a good analyst? Yes, you are!_

But what if the file was 750MB? Assuming you have enough RAM (8GB or more), of course you'll use `dplyr` in R, or `pandas` in Python or (gasps) write a data step in `SAS`. _Right? Excellent._

But what if the file was 6GB?

15GB?

If the word `Hadoop` is stuck in your throat, I implore you to swallow it.

PS: Yes, there are tools that allow you to work with larger-than-RAM files on a single machine (`Spark`, `Dask` and perhaps some more), but we'll keep that for later.



## 2 - Features

- **View** a text file as a textual database made up of records and fields.

- Use variables to **manipulate** the database.
- Use **arithmetic** and **string** operators.

- Use common programming constructs such as **loops and conditionals**.

- Generate **formatted** reports.

- Define **functions**.

- **Execute UNIX commands** from a script.

- Process the result of UNIX commands.

- Process command-line arguments more gracefully.

- Work more easily with **multiple input streams.**


## 3 - Syntax and Execution Model

An awk program consists of what we will call a **main input loop**. You don’t write this loop, it is given—it exists as the framework within which the code that you do write will be executed. The main input loop in awk is a routine that reads one line of input from a file and makes it available for processing. The actions you write to do the processing assume that there is a line of input available. In another programming language, you would have to create the main input loop as part of your program. It would have to open the input file and read one line at a time.

The main input loop is executed as many times as there are lines of input. It terminates when there is no mor e input to be read. . Inside the main input loop, your instructions are written as a series of pattern/action procedures. A pattern is a rule for testing the input line to determine whether or not the action should be applied to it. The actions, as we shall see, can be quite complex, consisting of statements, functions, and expressions.

The main thing to remember is that each pattern/action procedur e sits in the main input loop, which takes care of reading the input line. The procedur es that you write will be applied to each input line, one line at a time.

Awk allows you to write two special routines that can be executed before any input is read and after all input is read. These are the procedur es associated with **the BEGIN and END rules**, respectively. In other words, you can do some preprocessing before the main input loop is ever executed and you can do some postpr ocessing after the main input loop has terminated. The BEGIN and END procedures are optional.

In summary, an awk program consists of:

- **`BEGIN` segment** (optional) : to initialize our variables before we even start reading input
- **pattern + action pairs**: to process the input data, here we may place multiple pattern + action pairs to do multiple things with the same line.
- **`END` segment**: actions for when the EOF is reached, typically used to print results

```bash
# as a file saved with the .awk extension
BEGIN {actions;}
pattern {actions;}
pattern {actions;}
.
.
.
pattern { actions;}
END {actions;}

# or on a line
awk 'BEGIN {initial actions} {processing actions} END {ending actions}' file.txt

# NOTE
# The 'pattern' is a regex or a boolean expression used to match rows, or special expressions like BEGIN and END
# the 'action' is a series of awk commands applied to selected fields of rows that match the regex/where the boolean expression evaluates to True
# can include function calls, variable assignments, calculations, or any combination thereof.
```



## 3.1 -  Execution

For each line of input, awk attempts each pattern-matching rule given in the script. The lines matching a particular pattern become the object of an action. If no action is specified, the line that matches the pattern is printed.

Note that  a line can match more than one rule.
You can write a stricter rule set to prevent a line from matching more than one rule.

Every line of the document to scan will have to go through each of the patterns, one at a time.

- Line 1 of the text file will be compared against `Pattern1`, and if it matches, `Action1` will be executed.
- If it doesn't match, `Pattern2` will be checked, and `Action2` will or won't be executed.
- This will continue until the input has been read completely.
- Note that either the *condition* or the *action* may be omitted.
  - The *condition* defaults to matching every record. The default *action* is to print the record.

awk statements can be run on the command-line, or inside a script

```bash
awk [options] <pattern> <action> file(s)
# statements are separated by ;

awk [options] -f awk-script file(s)

# OPTIONS
# -f   precedes name of awk script
# -F   changes delimiter
# -v   precedes assignment var=value
```

## 3.2 - Examples

Here we look at a few examples, from super simple ones to some basic ones

```bash
awk '{ print $1 }' foo.txt
# no pattern; print the first field (use default delimiter) of every line in foo

awk '/regex/' foo.txt
# no action; print matching lines in foo

awk '/regex/ { print $1 }' foo.txt
# print the first field of each record that matches the regex

awk -F, '{ print $1; print $2}' foo.txt
# -F changes the delimiter to comma
# for each record in foo, print the 1st and 2nd fields on their own lines

awk '{print $3+$4}' foo.txt
# return the sum of columns 3 and 4

awk '$1=="bar" {print $3+$4}' foo.txt
# return the sum of columns 3 and 4 for rows where field 1 equals bar
```

---

## 4 - Data Types

### 4.1 - Strings, Numbers

awk only has <u>two main data types</u>: **strings** and **numbers**.

And even then, Awk likes to convert them into each other. Numbers stored as strings are **implicitly converted.** If the string doesn't look like a numeral, it's `0`. String objects are enclosed within double quotes `""`

For **string concatenation**, simply place two variables next to each other.

### 4.2 - Variables

Both types can be assigned to variables in the `ACTIONS` parts of your code with the `=` operator. Variables can be declared anywhere, at any time, and used even if they're not initialized (their default value is `""`, the empty string.

>  NOTE
>  The *variables are all global*.
>  Whatever variables you declare in a given block will be visible to other blocks, for each line



### Built-in Variables

| Variable         | Contains                                 |
| ---------------- | ---------------------------------------- |
| `$0`             | represents the entire record             |
| `$1, $2, $3 ...` | access respective fields                 |
| `NR`             | row number of the current record         |
| `NF`             | number of fields in the current record (`$NF` accesses the last field) |
| `FILENAME`       | contains the name of the current input-file |
| `FS`             | field-separator (default is whitespace(s), includes tabs) can be regex |
| `RS`             | record-separator (default: `newline`)    |
| `OFS`, `ORS`     | output delimiter (default: space), record separator (default: newline) |
| `OFMT`           | format for numeric output. The default format is "%.6g". |

### 4.3 - Arrays

Finally, awk has arrays. They are **unidimensional associative arrays** that can be **started dynamically**. 'Associative' means that they may be indexed by strings or number and stores data in a key value format, like Python dictionaries.

Their syntax is just `var[key] = value`.

## 5 - Patterns

### 5.1 - Regular Expressions

The regexes used with awk are general expressions that you use everyday with `grep` and `sed`. N
ote that these regexs only exist to **match** lines, they do not capture fields where the match occurs.

```bash
/foo/ { ... }     		# any line that contains 'foo'
/^foo/ { ... }		    # lines that begin with 'foo'
/foo$/ { ... }    		# lines that end with 'foo'
/^[0-9.]+ / { ... } 	# lines beginning with series of numbers and/or periods
/(foo|bar|baz)/ 		# lines that contain specific words
```

### 5.2 - Boolean Expressions

These are constructed using any regular data types with the *comparison* operators like `==, !=, >, >=, < ` and `<= `. Note that `==` does fuzzy matching, such that `80=="80"` is `True`.

**Compound** expressions can be constructed using operators `&&` (AND), `||` (OR), and `!` (NOT).

#### Note

- Regexes and Booleans can be **mixed**, so the expression `/foo/ && '$3=="bar"'` is valid and will match rows that contain the string foo, and contain "bar" in their 3rd field
- You can *modify the line* by assigning to its field.
  - For example, if you write `$1 = "foobar"` in one block, the next patterns will now operate on that line instead of the original one.
  - Could be used for *imputation* of missing data!



### 5.3 - Special Patterns: BEGIN and END

The first one, `BEGIN`, matches only *before* any line has been input to the file.
This is basically where you can **initiate variables** (like declaring delimiters) and all other kinds of state in your script.

`END` will match *after* the whole input has been handled.
This lets you clean up or do some final output before exiting.

## 6 - Actions

The most useful ones are listed here

```bash
# basics
{ print $0; }  		# prints $0. In this case, equivalent to 'print' alone
{ exit; }      		# ends the program
{ next; }      		# skips to the next line of input

# assignments
{ a=$1; b=$0 } 		# variable assignment
{ c[$1] = $2 } 		# variable assignment (array)

# conditional processing
{ if (BOOLEAN) { ACTION }
  else if (BOOLEAN) { ACTION }
  else { ACTION }
}

# loops
{ for (i=1; i<x; i++) { ACTION } }
{ for (item in c) { ACTION } }
```

Examples

```bash
awk '/system/ {count+=1} END {print count}' temp.txt
# find the number of rows that contain 'system'

awk '{sum+=$1; count+=1} END {print sum/count}' foo
# print the mean of field 1

# mean can also be found using the in-built row counter NR
awk 'BEGIN{ sum=0; FS=","} {sum+=$1} END {print sum/NR}' foo.csv
```

## 7 - Functions

Functions can be called with the following syntax:

```bash
{ somecall($2) }
```

There is a somewhat restricted set of built-in functions available, so I like to point to [regular documentation](https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html#Built_002din) for these.

User-defined functions are also fairly simple:

```
# function arguments are call-by-value
function name(parameter-list) {
     ACTIONS; # same actions as usual
}

# return is a valid keyword
function add1(val) {
     return val+1;
}
```

## 8 - Sources of Errors

Can be caused by any of the following:

- Not enclosing a procedur e within braces `{}`
- Not surrounding the instructions within single quotes `''`
- Not enclosing regular expressions within slashes `//`



## 9 - Applications

- [a uniq -c substitute for big files](http://stackoverflow.com/questions/32364102/finding-a-uniq-c-substitute-for-big-files)
- [big files with lots of dupes](http://stackoverflow.com/questions/11173868/efficient-sort-uniq-for-the-case-of-a-large-number-of-duplicates)



## 10 - References

- [awk in 20 minutes](http://ferd.ca/awk-in-20-minutes.html)

  ​

