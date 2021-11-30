# metropdcleanR
This is an R package to help data analysts, data journalists, and anyone else import and clean **Metropolitan Police Department's** (the police department for the Washington D.C. metropolitan area) **stop data**.

Metropolitan PD only released their data after a number of lawsuits filed by ACLU-DC, Black Lives Matter DC, and Stop Police Terror Project D.C.. Read local coverage of those lawsuits [here](https://wjla.com/news/local/aclu-dc-lawsuit-mpd-stop-and-frisk-data-2020).
The data are available on MPD's website [here](https://mpdc.dc.gov/stopdata).

Coincidentally, Metropolitan PD's data releases are highly, highly messy. This package helps users import the data they want and clean it.

## Installation
You can install the development version of metropdcleanR from GitHub with:
```
install.packages("devtools")
devtools::install_github("ldimartin0/metropdcleanR")
```

## Usage
Accessing MPD data, which is stored in arbitrarily-separated CSV files on their website, is a fairly difficult task on its own. `metropdcleanR::get_yr_data()` allows you to access that data with one line:
```
d <- get_yr_data(2020)
```

You can access multiple years of data as well:
```
d <- get_yr_data(2019:2021)
```

On its own, `metropdcleanR::get_yr_data()` only loads the data into working memory. That data can then be exported into a file type of your choice manually. On the other hand, if you want to use the built-in tool, change the `export` parameter to `TRUE`:
```
get_yr_data(2019:2021)
```

Once imported, MPD's stop data is highly messy. `metropdcleanR` provides a function to clean MPD data, `metropdcleanR::clean_data()`. Call it on any raw MPD file for cleaning:
```
d <- get_yr_data(2020)
d <- clean_data(d)
```

`metropdcleanR::clean_data()` does not change any meaningful values about the data, it only prepares the data for analysis.

## Contact
Maintenance information is all in the description file.


