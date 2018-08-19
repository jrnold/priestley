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

load_categories <- function() {
  data <- yaml::read_yaml(here::here("data-raw", "Categories.yml"))
  list(
    occupations = map(data$divisions, "occupations") %>%
      purrr::flatten() %>%
      imap_dfr(~ tibble(occupation_abbr = .y,
                        occupation = .x$label)),
    sects = data$divisions[[2]]$occupations[["H P"]]$sects %>%
      imap_dfr(~ tibble(sect_abbr = .y, sect = .x$name))
  )
}

format_person <- function(x) {
  # Name. profession. Born. Flourished. Lived. Died. Age.
  glue("{name}")
}

process_bio <- function(x) {
  out <- as_tibble(x[c("name", "text", "division")])
  out[["occupation"]] <- x[["occupation"]] %||% NA_character_
  out[["sect"]] <- x[["sect"]] %||% NA_character_
  for (i in c("start_1", "start_2", "end_1", "end_2", "age")) {
    out[[i]] <- x[[i]]
  }
  for (i in str_subset(names(x), "^(born|died|lived|flourished)")) {
    if (str_detect(i, "died")) {
      out[["died"]] <- x[[i]][["value"]]
      out[["died_about"]] <- str_detect(i, "about")
      out[["died_after"]] <- str_detect(i, "after")
    } else if (str_detect(i, "flourished")) {
      out[["flourished"]] <- x[[i]][["value"]]
      out[["flourished_about"]] <- str_detect(i, "about")
      out[["flourished_after"]] <- str_detect(i, "after")
      out[["flourished_before"]] <- str_detect(i, "before")
      out[["flourished_century"]] <- x[[i]][["century"]]
    } else if (str_detect(i, "born")) {
      out[["born"]] <- x[[i]][["value"]]
      out[["born_about"]] <- str_detect(i, "about")
    } else if (str_detect(i, "lived")) {
      out[["lived"]] <- x[[i]][["value"]]
    }
  }
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

  categories <- load_categories()

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
    mutate_at(vars(matches("^(id|start|end)_")),
              funs(as.integer)) %>%
    mutate(flourished = as.integer(flourished)) %>%
    rename(occupation_abbr = occupation,
           sect_abbr = sect) %>%
    left_join(categories[["occupations"]], by = "occupation_abbr") %>%
    left_join(categories[["sects"]], by = "sect_abbr") %>%
    mutate(occupation = if_else(division == "Statesmen and Warriors",
                                "Politician/Military Person", occupation)) %>%
  # order columns
  select(text, name, id_1764, id_1778, division, occupation_abbr, occupation,
         sect_abbr, sect, start_1, end_1, start_2, end_2, born, born_about,
         died, died_about,
         died_after, age, flourished, flourished_about, flourished_before,
         flourished_after, flourished_century, lived)
}

main <- function() {
  dir.create(here::here("data"), showWarnings = FALSE, recursive = TRUE)
  e <- new_environment()
  e[["Biographies"]] <- create_bios()
  save(list = "Biographies", file = here::here("data", "Biographies.rda"),
       envir = e, compress = "bzip2")
}

main()
