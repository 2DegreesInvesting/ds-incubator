Checklist to review a pull request
================
Mauro Lepore

  - [master passes tests with no
    failures](#master-passes-tests-with-no-failures)
  - [master passes checks with 0 errors, 0 warnings, 0
    notes](#master-passes-checks-with-0-errors-0-warnings-0-notes)
  - [Package loads](#package-loads)
  - [Package passes tests](#package-passes-tests)
  - [Package passes checks with 0 errors, 0 warnings, and 0
    notes](#package-passes-checks-with-0-errors-0-warnings-and-0-notes)
  - [Uses functions from other packages
    correctly](#uses-functions-from-other-packages-correctly)
  - [Captures expected behavior in `#'
    @examples`](#captures-expected-behavior-in-examples)
  - [Captures expected behavior in
    tests](#captures-expected-behavior-in-tests)
  - [Captures expected behavior of exported functions in
    README](#captures-expected-behavior-of-exported-functions-in-readme)
  - [Documents internal functions clearly
    enough](#documents-internal-functions-clearly-enough)
  - [Documents exported functions in
    full](#documents-exported-functions-in-full)
  - [Connects similar documentation (e.g. via `@rdname`, `@seealso`,
    `@family`)](#connects-similar-documentation-e.g.-via-rdname-seealso-family)
  - [pkgdown website builds](#pkgdown-website-builds)

## master passes tests with no failures

    git checkout master

``` r
devtools::test()
```

## master passes checks with 0 errors, 0 warnings, 0 notes

    git checkout master

``` r
devtools::check()
```

## Package loads

    git checkout pr

``` r
devtools::load_all()
```

## Package passes tests

``` r
devtools::test()
```

## Package passes checks with 0 errors, 0 warnings, and 0 notes

Some note may remain, but the number of errors warnings must be 0.

## Uses functions from other packages correctly

  - Call `use_package()` to use packages (e.g. `use_package("dplyr")`).

And,

  - Use `package::function` or `#' @importFrom package function` to use
    a specific function:

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

## Captures expected behavior in `#' @examples`

## Captures expected behavior in tests

## Captures expected behavior of exported functions in README

## Documents internal functions clearly enough

## Documents exported functions in full

## Connects similar documentation (e.g. via `@rdname`, `@seealso`, `@family`)

## pkgdown website builds
