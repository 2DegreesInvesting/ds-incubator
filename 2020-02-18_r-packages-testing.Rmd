# 2020-02-18: Testing

From <https://r-pkgs.org/tests.html>



## Why?



## How?

```R
usethis::use_testthat()
```

* R/a_function.R

```R

```

* tests/testthat/test-a_function.R

```R
test_that("a_function ....", {
  expect_that(a_)
})
```

* Hierarchical structure



## What

> Whenever you are tempted to type something into a print statement or a debugger expression, write it as a test instead. — Martin Fowler



## What

* Test what should work
* Test what should fail and how

