# Cleanup the List of Kings in priestley_kings.tsv and save to
# data/priestley_kings.rda
suppressPackageStartupMessages({
  library("dplyr")
  library("readr")
  library("stringr")
})

main <- function() {
  kings <-
    read_tsv(here::here("data-raw", "priestley_kings.tsv"),
             col_types = cols(
               category = col_character(),
               text = col_character()
             ), na = "")

  parsed_names <-
    as_tibble(str_match(kings$text, "(.*?)\\s*(\\d+)(?:\\s+(B\\. C\\.))?$"))

  kings[["name"]] <- parsed_names[["V2"]]
  kings[["year"]] <- (as.integer(parsed_names[["V3"]]) *
                        if_else(!is.na(parsed_names[["V4"]]), -1, 1))

  e <- rlang::new_environment()
  e[["Kings"]] <- select(kings, name, year, category)
  path = here::here("data", "Kings.rda")
  save(list = ls(e), file = path, compress = "bzip2", envir = e)
}

main()
