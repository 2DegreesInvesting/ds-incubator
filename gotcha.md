Tackling gotchas: Refactoring code from a script to a package
================
Mauro Lepore

  - [Motivation](#motivation)
      - [What is a gotcha?](#what-is-a-gotcha)
      - [What is refactoring code?](#what-is-refactoring-code)
  - [Function interface](#function-interface)
      - [Avoid relying on the global
        environment](#avoid-relying-on-the-global-environment)
      - [Avoid modifying the global environment, e.g. with
        `<<-`](#avoid-modifying-the-global-environment-e.g.-with--)
      - [Arguments that provide core data are
        required](#arguments-that-provide-core-data-are-required)
      - [Descriptor arguments are usually
        required](#descriptor-arguments-are-usually-required)
      - [Avoid reading and writing
        operations](#avoid-reading-and-writing-operations)
  - [Packaging](#packaging)
      - [Developer setup](#developer-setup)
      - [`use_package("dplyr")` not
        `library(dplyr)`](#use_packagedplyr-not-librarydplyr)
      - [The tidyverse is for EDA, not
        packages](#the-tidyverse-is-for-eda-not-packages)
      - [`use_data_raw()`, then
        `use_data()`](#use_data_raw-then-use_data)
      - [`use_data_raw()`, then
        `use_data()`](#use_data_raw-then-use_data-1)
      - [Use the `.data` pronoun](#use-the-.data-pronoun)
      - [Consider using internal data](#consider-using-internal-data)
  - [Code smells and feels](#code-smells-and-feels)
      - [Simplify `if()` with objects named
        meaningfully](#simplify-if-with-objects-named-meaningfully)
      - [Program for columns with
        `clean_names`](#program-for-columns-with-clean_names)
      - [Avoid long-running temporary
        objects](#avoid-long-running-temporary-objects)
      - [If possible, extract functions to the top
        level](#if-possible-extract-functions-to-the-top-level)
      - [Extract commented sections into
        functions](#extract-commented-sections-into-functions)
  - [Error prone](#error-prone)
      - [Avoid hidden arguments: Extract functions with all
        arguments](#avoid-hidden-arguments-extract-functions-with-all-arguments)
      - [Separate functions, data, and
        scripts](#separate-functions-data-and-scripts)
      - [`if()` uses a single `TRUE` or
        `FALSE`](#if-uses-a-single-true-or-false)
      - [`1` is equal to `1L` but not
        identical](#is-equal-to-1l-but-not-identical)
  - [Style](#style)
      - [Limit your code to 80 characters per
        line](#limit-your-code-to-80-characters-per-line)
      - [Names should use only lowercase letters, numbers, and
        "\_".](#names-should-use-only-lowercase-letters-numbers-and-_.)
      - [Avoid `T` and `F` as synonyms for `TRUE` and
        `FALSE`](#avoid-t-and-f-as-synonyms-for-true-and-false)
      - [Reserve `return()` to return
        early](#reserve-return-to-return-early)

``` r
knitr::opts_chunk$set(
  echo = TRUE,
  comment = "#>",
  error = TRUE,
  collapse = TRUE
)
```

# Motivation

> You and a friend are having a picnic by the side of a river. Suddenly
> you hear a shout from the direction of the water—a child is drowning.
> Without thinking, you both dive in, grab the child, and swim to shore.
> Before you can recover, you hear another child cry for help. You and
> your friend jump back in the river to rescue her as well. Then another
> struggling child drifts into sight … and another … and another. The
> two of you can barely keep up. Suddenly, you see your friend wading
> out of the water, seeming to leave you alone. “Where are you going?”
> you demand. Your friend answers, "I’m going Nopetream to tackle the
> guy who’s throwing all these kids in the water.’

– Irving Zola’s parable adapted by Dan Heath, author of “Nopetream: The
Quest to Solve Problems Before They Happen” (coming out 2020-03-03).

–

<img src="https://4f0imd322ifhg1y4zfwk3wr7-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/NoThanksButWereBusy.png" align="center" width = 750 />

[“No Thanks, We’re Too
Busy”.](https://www.astroarch.com/tvp_strategy/no-thanks-busy-pay-back-technical-debt-40188/)

## What is a gotcha?

*Code that is valid in a script but invalid or unexpected in a package.*

– Adapted from <https://en.wikipedia.org/wiki/Gotcha_(programming)>

## What is refactoring code?

*Restructuring code without changing its external behavior.*

– Adapted from <https://en.wikipedia.org/wiki/Code_refactoring>

# Function interface

## Avoid relying on the global environment

Good.

``` r
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

``` r
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

## Avoid modifying the global environment, e.g. with `<<-`

Setup.

``` r
readr::write_csv(mtcars, "some_data.csv")
```

Good.

``` r
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

``` r
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

> “\[Avoid global variables because they\] introduce non-obvious
> dependencies between functions” – [Advanced R,
> Environments](https://adv-r.hadley.nz/environments.html)).

For valid uses of `<<-` see ([Advanced R, Function
factories](https://adv-r.hadley.nz/function-factories.html#stateful-funs)).

Clean up.

``` r
fs::file_delete("some_data.csv")
```

## Arguments that provide core data are required

Good.

``` r
f <- function(data) {
  data
}

f(mtcars)
```

Bad.

``` r
f <- function(data = mtcars) {
  data
}

f()
```

> Arguments that provide core data are required (have no default); they
> are often called `data`, `x`, or `y`).

– Adapted from <https://principles.tidyverse.org/args-data-details.html>

## Descriptor arguments are usually required

Good.

``` r
forecast <- function(data, start_year, time_span = 5) {
  end_year <- start_year + time_span
  time_period <- data$year >= start_year & data$year <= end_year
  
  data %>%
    filter(time_period) %>%
    # ...
}
```

Bad.

``` r
forecast <- function(data, start_year = 2020, time_span = 5) {
  # ...
}
```

> Descriptor arguments describe essential details of the operation, and
> are usually required.

– Adapted from <https://principles.tidyverse.org/args-data-details.html>

## Avoid reading and writing operations

Unless it is precisely the purpose of your function, avoid operations
that read or write data (in general, avoid side effects).

Good.

``` r
f <- function(data) {
  dplyr::select(data, 1L)
}
```

Bad.

``` r
f <- function(path) {
  data <- readxl::read_excel(path)
  dplyr::select(data, 1L)
}
```

  - [What is a pure
    function](https://github.com/2DegreesInvesting/resources/issues/68).
  - [Avoid hidden arguments
    (ds-incubator)](https://github.com/2DegreesInvesting/ds-incubator/blob/master/2019-12-03_avoid-hidden-arguments.pdf).

# Packaging

## Developer setup

``` r
library(usethis)
library(devtools)
```

Maybe edit your .Rprofile.

``` r
edit_r_profile()
```

## `use_package("dplyr")` not `library(dplyr)`

Good.

``` r
use_package("dplyr")
```

Bad.

``` r
library(dplyr)
```

<https://r-pkgs.org/whole-game.html>

## The tidyverse is for EDA, not packages

Good.

``` r
use_package("dplyr")
use_package("tidyr")
```

Bad.

``` r
use_package("tidyverse")
```

<https://www.tidyverse.org/blog/2018/06/tidyverse-not-for-packages/>

## `use_data_raw()`, then `use_data()`

Good.

``` r
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

## `use_data_raw()`, then `use_data()`

Bad.

``` r
# R/any-file.R
dataset_name <- readxl::read_excel("data/dataset-name.xlsx")

f <- function() {
  dataset_name
}
```

<http://r-pkgs.had.co.nz/data.html>

## Use the `.data` pronoun

Good.

``` r
f <- function(data, column_name) {
  dplyr::select(data, .data[[column_name]])
}
```

Ok.

``` r
f <- function(data) {
  stopifnot(hasName(mtcars, "cyl"))
  
  dplyr::select(data, .data$cyl)
}
```

Bad.

``` r
f <- function(data) {
  dplyr::select(data, cyl)
}
```

<https://rlang.r-lib.org/reference/tidyeval-data.html>

## Consider using internal data

Good.

``` r
# data-raw/my_internal_data.R
use_data(my_internal_data, internal = TRUE)

# R/any.R
f <- function(data) {
  dplyr::left_join(data, my_internal_data)
}
```

Bad.

``` r
# R/any.R
my_internal_data <- mtcars %>% dplyr::select(cyl)

f <- function(data) {
  dplyr::left_join(data, my_internal_data)
}
```

<http://r-pkgs.had.co.nz/data.html#data-sysdata>

# Code smells and feels

## Simplify `if()` with objects named meaningfully

``` r
x <- sample(c(1:10), size = 2, replace = TRUE)
say <- function(x, msg) paste(paste(x, collapse = ", "), msg)
say(1:2, "Hey!")
#> [1] "1, 2 Hey!"
```

Good.

``` r
is_even_between_5and10 <- (x %% 2 == 0) & dplyr::between(x, 5L, 10L)
if (all(is_even_between_5and10)) {
  say(x, "Yeah!")
} else {
  say(x, "Nope!")
}
#> [1] "10, 3 Nope!"
```

Bad.

``` r
if (all((x %% 2 == 0) & (x >= 5L) & (x <= 10L))) {
  say(x, "Yeah!")
} else {
  say(x, "Nope!")
}
#> [1] "10, 3 Nope!"
```

<https://speakerdeck.com/jennybc/code-smells-and-feels?slide=36>

## Program for columns with `clean_names`

Good.

``` r
f <- function(data) {
  clean <- r2dii.utils::clean_column_names(data)
  
  stopifnot(hasName(clean, "a_column"))
  result <- dplyr::select(clean, .data$a_column)
  
  r2dii.utils::unclean_column_names(result, data)
}

f(tibble::tibble(A.Column = 1, Another.Column = 1))
#> # A tibble: 1 x 1
#>   A.Column
#>      <dbl>
#> 1        1
```

Bad.

``` r
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

## Avoid long-running temporary objects

Avoid temporary variables unless they run for only a few, consecutive
lines.

Good.

``` r
tmp <- dplyr::filter(mtcars, cyl > 4)
tmp <- dplyr::select(tmp, disp)
tmp <- head(tmp)

# ... more unrelated code
```

Better.

``` r
mtcars %>% 
  dplyr::filter(cyl > 4) %>% 
  dplyr::select(disp) %>% 
  head()
```

Bad.

``` r
tmp <- dplyr::filter(mtcars, cyl > 4)
tmp <- dplyr::select(tmp, disp)

# ... more unrelated code (makes your forget what `tmp` holds)

tmp <- head(tmp)
```

## If possible, extract functions to the top level

Good.

``` r
f <- function(x) {
  g(x)
}

g <- function(x) {
  x + 1
}
```

Bad.

``` r
f <- function(x) {
  g <- function(x) {
    x + 1
  }
  
  g(x)
}
```

## Extract commented sections into functions

Good.

``` r
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

``` r
f <- function(x) {
  # calculate y
  y <- x^x * x/2L
  # ... more code specifically about calculating y
  
  # ... more code
}
```

# Error prone

## Avoid hidden arguments: Extract functions with all arguments

Good.

``` r
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

``` r
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

## Separate functions, data, and scripts

### A non-package project

It’s easy for an analyst to maintain a project when functions, data, and
scripts are separate.

Good.

``` r
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

It is error prone to mix functions, data, and scripts. The mess hides
inter dependencies that can break your code unexpectedly. Also, this
makes it hard for others to reproduce, or understand your code – [the
maintainance programmer can only view your code through a toilet paper
tube](https://github.com/2DegreesInvesting/resources/issues/38#issuecomment-576383067).

Bad.

``` r
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

When functions, data, and scripts are separate, it’s easy for a
developer to transform a project into an R package. Functions go in the
R/ directory, raw data in data-raw/, and data in data/. Scripts become
examples, tests, and higher level documentation such as README, and the
Home and articles pages of the package-website.

## `if()` uses a single `TRUE` or `FALSE`

``` r
x <- c(1, 2)
y <- 0L
```

Good

``` r
# Good
if (identical(x, c(1, 2))) {
  say(identical(x, c(1, 2)), "is what you gave.")
}
#> [1] "TRUE is what you gave."
```

``` r
# Bad
if (x == c(1, 2)) {
  say(x == c(1, 2), "is what you gave.")
}
#> Warning in if (x == c(1, 2)) {: the condition has length > 1 and only the first
#> element will be used
#> [1] "TRUE, TRUE is what you gave."
```

Caveats: <https://github.com/2DegreesInvesting/ds-incubator/issues/13>

## `1` is equal to `1L` but not identical

Careful\!

``` r
1 == 1L
#> [1] TRUE
identical(1, 1L)
#> [1] FALSE
```

Good

``` r
this_integer <- 1L
if (!identical(this_integer, 1)) "Not the same" else "Wrong result"
#> [1] "Not the same"
```

Bad.

``` r
this_integer <- 1L
if (!this_integer == 1) "Not the same" else "Wrong result"
#> [1] "Wrong result"
```

# Style

## Limit your code to 80 characters per line

For reference, in RStdio you can set a margin column at 80 characters
(*Tools \> Global Options \> Code \> Show margin \> Margin column*).

> Strive to limit your code to 80 characters per line. This fits
> comfortably on a printed page with a reasonably sized font. If you
> find yourself running out of room, this is a good indication that you
> should encapsulate some of the work in a separate function.

– <https://style.tidyverse.org/syntax.html#long-lines>

> If a function definition runs over multiple lines, indent the second
> line to where the definition starts.

– <https://style.tidyverse.org/functions.html#long-lines-1>

## Names should use only lowercase letters, numbers, and "\_".

  - Generally, variable names should be nouns and function names should
    be verbs.
  - Strive for names that are concise and meaningfully\!
  - Reserve dots exclusively for the S3 object system.

Good.

``` r
add_row()
permute()
```

Bad.

``` r
row_adder()
permutation()
```

  - <https://style.tidyverse.org/syntax.html#object-names>
  - <https://style.tidyverse.org/functions.html#naming>

## Avoid `T` and `F` as synonyms for `TRUE` and `FALSE`

Good

``` r
sum(1, 1, na.rm = TRUE)
```

Bad.

``` r
sum(1, 1, na.rm = T)
```

`TRUE` and `FALSE` are reserved words; `T` and `F` are not.

``` r
T <- "Whatever"
T
#> [1] "Whatever"

# Forbidden
try(TRUE <- "Whatever")
#> Error in TRUE <- "Whatever" : 
#>   invalid (do_set) left-hand side to assignment
```

<https://www.r-bloggers.com/r-tip-avoid-using-t-and-f-as-synonyms-for-true-and-false/>

## Reserve `return()` to return early

> Only use `return()` for early returns. Otherwise, rely on R to return
> the result of the last evaluated expression

<https://style.tidyverse.org/functions.html#return>
