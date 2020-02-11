# 2020-02-11: R packages: Data 

From <https://r-pkgs.org/data.html>



## Exported data: data/

> If you want to store binary data and make it available to the user, put it in data/. This is the best place to put example datasets.

```R
use_data_raw()

# data-raw/mini_mtcars.R
# Prepare
mini_mtcars <- head(mtcars)

usethis::use_data(mini_mtcars)
```

## Document exported data

```R
# R/mini_mtcars.R

#' First six rows of [datasets::mtcars]
#' 
#' A mini dataset for examples and tests.
#'
#' @source [datasets::mtcars]
"mini_mtcars"
```



## Internal data: R/sysdata.rda

> If you want to store parsed data, but not make it available to the user, put it in R/sysdata.rda. This is the best place to put data that your functions need.

```R
# data-raw/sysdata.R
mini_letters <- head(letters)
mini_month <- head(month.abb)

usethis::use_data(mini_letters, mini_month, internal = TRUE)
```



## Raw data for users: inst/extdata

> If you want to store raw data, put it in inst/extdata.

```R
use_directory("inst/extdata")

system.file("extdata", "iris.csv", package = "readr", mustWork = TRUE)
```



## `dput()`, `tibble::tribble()`, `datapasta::tribble_paste()`

> A simple alternative to these three options is to include it in the source of your package, either creating by hand, or using dput() to serialise an existing data set into R code.


```r
datasets::BOD
#>   Time demand
#> 1    1    8.3
#> 2    2   10.3
#> 3    3   19.0
#> 4    4   16.0
#> 5    5   15.6
#> 6    7   19.8

dput(datasets::BOD)
#> structure(list(Time = c(1, 2, 3, 4, 5, 7), demand = c(8.3, 10.3, 
#> 19, 16, 15.6, 19.8)), class = "data.frame", row.names = c(NA, 
#> -6L), reference = "A1.4, p. 270")
```

