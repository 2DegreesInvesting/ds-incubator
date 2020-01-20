Checklist to review a pull request
================
Mauro Lepore

  - [master passes tests with no
    failures](#master-passes-tests-with-no-failures)
  - [master passes checkes with 0 errors, 0 warnings, 0
    notes](#master-passes-checkes-with-0-errors-0-warnings-0-notes)
  - [PR loads](#pr-loads)
  - [PR passes tests](#pr-passes-tests)
  - [PR passes checks with 0 errors, 0 warnings, and 0
    notes](#pr-passes-checks-with-0-errors-0-warnings-and-0-notes)
  - [A minimal regression test captures expected
    behaviour](#a-minimal-regression-test-captures-expected-behaviour)
  - [Can document](#can-document)
  - [Can run examples](#can-run-examples)
  - [pkgdown website builds](#pkgdown-website-builds)
  - [All exported functions appear in website’s
    reference](#all-exported-functions-appear-in-websites-reference)
  - [FIXME/TODO are flagged, and details are
    given/referenced](#fixmetodo-are-flagged-and-details-are-givenreferenced)

## master passes tests with no failures

    git checkout master

``` r
devtools::test()
```

## master passes checkes with 0 errors, 0 warnings, 0 notes

    git checkout master

``` r
devtools::check()
```

## PR loads

    git checkout pr

``` r
devtools::load_all()
```

## PR passes tests

``` r
devtools::test()
```

## PR passes checks with 0 errors, 0 warnings, and 0 notes

Some note may remain, but the number of errors warnings must be 0.

``` r
devtools::check()
```

  - Called `use_package()` to use packages
    (e.g. `use_package("dplyr")`).
  - Using `package::function` format or `#' @importFrom package
    function`

<!-- end list -->

``` r
f <- function(data) {
  dplyr::filter(data)
}

# Or

#' @importFrom dplyr filter
f <- function(data) {
  filter(data)
}
```

## A minimal regression test captures expected behaviour

## Can document

## Can run examples

## pkgdown website builds

## All exported functions appear in website’s reference

## FIXME/TODO are flagged, and details are given/referenced

[Common
gotchas](https://github.com/2DegreesInvesting/ds-incubator/issues/11#issuecomment-575837744)
