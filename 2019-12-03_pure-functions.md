
# What Is a Pure Function?

### [Pure functions in programming and their benefits](https://medium.com/better-programming/what-is-a-pure-function-3b4af9352f6f)

*<https://twitter.com/mauro_lepore>*

License: [CCO](https://creativecommons.org/choose/zero/?lang=es)

## Pure function

A function that has the following properties:

1.  The function always returns the same value for the same inputs.

2.  Evaluation of the function has no side effects (give feedback or
    change global state – see [Side-effect
    soup](https://principles.tidyverse.org/side-effect-soup.html#side-effect-soup))

Effectively, a pure function’s return value is based only on its inputs
and has no other dependencies or effects on the overall program.

## Avoid hidden arguments

<https://principles.tidyverse.org/args-hidden.html>
