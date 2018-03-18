[TOC]

# Basics

  - [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial)
  - [Command Line Crash Course](http://www.vikingcodeschool.com/web-development-basics/a-command-line-crash-course)
  - [Conquering the CLI](http://conqueringthecommandline.com/book)

# Variables

- declared as `SOME_VAR=value`, where _value_ may be numeric or string (enclosed within `""`)
  - there must be no spaces around the `=` sign
  - all values are stored as strings, but commands which expect a number can treat them as such.
    - special characters must be properly escaped to avoid interpretation by the shell
  - we can interactively set variable names using the `read` command

```bash
#!/bin/sh
echo What is your name?
read MY_NAME
echo "Hello $MY_NAME! Hope you're well."
```

- if you try to read an undeclared variable, the result is the empty string.
  - **PS**: You get no warnings or errors
- To use values stored inside variables, use the dollar sign with curly braces: `echo ${SOME_VAR}`

```bash
SOME_VAR="some value"
echo "just ${SOME_VAR} stored in a variable"
```

## Changing Variable Scope with `export` and `source`

- When we run a script like `bash hello.sh`, a new shell is spawned to run the script
  - Once the shell script exits, its environment is destroyed
- If you want a script to make changes to the global environment, you have to _source_ it
  - This will run the script within the active shell, instead of spawning a new one
  - This is how  `.profile` or `.bash_profile` files work
- `export SOME_VAR=some_value` will create a global Variable
  - You may access it's value inside scripts


# Special characters

- Most characters like `* and '` are not interpreted if placed inside double quotes ("")
- However, double-quotes `"`, dollar-signs `$`, back-ticks, and slashes `\` are still interpreted by the shell, even when they're in double quotes.
  - These need to be _escaped_ using the back-slash `\`

# Loops with `for` and `do ... done`

- Initialize a loop as `for i in ...`
  - Use `seq` to generate sequences to iterate over

```bash
for i in `seq -s" " 1 10`
do
  echo $i
done
```

# Conditionals

```bash
if [ condition ]; then
  # action
elif [ condition ]; then
  # action
else
  # action
fi
```

- The `condition` must be surrounded by spaces
- Operators,
  - For numeric data, use `-eq`, `-lt`, `-gt`, `-le`, `-ge`
  - For strings, use `=` and `!=`
  - `-n` for non-zero length
  - `-f "$SOME_PATH"` for checking if a file exists at given path
  - `-x "$SOME_PATH"` for checking if a file is executable at given path
  - `"$PATH_2" -nt "$PATH_1"` for checking if file at PATH_2 is newer than the one at PATH_1

```bash
#!/bin/bash
echo "enter name of file in pwd: "
read fn
if [ -f "$fn" ]
then
  echo "Exists"
else
  echo "Cannot find file"
fi
```

- For expressing complex logic, use AND, `&&` along with OR, `||`

# Special Variables

- contain useful information, which can be used by the script to know about the environment in which it is running.
- `$0` is the _basename_ of the program (or the name of the script.)
- `$1 .. $9` are the first 9 parameters the script was called with
- `$@` is all parameters passed
- `$$` variable is the PID (Process IDentifier) of the currently running shell.
- `$!` variable is the PID of the last run background process.

# Functions

- For simple scripts, a function may be simply declared within the same file as it is called.
- When writing a complex program, it is useful to write a "library" of useful functions, and `source` that file at the start of the other scripts which use the functions.
- A function may return a value in one of four different ways:
  - _Change the state_ of a variable or variables
  - Use the `exit` command to end the shell script
  - Use the `return` command to end the function, and return the supplied value to the calling section of the shell script
  - `echo` output to stdout, which will be caught by the caller just as c=`expr $a + $b` is caught
- Syntax

```bash
#!/bin/bash

# function declarations
some_func()
{
  # commands
}

# function usage
some_func arg_1 arg_2 arg_3 ...
```
- example



# Note

- `> /dev/null 2>&1` redirects any output or errors to the special "null" device instead of going to the user's screen.
- The _backtick_ is used to indicate that the enclosed text is to be executed as a command.
  - For example,

```bash
$ MYNAME=`grep "^${USER}:" /etc/passwd | cut -d: -f5`
$ echo $MYNAME
```
