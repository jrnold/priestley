# Cleanup the List of Kings in priestley_kings.tsv and save to
# data/priestley_kings.rda
suppressPackageStartupMessages({
  library("dplyr")
  library("readr")
  library("stringr")
})

main <- function() {
  args <- commandArgs(TRUE)
  input_path <- args[[1]]
  output_path <- args[[2]]
  object <- tools::file_path_sans_ext(basename(output_path))
  kings <-
    read_csv(input_path,
             col_types = cols(
             category = col_character(),
             text = col_character(),
             url = col_character(),
             comment = col_character()
            ), na = "") %>%
    select(-url)

  parsed_names <-
    as_tibble(str_match(kings$text, "(.*?)\\s*(\\d+)(?:\\s+(B\\. C\\.))?$"))

  kings[["name"]] <- parsed_names[["V2"]]
  kings[["year"]] <- (as.integer(parsed_names[["V3"]]) *
                        if_else(!is.na(parsed_names[["V4"]]), -1L, 1L))
  kings[["year"]] <- as.integer(kings[["year"]])

  e <- rlang::new_environment()
  e[[object]] <- select(kings, name, year, category)
  save(list = object, file = output_path, compress = "bzip2", envir = e)
}

main()
