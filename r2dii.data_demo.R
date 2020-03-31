# to install r2dii.data and r2dii.match
packages <- c("r2dii.data", "r2dii.match")

install.packages(packages)

library(r2dii.data)
library(r2dii.match)

# first lets look at r2dii.data
# we can view all datasets in this package (along with field specifications and definitions) using
r2dii.data::data_dictionary %>%
  View()

# relevant information can also of course be found at
# https://2degreesinvesting.github.io/r2dii.data/reference/index.html

# in particular, lets take a look at a...
# ...fake loanbook data
r2dii.data::loanbook_demo %>%
  View()

# we can also pull up documentation for this data.frame
# all documentation is also available, in identical format, on the package website
?r2dii.data::loanbook_demo

# or save it into our global environment
loanbook <- r2dii.data::loanbook_demo

# ...similar for the fake ald
r2dii.data::ald_demo %>%
  View()

# we also have included sector classification bridges
r2dii.data::isic_classification %>%
  View()

# as well as a view of all currently existing bridges
r2dii.data::sector_classifications %>%
  View()

# all of this data is SYNTHETIC and FAKE, and can be used for demonstration
# (e.g. for banks to run through a mock analysis tutorial prior to using the tool)
# but also for writing unit tests and developing new features!
