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

format_person <- function(x) {
  # Name. profession. Born. Flourished. Lived. Died. Age.
  glue("{name}")
}

process_bio <- function(x) {
  out <- as_tibble(x[c("name", "text", "division",
                       "description")])
  for (i in c("born_max", "born_min", "died_min", "died_max", "age",
              "in_1764", "in_1778", "in_names_omitted",
              "url", "description")) {
    out[[i]] <- x[[i]]
  }
  for (i in c("occupation", "occupation_abbr", "sect", "sect_abbr")) {
    out[[i]] <- x[[i]] %||% NA_character_
  }
  out[["lifetype"]] <- list(flatten_chr(x[["lifetype"]]))
  for (i in str_subset(names(x), "^(born|died|lived|flourished)")) {
    if (str_detect(i, "(born|died)_(min|max)")) {
      next
    }
    if (str_detect(i, "died")) {
      out[["died"]] <- x[[i]]
      out[["died_about"]] <- str_detect(i, "about")
      out[["died_after"]] <- str_detect(i, "after")
    } else if (str_detect(i, "flourished")) {
      out[["flourished"]] <- x[[i]]
      out[["flourished_about"]] <- str_detect(i, "about")
      out[["flourished_after"]] <- str_detect(i, "after")
      out[["flourished_before"]] <- str_detect(i, "before")
      out[["flourished_century"]] <- str_detect(i, "century")
    } else if (str_detect(i, "born")) {
      out[["born"]] <- x[[i]]
      out[["born_about"]] <- str_detect(i, "about")
    } else if (str_detect(i, "lived")) {
      out[["lived"]] <- x[[i]]
    }
  }
  out
}

create_bios <- function(bios_json) {
  non_missing <- function(x) {
    if (all(is.na(x))) {
      NA_integer_
    } else {
      x[!is.na(x)][[1]]
    }
  }

  bios_json %>%
    read_json() %>%
    map_df(process_bio) %>%
    mutate_at(vars(matches("^(born|died)_(min|max)$")),
              funs(as.integer)) %>%
    mutate(flourished = as.integer(flourished)) %>%
  # order columns
  select(text, name, in_1764, in_1778, in_names_omitted, division, occupation_abbr, occupation,
         sect_abbr, sect, born_max, died_min, born_min, died_max, born, born_about,
         died, died_about,
         died_after, age, flourished, flourished_about, flourished_before,
         flourished_after, flourished_century, lived, lifetype, description)
}

main <- function() {
  args <- commandArgs(TRUE)
  bios_json <- args[[1]]
  output_path <- args[[3]]
  object <- tools::file_path_sans_ext(basename(output_path))
  dir.create(here::here("data"), showWarnings = FALSE, recursive = TRUE)
  e <- new_environment()
  e[[object]] <- create_bios(bios_json)
  save(list = object, file = output_path, envir = e, compress = "bzip2")
}

main()
