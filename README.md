# Cron Parser

The goal of this script is to parse a cron string and expand each field to show the 
times at which it will run. 

We only consider the standard cron format with five time fields (minute, hour, day of 
month, month, and day of week) plus a command; we do not handle the special time 
strings such as "@yearly".

The cron string will be passed to our script on the command line as a single argument on
a single line. 

## Example:
```
~$ bin/parser "*/15 0 1,15 * 1-5 /usr/bin/find"
```
## Output 

The output will be formatted as a table with the field name taking the first 14 columns and
the times as a space-separated list following it.

## Command line help 

Type `bin/parser help` for a description of how to use the cron parser. 

The explanation is repeated below:
```
You have to provide 6 parameters for the parser:
----------------------------------------------------------------------------------
bin/parser * * * * * *
           | | | | | |
           | | | | | +-- The command to be run (e.g. /usr/bin/find)
           | | | | +---- Day of the Week       (range: 1-7, 1 standing for Monday)
           | | | +------ Month of the Year     (range: 1-12)
           | | +-------- Day of the Month      (range: 1-31)
           | +---------- Hour                  (range: 0-23)
           +------------ Minute                (range: 0-59)
----------------------------------------------------------------------------------
```
