Checklist to review a pull request
================
Mauro Lepore

  - [master passes tests with no
    failures](#master-passes-tests-with-no-failures)
  - [master passes checkes with 0 errors, 0 warnings, 0
    notes](#master-passes-checkes-with-0-errors-0-warnings-0-notes)
  - [PR loads](#pr-loads)
  - [PR passes tests](#pr-passes-tests)
  - [PR passes checks](#pr-passes-checks)
  - [FIXME/TODO are flagged, and details are
    given/referenced](#fixmetodo-are-flagged-and-details-are-givenreferenced)

### master passes tests with no failures

    git checkout master

``` r
devtools::test()
```

### master passes checkes with 0 errors, 0 warnings, 0 notes

    git checkout master

``` r
devtools::check()
```

### PR loads

    git checkout pr

``` r
devtools::load_all()
```

### PR passes tests

``` r
devtools::test()
```

### PR passes checks

``` r
devtools::check()
```

### FIXME/TODO are flagged, and details are given/referenced

[Common
gotchas](https://github.com/2DegreesInvesting/ds-incubator/issues/11#issuecomment-575837744)
