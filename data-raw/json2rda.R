#!/usr/bin/env Rscript
#
# Script to convert the json files of parsed Priestley bios to
# rda files, saving them in the data directory
suppressPackageStartupMessages({
  library("jsonlite")
  library("purrr")
  library("tibble")
  library("stringr")
  library("rlang")
})


process_bio <- function(x) {
  out <- as_tibble(x[c("name", "text", "division")])
  out[["category"]] <- x[["category"]] %||% NA_character_
  out[["subcategory"]] <- x[["subcategory"]] %||% NA_character_
  for (i in c("start_1", "start_2", "end_1", "end_2")) {
    out[[i]] <- x[[i]]
  }
  life <- x[str_subset(names(x), "^(born|died|age|lived|flourished)")]
  out[["life"]] <- list(life)
  out
}

json2rda <- function(infile) {
  obj <- tools::file_path_sans_ext(basename(infile))
  outfile <- here::here("data", str_c(obj, ".rda"))
  e <- rlang::new_environment()
  e[[obj]] <- read_json(infile) %>%
    map_df(process_bio)
  dir.create(here::here("data"), showWarnings = FALSE)
  save(list = obj, file = outfile, envir = e, compress = "bzip2")
}

main <- function() {
  infile <- commandArgs(TRUE)[1]
  json2rda(infile)
}

main()

