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
  library("dplyr")
})

process_bio <- function(x) {
  out <- as_tibble(x[c("name", "text", "division")])
  out[["category"]] <- x[["category"]] %||% NA_character_
  out[["sect"]] <- x[["subcategory"]] %||% NA_character_
  for (i in c("start_1", "start_2", "end_1", "end_2")) {
    out[[i]] <- x[[i]]
  }
  # life <- x[str_subset(names(x), "^(born|died|age|lived|flourished)")]
  # out[["life"]] <- list(life)
  out
}

create_bios <- function() {
  non_missing <- function(x) {
    if (all(is.na(x))) {
      NA_integer_
    } else {
      x[!is.na(x)][[1]]
    }
  }

  list(here::here("data-raw", "priestley_bios_1764.json") %>%
         read_json() %>%
         map_df(process_bio) %>%
         ungroup() %>%
         mutate(id_1764 = row_number()),
       here::here("data-raw", "priestley_bios_1778.json") %>%
        read_json() %>%
        map_df(process_bio) %>%
        ungroup() %>%
        mutate(id_1778 = row_number())
  ) %>%
  bind_rows() %>%
  group_by(text) %>%
  mutate_at(vars(id_1764, id_1778), funs(non_missing)) %>%
  slice(1) %>%
  mutate_at(vars(matches("^id_"), matches("^start_"), matches("^end_")),
            funs(as.integer)) %>%
  mutate()
}

main <- function() {
  dir.create(here::here("data"), showWarnings = FALSE, recursive = TRUE)
  e <- new_environment()
  e[["Biographies"]] <- create_bios()
  save(list = "Biographies", file = here::here("data", "Biographies.rda"),
       envir = e, compress = "bzip2")
}

main()
