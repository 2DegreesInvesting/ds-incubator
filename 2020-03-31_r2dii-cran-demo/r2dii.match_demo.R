# lets look now at the `r2dii.match` package, which can be fully demonstrated using `r2dii.data` datasets
library(r2dii.match)

# first of all, we can pull up documentation for the package itself
?r2dii.match

# for this demo, we are going to need a couple datasets from `r2dii.data`
loanbook <- r2dii.data::loanbook_demo
ald <- r2dii.data::ald_demo

# as well as a name/sector overwrite template (which we will discuss later)
overwrite <- r2dii.data::overwrite_demo

# first lets have a look at the fuzzy matching algorithm
?match_name

# lets run the matching algorithm with all default arguments left as default
matched <- loanbook %>%
  match_name(ald)

View(matched)

# the by_sector flag, only attempts matches if ald and loanbook sector are identical
match_name(your_loanbook, your_ald, by_sector = FALSE) %>%
  nrow()

# compare
match_name(your_loanbook, your_ald, by_sector = TRUE) %>%
  nrow()

# minimum threshold for fuzzy-matching can be set using min_score
matched <- match_name(your_loanbook, your_ald, min_score = 0.9)
range(matched$score)

# if you wish to manually add aditional matches, this is achieved by internally overwriting the name or sector of the loanbook company
View(overwrite)

matched <- match_name(
  loanbook, ald, min_score = 0.9, overwrite = overwrite
)

matched %>%
  dplyr::filter(name == "bee handshoe") %>%
  View()

# Pretend we validated the matched dataset
valid_matches <- matched

some_interesting_columns <- vars(id_2dii, level, score)

valid_matches %>%
  prioritize() %>%
  select(!!! some_interesting_columns)

prioritize_level(matched)

matched %>%
  prioritize(priority = rev) %>%
  select(!!! some_interesting_columns)
