---
title: Installing packages in R
author: CJ
date: '2019-11-19'
slug: installing-packages-notes
categories: []
tags:
  - r
description: ''
---

# 2019-11-19: Installing packages in R

[CJ Yetman](https://github.com/orgs/2DegreesInvesting/people/cjyetman)

- Installing packages in R is more complicated than it seems

- Structure of a package
    - R files
    - Text based config files
    - Help files
    - Potentially source files in other languages (C, C++, Fortran, etc.)
- Submitted to CRAN, hosted on GitHub, or hosted on other CRAN-like repository (BioConductor, private repos, local etc.)
- Packages are primarily distributed as source packages (raw text files just as you would see in a GitHub repo for a package)
    - BUT… some repos, like CRAN, pre-compile source packages into binaries which are platform specific
- EASY - when you install a binary package (if one is available for your platform), your R environment won’t have to do any processing to make the package work
- EASY - if only a source version of the package is available *and* the package is written entirely in R (plus various text config files and help files), your R environment should be able to process the package and prepare it for use on your machine without any trouble
- EASY->NIGHTMARE - if only a source version of the package is available *and* the package includes source files written in a language other than R, your machine will need to be fully setup as a development environment for whatever other languages are used
    - macOS: command line developer tools plus custom clang and fortran
        - https://cran.r-project.org/bin/macosx/tools/
    - Windows: Rtools
        - https://cran.r-project.org/bin/windows/Rtools/
- Suggestion: Install binary packages whenever possible

- remotes::install_github() (devtools::install_github())
    - devtools is a package of tools to help with package development
    - remotes was created from just the install functions of devtools to create a light-weight package for installing from different locations
    - There are numerous remotes::install_* functions
    - These will install packages directly from their development repository
    - Installs as *source*, with all the potential problems above
    - Sometimes advantageous to get recent bug fixes etc. that have not been released on CRAN yet
