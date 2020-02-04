---
output:
  pdf_document: default
  html_document: default
---
# 2020-02-04: R packages: Setup 



## <https://r-pkgs.org/whole-game.html>

<img src="https://i.imgur.com/spXKlG3.png" align="center" width = 750 />



## The demo package

On RStudio desktop, I created the demo package and pushed it to GitHub.

```R
create_package("demo")
use_git()
use_github("2degreesinvesting")
```

* On GitHub, I forked the demo package from [2degreesinvesting/demo](https://github.com/2DegreesInvesting/demo) to [maurolepore/demo](https://github.com/maurolepore/demo).

* On the ds-incubator workspace on rstudio.cloud, I created a new repo from GitHub and added packages from the base project (devtools and friends).

<img src="https://i.imgur.com/hmsP7WH.png" align="center" width = 400 />

* You may copy the demo project from rstudio.cloud: <https://rstudio.cloud/spaces/47358/project/908370>



## [Packaging gotchas](https://2degreesinvesting.github.io/ds-incubator/gotchas-when-moving-code-from-a-script-to-an-r-package.html)
