# 2020-02-18: R packages: Documenting 

<https://github.com/2DegreesInvesting/ds-incubator/issues/26>

## Objectives

* Why documenting your package is important for users and developers.
* How to generate a roxygen skeleton to document a function.
* Why the examples section is important?
* Why README is important?
* What are common README gotchas
    * Why README can't find functions in your package?
    * [Why README should not use tidyverse](https://www.tidyverse.org/blog/2018/06/tidyverse-not-for-packages/)
* How to navigate a package website.



## Why is documenting important?

* How it helps users?
* How it helps developers?
* Why using a consistent format might be useful for users/developers?



## Code > Insert Roxygen Skeleton

```R
#' Title
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
f <- function(x) {
  x
} 
```

--

NOTE:

\@cjyetman recommended to always document explicitly the expected type of each argument to a function. \@2diiKlaus endorsed the comment and asks to do it in all packages we build. \@maurolepore would like to develop a template. Follow [this discussion](https://github.com/2DegreesInvesting/ds-incubator/issues/26#issuecomment-590947607).



## How useful are examples?

* Help users understand how to use a function.
* Help developers understand what a function should do.
* Can be reused in tests/ and README



## README: `usethis::use_readme_rmd()`

Gotchas:

* Used packages (`library()`) need to be listed in DESCRIPTION.
* Your package needs to be installed (`devtools::install()`).
* Needs to be in sync with README.md (i.e. must knit).
* tip: [tidyverse is for EDA not packages](https://www.tidyverse.org/blog/2018/06/tidyverse-not-for-packages/)

(This rigor feels annoying but helps find problems with the package structure.)



## Websites

* `usethis::use_pkgdown()` + `pkgdown::build_site()`.
* GitHub > Settings > GitHub Pages: Choose "master branch docs/ folder"



