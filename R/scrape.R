# Get some meme templates
library(rvest)
library(dplyr)
library(purrr)
library(glue)

N_MAX <- 4
BASE_URL <- "https://imgflip.com"

download_meme <- function(link) {
  file <- link %>%
    read_html() %>%
    html_node(css = "#mtm-img") %>%
    html_attr("src") %>%
    stringr::str_remove("//")
  path <- glue("img/{stringr::str_remove(file, 'i.imgflip.com/')}")
  download.file(file, path)
}

walk(1:N_MAX, function(i) {
  url <- glue("https://imgflip.com/memesearch?q=lotr&page={i}")
  links <- url %>%
    read_html() %>%
    html_nodes(css = ".mt-title a") %>%
    html_attr("href") %>%
    paste0(BASE_URL, .)

  links <- links[2:length(links)]
  walk(links, download_meme)
})


