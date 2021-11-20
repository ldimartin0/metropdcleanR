# metro-pd-data-cleaner
This repository contains functions to help data analysts, data journalists, and anyone else clean **Metropolitan Police Department's** (the police department for the Washington D.C. metropolitan area) **stop data**. The functions are written in R.

Metropolitan PD only released their data after a number of lawsuits filed by ACLU-DC, Black Lives Matter DC, and Stop Police Terror Project D.C.. Read local coverage of those lawsuits [here](https://wjla.com/news/local/aclu-dc-lawsuit-mpd-stop-and-frisk-data-2020).

The data are available on MPD's website [here](https://mpdc.dc.gov/stopdata).

Coincidentally, Metropolitan PD's data releases are highly, highly messy. These scripts contain functions that prepare download the data and store in the working memory, and functions that clean that data.

## the scripts
**get_data.R** contains functions for accessing MPD data. These functions may or may not work on Windows systems. The functions take no arguments, they merely download the data, load it into working memory in R, and then delete the data from storage. `get_all_data()` is the main function.

**clean_data.R** contains one function, `clean_data()` takes MPD's raw data and cleans it. The function makes no changes to the interpretation of any given observation (i.e. a human interpreting every single cell would interpret the cleaned data in the same way they would interpret the raw data). Rather, the function only changes the way in which the computer holds the data, and prepares it for analysis.

For those digging into the `clean_data()`, the function is a pipeline of four functions written inside of it.

## dependencies
1.0.0 doesn't include `require()` functions, so here are the relevant packages:
* tidyverse
* tidyverse associates:
	* stringr
	* forcats
	* purrr
	* lubridate

## contact info
contact me on github :)



