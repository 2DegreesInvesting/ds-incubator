# 2020-02-04: R packages: The whole game

***Preparing for a hackaton in March***



_<https://twitter.com/mauro_lepore>_

[ds-incubator issue](https://github.com/2DegreesInvesting/ds-incubator/issues/23)



## Materials

* Slides from the section [Whole game](https://github.com/rstudio-conf-2020/build-tidy-tools/blob/master/1-intro.pdf), from the workshop [Building tidy tools]](https://github.com/rstudio-conf-2020/build-tidy-tools), by Charlotte Wickham and Hadley Wickham ([RStudio conference, 2020](https://github.com/rstudio-conf-2020)).

* Adapted from the book [R packages, Chapter 2: The whole game](https://r-pkgs.org/whole-game.html), by Hadley Wickham and Jenny Bryan.

* Code from [jennybc/foofactors](https://github.com/jennybc/foofactors), by Jenny Bryan.

* [foofactors on rstudio.cloud](https://rstudio.cloud/spaces/47358/project/897002).

<img src="https://i.imgur.com/ex4q4Yw.png" align="center" width = 750 />



## Setup

```R
usethis::use_blank_slate()
```

<img src="https://i.imgur.com/6UCOGyw.jpg" align="center" width = 750 />

[rstd.io/debugging, by Jenny Bryan](https://github.com/jennybc/debugging)



## Setup


```r
library(devtools)
#> Loading required package: usethis
```

Or add this to your file .Rprofile, e.g. with `usethis::edit_r_profile()`:

```R
if (interactive()) {
  suppressMessages(require(devtools))
}
```



## Setup

<img src="https://i.imgur.com/z8WF79m.png" align="center" width = 750 />

<https://style.tidyverse.org/syntax.html#long-lines>



## Nice-to-have usethis options

<img src="https://i.imgur.com/QTnJaHq.png" align="center" width = 750 />



## `create_package()`

* New directory

```R
create_package("pkg")
```

* From inside an existing directory

```R
create_package("../pkg")
```

(If/when https://github.com/r-lib/usethis/pull/916 is merged you should be able to use `create_package(".")`.)

