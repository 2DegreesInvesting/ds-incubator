# 2020-05-19: Azure, RStudio server, and pins

This meetup is structured as a mini-workshop. You learn about three tools you can combine to improve the way you manage data: Azure, RStudio server and the pins package. As a side effect you will also learn a system we plan to use in a longer workshop.

Find materials are at <https://github.com/2DegreesInvesting/ds-incubator/issues/45>; the most important document to follow along is <https://bit.ly/dsi-pin-azure>.



## Introduction

Open `00_intro-rmd.Rmd`

The goal of this section is to practice the tools we'll be using later:

* A collaborative document.
* Zoom.
* RMarkdown documents.

Managing these three things at once is hard and will likely distract you from learning anything. A little practice will help you will master these tools so you can focus on the content of the lessons to come.

### Objective

* Run a code chunk.
* Click "yes" on the "Participants" tab on Zoom.
* Write "hi" in the "Questions section for this lesson on https://bit.ly/dsi-pin-azure. This is just to ensure you know where we expect you to ask questions.

### RMarkdown notebooks

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code. 

R code goes in **code chunks**, denoted by three backticks. Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Crtl+Shift+Enter* (Windows) or *Cmd+Shift+Enter* (Mac).


```r
packageVersion("pins")
```




## Setup an Azure board for pins

Open `01_setup-azure-board.Rmd`

### Objective

* Setup an Azure board for pins.

### Setup an Azure board for pins

* Open your .Renviron file with `usethis::edit_r_environ()`.
* Add this:


```bash
AZURE_STORAGE_CONTAINER="test-container"
AZURE_STORAGE_ACCOUNT="2diiteststorage"
# Not my real key
AZURE_STORAGE_KEY="ABABAB...=="
```

* Replace "ABABAB...==" with the value I'll share privately.
* Ensure the file ends with a new line.
* Save, close, and restart R.
* Set these variables in you .Renviron. See `?usethis::edit_r_environ()`.



## Use an Azure board

Open 02_use-azure-board.Rmd

<https://bit.ly/dsi-pin-azure>

### Objectives

* Use the pins package and register our Azure board
* Find datasets in our Azure board
* Get a dataset from our Azure board
* Save processed data to the server's cache
* Visualize the structure of the server's cache.

### Use the pins package and register our Azure board

* Use the pins package with `library(pins)`.
* Register our Azure board with `board_register_azure()`


```r
library(pins)
board_register_azure()
```



### Find datasets in our Azure board

* Find pins on our Azure board from the Connections tab.
* Find pins on our Azure board with the Addin "Find pins".
* Find pins on our Azure board with `pin_find()`, by name or description.


```r
pin_find("mtc", board = "azure")
```



### Get a dataset from our Azure board

* Get the `mtcars` dataset from our Azure board with `pin_get()`.
* Assign the result to the object `mydata`.
* Inspect mydata however you like. How many rows does it have?


```r
mydata <- pin_get("mtcars", board = "azure")
mydata
```



### Save processed data to the server's cache

* Get the `head()` of `mydata` and assign it to a new object `smalldata`.


```r
smalldata <- head(mydata)
smalldata
```

* Store `smalldata` in you local (server) cache with `pin()`


```r
pin(smalldata)
```

* Find "smalldata" in your local (server) cache, however you like.


```r
pin_find("smalldata")
```

* Get "smalldata" from your local (server) cache.


```r
pin_get("smalldata")
```



### Visualize the structure of the server's cache.

* Create a path to the local (server) cache that pins created for you.


```r
server_cache <- board_cache_path()
server_cache
```

* Explore the structure of the local (server) cache with fs::dir_tree().


```r
fs::dir_tree(server_cache)
```



### Takeaways

* Go to the collaborative document and write your takeaways.

<bit.ly/dsi-pin-azure>

