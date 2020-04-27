# Gotchas when moving code from a script to an R package {-}

## Packaging

### Setup: R, RStudio, Git, GitHub

These steps will direct you to relevant chapters from "Happy Git with R" by Jenny Bryan et. al.

- [Register a free GitHub account](https://happygitwithr.com/github-acct.html#github-acct)
- [Install or update R and RStudio](https://happygitwithr.com/install-r-rstudio.html#install-r-rstudio)
- [Install Git](https://happygitwithr.com/install-git.html#install-git)
- [Introduce yourself to Git](https://happygitwithr.com/hello-git.html#hello-git)
- [Prove local Git can talk to GitHub](https://happygitwithr.com/push-pull-github.html#push-pull-github)
- [Cache your username and password or set up SSH keys](https://happygitwithr.com/credential-caching.html#credential-caching)
- [Create and save a GitHub Personal Access Token (PAT)](https://happygitwithr.com/credential-caching.html#credential-caching)
- [Prove RStudio can find local Git and, therefore, can talk to GitHub](https://happygitwithr.com/rstudio-git-github.html#rstudio-git-github)



### Setup: devtools and testthat

Make the devtools and testthat packages available in every R session. Edit your .Rprofile file to include this code (you may use `usethis::edit_r_profile())`:

```R
if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(testthat))
}
```

(Your .Rprofile should NOT include data analysis packages such as dplyr or ggplot2.)

Ensure you always start each session with a blank slate:

<img src="https://i.imgur.com/Pdd3YFT.png" align="center" width = 750 />

Save, close and restart R.



### `use_data_raw()`, then `use_data()`

Good.

```R
# > Console
use_data_raw()

# data-raw/dataset-name.R
dataset_name <- readxl::read_excel("data-raw/dataset-name.xlsx")
use_data(dataset_name)

# R/dataset_name.R
#' A dataset
#' 
"dataset_name"

# R/any-file.R
f <- function() {
  dataset_name
}
```

Bad.

```R
# R/any-file.R
dataset_name <- readxl::read_excel("data/dataset-name.xlsx")

f <- function() {
  dataset_name
}
```

Bad.

```R
f <- function() {
  load("data/dataset_name.rda")
}
```

<http://r-pkgs.had.co.nz/data.html>



### Consider using internal data

Good.

```R
# data-raw/my_internal_data.R
use_data(my_internal_data, internal = TRUE)

# R/any.R
f <- function(data) {
  dplyr::left_join(data, my_internal_data)
}
```

Bad.

```R
# R/any.R
my_internal_data <- mtcars %>% dplyr::select(cyl)

f <- function(data) {
  dplyr::left_join(data, my_internal_data)
}
```

<http://r-pkgs.had.co.nz/data.html#data-sysdata>



### `use_package("dplyr")` not `library(dplyr)`

Good.

```R
use_package("dplyr")
```

Bad.

```R
library(dplyr)
```

<https://r-pkgs.org/whole-game.html>



### `namespace::function_from_other_package()`

Good.

```R
f <- function(data) {
  utils::head(dplyr::select(data, dplyr::last_col()))
}
```

Good.

```R
#' @importFrom magrittr %>%
#' @importFrom utils head
#' @importFrom dplyr select last_col
f <- function(data) {
  data %>% 
    select(last_col()) %>% 
    head()
}
```

Bad.

```R
f <- function(data) {
  head(select(data, last_col()))
}
```

Bad.

```R
f <- function(data) {
  data %>% 
    select(last_col()) %>% 
    head()
}
```



### The tidyverse is for EDA, not packages

Good.

```R
use_package("dplyr")
use_package("tidyr")
```

Bad.

```R
use_package("tidyverse")
```

<https://www.tidyverse.org/blog/2018/06/tidyverse-not-for-packages/>



### Use the `.data` pronoun

Good.

```R
f <- function(data, column_name) {
  dplyr::select(data, .data[[column_name]])
}
```

Ok.

```R
f <- function(data) {
  stopifnot(hasName(mtcars, "cyl"))
  
  dplyr::select(data, .data$cyl)
}
```


Bad. 

```R
f <- function(data) {
  dplyr::select(data, cyl)
}
```

* <https://rlang.r-lib.org/reference/tidyeval-data.html>
* <https://dplyr.tidyverse.org/dev/articles/programming.html#how-tos>



## Function interface

### Avoid relying on the global environment

Good.


```r
f <- function(data) {
  data
}

my_data <- tibble::tibble(x = 1)
f(my_data)
#> # A tibble: 1 x 1
#>       x
#>   <dbl>
#> 1     1
```

Bad. 


```r
f <- function(data = my_data2) {
  data
}

ls()
#> [1] "f"       "my_data"
try(f())
#> Error in f() : object 'my_data2' not found

my_data2 <- tibble::tibble(x = 1)
ls()
#> [1] "f"        "my_data"  "my_data2"
f()
#> # A tibble: 1 x 1
#>       x
#>   <dbl>
#> 1     1
```



### Avoid modifying the global environment, e.g. with `<<-`

Setup.


```r
readr::write_csv(mtcars, "some_data.csv")
```

Good.


```r
some_data_path <- function() {
  fs::path("some_data.csv")
}

some_data_path()
#> some_data.csv

read_some_data <- function(path) {
  suppressMessages(head(readr::read_csv(path)))
}

path <- some_data_path()  # Define path
read_some_data(path)
#> # A tibble: 6 x 11
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
#> 2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
#> 3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
#> 4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
#> 5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
#> 6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

Bad.


```r
some_data_path <- function() {
  path <<- "some_data.csv"
}

read_some_data <- function() {
  suppressMessages(head(readr::read_csv(path)))
}

some_data_path()  # Define path
read_some_data()
#> # A tibble: 6 x 11
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
#> 2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
#> 3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
#> 4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
#> 5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
#> 6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

> "[Avoid global variables because they] introduce non-obvious dependencies between functions" -- [Advanced R, Environments](https://adv-r.hadley.nz/environments.html)). 

For valid uses of `<<-` see ([Advanced R, Function factories](https://adv-r.hadley.nz/function-factories.html#stateful-funs)).

Clean up.


```r
fs::file_delete("some_data.csv")
```

### Arguments that provide core data are required

Good.

```R
f <- function(data) {
  data
}

f(mtcars)
```

Bad.

```R
f <- function(data = mtcars) {
  data
}

f()
```

> Arguments that provide core data are required (have no default); they are often called `data`, `x`, or `y`).

-- Adapted from <https://principles.tidyverse.org/args-data-details.html>



### Descriptor arguments are usually required

Good.

```R
forecast <- function(data, start_year, time_span = 5) {
  end_year <- start_year + time_span
  time_period <- data$year >= start_year & data$year <= end_year
  
  data %>%
    filter(time_period) %>%
    # ...
}
```

Bad.

```R
forecast <- function(data, start_year = 2020, time_span = 5) {
  # ...
}
```

> Descriptor arguments describe essential details of the operation, and are usually required.

-- Adapted from <https://principles.tidyverse.org/args-data-details.html>



### Avoid reading and writing operations

Unless it is precisely the purpose of your function, avoid operations that read or write data (in general, avoid side effects).

Good. 

```R
f <- function(data) {
  dplyr::select(data, 1L)
}
```

Bad.

```R
f <- function(path) {
  data <- readxl::read_excel(path)
  dplyr::select(data, 1L)
}
```

* [What is a pure function](https://github.com/2DegreesInvesting/resources/issues/68).
* [Avoid hidden arguments  (ds-incubator)](https://github.com/2DegreesInvesting/ds-incubator/blob/master/2019-12-03_avoid-hidden-arguments.pdf).



## Code smells and feels

### Simplify `if()` with objects named meaningfully


```r
x <- sample(c(1:10), size = 2, replace = TRUE)
say <- function(x, msg) paste(paste(x, collapse = ", "), msg)
say(1:2, "Hey!")
#> [1] "1, 2 Hey!"
```

Good.


```r
is_even_between_5and10 <- (x %% 2 == 0) & dplyr::between(x, 5L, 10L)
if (all(is_even_between_5and10)) {
  say(x, "Yeah!")
} else {
  say(x, "Nope!")
}
#> [1] "2, 4 Nope!"
```

Bad.


```r
if (all((x %% 2 == 0) & (x >= 5L) & (x <= 10L))) {
  say(x, "Yeah!")
} else {
  say(x, "Nope!")
}
#> [1] "2, 4 Nope!"
```

<https://speakerdeck.com/jennybc/code-smells-and-feels?slide=36>



### Program for columns with `clean_names`

Good.


```r
f <- function(data) {
  clean <- r2dii.utils::clean_column_names(data)
  
  stopifnot(hasName(clean, "a_column"))
  result <- dplyr::select(clean, .data$a_column)
  
  r2dii.utils::unclean_column_names(result, data)
}

f(tibble::tibble(A.Column = 1, Another.Column = 1))
#> Warning in stringr::str_replace_all(str = string, pattern = replace): partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace(str = transliterated_names, pattern = "\\A[\
#> \h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]*(.*)$", : partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace_all(str = string, pattern = replace): partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace(str = transliterated_names, pattern = "\\A[\
#> \h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]*(.*)$", : partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace_all(str = string, pattern = replace): partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace(str = transliterated_names, pattern = "\\A[\
#> \h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]*(.*)$", : partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace_all(str = string, pattern = replace): partial
#> argument match of 'str' to 'string'
#> Warning in stringr::str_replace(str = transliterated_names, pattern = "\\A[\
#> \h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]*(.*)$", : partial
#> argument match of 'str' to 'string'
#> # A tibble: 1 x 1
#>   A.Column
#>      <dbl>
#> 1        1
```

Bad.


```r
f <- function(data) {
  dplyr::select(data, .data$A.Column)
}

f(tibble::tibble(A.Column = 1, Another.Column = 1))
#> # A tibble: 1 x 1
#>   A.Column
#>      <dbl>
#> 1        1
```

[`?clean_column_names()`](https://2degreesinvesting.github.io/r2dii.utils/reference/clean_column_names.html)



### Avoid long-running temporary objects

Avoid temporary variables unless they run for only a few, consecutive lines.

Good.

```R
tmp <- dplyr::filter(mtcars, cyl > 4)
tmp <- dplyr::select(tmp, disp)
tmp <- head(tmp)

# ... more unrelated code
```

Better.

```R
mtcars %>% 
  dplyr::filter(cyl > 4) %>% 
  dplyr::select(disp) %>% 
  head()
```

Bad.

```R
tmp <- dplyr::filter(mtcars, cyl > 4)
tmp <- dplyr::select(tmp, disp)

# ... more unrelated code (makes your forget what `tmp` holds)

tmp <- head(tmp)
```

### If possible, extract functions to the top level

Good.


```r
f <- function(x) {
  g(x)
}

g <- function(x) {
  x + 1
}
```

Bad.


```r
f <- function(x) {
  g <- function(x) {
    x + 1
  }
  
  g(x)
}
```

### Extract commented sections into functions

Good.

```R
f <- function(x) {
  y <- calculate_y(x)
  
  # ... more code
}

calculate_y <- function(x) {
  x^x * x/2L
  # ... more code specifically about calculating y
}
```

Bad.

```R
f <- function(x) {
  # calculate y
  y <- x^x * x/2L
  # ... more code specifically about calculating y
  
  # ... more code
}
```



## Error prone

### Avoid hidden arguments: Extract functions with all arguments

Good.


```r
f <- function(x, y, z) {
  x + g(y, z)
}

g <- function(y, z) {
  y + z
}

f(1, 1, 1)
#> [1] 3
```

Bad.


```r
# Fragile.
f <- function(x, y, z) {
  g <- function(y) {
    # `z` is outside of the scope of g(). It's a hidden argument
    y + z
  }
  
  x + g(y)
}

f(1, 1, 1)
#> [1] 3

# f() breaks when you move g() to the top level
f <- function(x, y, z) {
  x + g(y)
}

g <- function(y) {
  y + z
}

try(f(1, 1, 1))
#> Error in g(y) : object 'z' not found
```



### Separate functions, data, and scripts

### A non-package project

It's easy for an analyst to maintain a project when functions, data, and scripts are separate.

Good.

```R
# R/all-functions.R
f <- function(data) {
  # ... some code
}

# data/all-datasets.R
some_data <- readr::read_csv(here::here("data-raw", "some_data.csv"))

# script/this-script.R
library(tidyverse)

source(here::here("R", "all-functions.R"))
source(here::here("data", "all-datasets.R"))


f(data = some_data)
```

It is error prone to mix functions, data, and scripts. The mess hides inter dependencies that can break your code unexpectedly. Also, this makes it hard for others to reproduce, or understand your code -- [the maintainance programmer can only view your code through a toilet paper tube](https://github.com/2DegreesInvesting/resources/issues/38#issuecomment-576383067).

Bad.

```R
# sripts-functions-and-data.R
library(tidyverse)

some_data <- readr::read_csv(here::here("data-raw", "some_data.csv"))

f <- function(some_data) {
  some_data %>% 
    dplyr::select() %>% 
    # ... more code
}

f(some_data)
```

### A package project

When functions, data, and scripts are separate, it's easy for a developer to transform a project into an R package. Functions go in the R/ directory, raw data in data-raw/, and data in data/. Scripts become examples, tests, and higher level documentation such as README, and the Home and articles pages of the package-website.

### `if()` uses a single `TRUE` or `FALSE`


```r
x <- c(1, 2)
y <- 0L
```

Good


```r
# Good
if (identical(x, c(1, 2))) {
  say(identical(x, c(1, 2)), "is what you gave.")
}
#> [1] "TRUE is what you gave."
```


```r
# Bad
if (x == c(1, 2)) {
  say(x == c(1, 2), "is what you gave.")
}
#> Warning in if (x == c(1, 2)) {: the condition has length > 1 and only the first
#> element will be used
#> [1] "TRUE, TRUE is what you gave."
```

Caveats: <https://github.com/2DegreesInvesting/ds-incubator/issues/13>



### `1` is equal to `1L` but not identical

Careful!


```r
1 == 1L
#> [1] TRUE
identical(1, 1L)
#> [1] FALSE
```

Good


```r
this_integer <- 1L
if (!identical(this_integer, 1)) "Not the same" else "Wrong result"
#> [1] "Not the same"
```

Bad.


```r
this_integer <- 1L
if (!this_integer == 1) "Not the same" else "Wrong result"
#> [1] "Wrong result"
```



## Style

### Limit your code to 80 characters per line

For reference, in RStudio you can set a margin column at 80 characters (_Tools > Global Options > Code > Show margin > Margin column_).

> Strive to limit your code to 80 characters per line. This fits comfortably on a printed page with a reasonably sized font. If you find yourself running out of room, this is a good indication that you should encapsulate some of the work in a separate function.

-- <https://style.tidyverse.org/syntax.html#long-lines>

> If a function definition runs over multiple lines, indent the second line to where the definition starts.

-- <https://style.tidyverse.org/functions.html#long-lines-1>



### Names should use only lowercase letters, numbers, and "_".

* Generally, variable names should be nouns and function names should be verbs. 
* Strive for names that are concise and meaningfully!
* Reserve dots exclusively for the S3 object system.

Good.

```R
add_row()
permute()
```

Bad.

```R
row_adder()
permutation()
```

* <https://style.tidyverse.org/syntax.html#object-names>
* <https://style.tidyverse.org/functions.html#naming>



### Avoid `T` and `F` as synonyms for `TRUE` and `FALSE`

Good

```R
sum(1, 1, na.rm = TRUE)
```

Bad.

```R
sum(1, 1, na.rm = T)
```

`TRUE` and `FALSE` are reserved words; `T` and `F` are not.


```r
T <- "Whatever"
T
#> [1] "Whatever"

# Forbidden
try(TRUE <- "Whatever")
#> Error in TRUE <- "Whatever" : 
#>   invalid (do_set) left-hand side to assignment
```

<https://www.r-bloggers.com/r-tip-avoid-using-t-and-f-as-synonyms-for-true-and-false/>



### Reserve `return()` to return early

> Only use `return()` for early returns. Otherwise, rely on R to return the result of the last evaluated expression

<https://style.tidyverse.org/functions.html#return>



### Return invisibly only when the main purpose is a side effect

Good. 


```r
# Main purpose is a side effect: To throw an error if the input is bad
check_f <- function(x) {
  stopifnot(is.numeric(x))
  
  invisible(x)
}
```

Good.


```r
# Main purpose is not a side effect. Returning visibly
f <- function(x) {
  x + 1
}

f(1)
#> [1] 2
```

Bad. 


```r
# Main purpose is not a side effect. Returning invisibly
f <- function(x) {
  out <- x + 1
}

# Returns invisibly
f(1)

out <- f(1)
out
#> [1] 2
```

