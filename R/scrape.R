# Get some meme templates
library(rvest)
library(dplyr)
library(purrr)
library(glue)

N_MAX = 4

walk(1:N_MAX, function(i) {
  url <- glue("https://imgflip.com/memesearch?q=lotr&page={i}")
  paths <- url %>%
    read_html() %>%
    html_nodes(css = ".shadow") %>%
    html_attr("src") %>%
    paste0("https:", .)

  names <- paths %>%
    stringr::str_remove("https://") %>%
    stringr::str_replace_all("/", "_") %>%
    paste0("img/", .)
  walk2(paths, names, download.file)
})


