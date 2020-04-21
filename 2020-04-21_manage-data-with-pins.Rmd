# 2020-04-21: Manage data with pins

## Who is the audience?

Analysts, data managers, software developers at 2DII and beyond.

## Why is this important?

Following a discussion on managing and using data (#35) we concluded we can improve.

Before we invest in any one approach we may want to explore a number of potentially good alternatives. A system would be a good candidate if it has this properties:

- [ ] 1. Allows us to control permissions to read and write data
- [ ] 2. Supports version control with Git and GitHub -- tools we already know.
- [ ] 3. Hosts data online yet allows using a data from a cache stored locally.
- [ ] 4. Can handle datasets of the maximum size we need.
- [ ] 5. Plays well with R, and maybe Python.
- [ ] 6. Is low cost or better free.
- [ ] 7. Implements tools that are as familiar as possible, e.g. git and GitHub as opposed


## What should be covered?

1. Show how the [pins package](http://pins.rstudio.com/) meets these requirements.
2. Discuss what requirements I forgot to list.
3. Questions and answers.

## Suggested speakers or contributors

I plan to run a demo, then expect questions, and comments from everyone else.

## Resources

* [pins package](http://pins.rstudio.com/) 
* [Recording - just demo (10')](https://youtu.be/kS_0s0eS1Xw)
* [Recording - demo + discussion (30')](https://youtu.be/-HtB6duQnD8)

## Q&A and discussion

Questions:

* Where does the cache live?
* Does it work with private repos?
* What happens if I don't have internet?
* How about `memoise::memoise()`?
* What is the maximum size of files we have? (thanks @cjyetman)
* Azure has no upper limit on file size (thanks @AlexAxthelm)
* File format plays an important role (thanks @pranavpandya84)

Suggestions:

Table different alternatives to better see pros and cons (thanks @2diiKlaus)
