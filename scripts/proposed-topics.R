# Based on:
# https://github.com/jennybc/analyze-github-stuff-with-r/blob/master/
#   stat545-discussion-threads.R"

library(gh)
suppressPackageStartupMessages(library(dplyr))
library(tidyr)
suppressPackageStartupMessages(library(purrr))
library(readr)
library(testthat)



owner <- "2DegreesInvesting"
repo <- "ds-incubator"

issue_list <-
  gh("/repos/:owner/:repo/issues", owner = owner, repo = repo,
     state = "all", since = "2019-01-01T00:00:00Z", .limit = Inf)
expect_is(issue_list, "list")



issue_number <- 11
issue_df <- issue_list[issue_number] %>%
  {
    tibble(
      number = map_int(., "number"),
      id = map_int(., "id"),
      title = map_chr(., "title"),
      state = map_chr(., "state"),
      n_comments = map_int(., "comments"),
      opener = map_chr(., c("user", "login")),
      created_at = map_chr(., "created_at") %>% as.Date()
    )
  }

expect_is(issue_df, "tbl_df")
expect_equal(nrow(issue_df), 1L)



comments <- issue_df %>%
  select(number) %>%
  mutate(res = number %>% map(
    ~ gh(number = .x,
         endpoint = "/repos/:owner/:repo/issues/:number/comments",
         owner = owner, repo = repo, .limit = Inf)))

expect_equal(comments$number, 11L)



who_what <- comments %>%
  mutate(who = res %>% map(. %>% map_chr(c("user", "login")))) %>%
  mutate(what = res %>% map(. %>% map_chr("body")))



cat(
  paste(
    paste("##", unlist(who_what$who), "\n\n\n"),  unlist(who_what$what), "\n\n\n"
  )
)
