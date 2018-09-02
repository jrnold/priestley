suppressPackageStartupMessages({
  library("yaml")
  library("dplyr")
  library("tidyr")
  library("purrr")
  library("rlang")
})

parse_row <- function(x, i) {
  tibble(
    row = i,
    label = names(x),
    name = imap_chr(x, ~ if_else(is.null(.x), .y, .x))
  )
}

parse_division <- function(x, i) {
  imap_dfr(x, parse_row) %>%
    mutate(division = i)
}

main <- function() {
  args <- commandArgs(TRUE)
  biography_path <- args[[1]]
  specimen_path <- args[[2]]
  output_path <- args[[3]]
  object <- tools::file_path_sans_ext(basename(output_path))
  load(biography_path)

  specimen <- read_yaml(specimen_path) %>%
    imap_dfr(parse_division)

  specimen_merged <-
    left_join(specimen,
              select(filter(Biographies, in_1778), -division),
              by = "name") %>%
    # delete duplicatesf
    filter(!(name == "Aratus" & born_min > 0),
           !(name == "Socrates" & born_min > 0)) %>%
    select(row, label, name, division, text, born_min, born_max,
           died_min, died_max)

  dir.create(here::here("data"), showWarnings = FALSE)
  e <- new_environment()
  e[[object]] <- specimen_merged
  save(list = object, file = output_path, envir = e, compress = "bzip2")
}

main()
