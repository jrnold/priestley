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
  load(here::here("data", "Biographies.rda"))

  specimen <- read_yaml(here::here("data-raw", "small-chart.yml")) %>%
    imap_dfr(parse_division)

  specimen_merged <-
    left_join(specimen,
              select(filter(Biographies, in_1778), -division),
              by = "name") %>%
    # delete duplicatesf
    filter(!(name == "Aratus" & born_min > 0),
           !(name == "Socrates" & born_min > 0)) %>%
    select(-in_1764, -in_1778, -sect, -sect_abbr, -in_names_omitted)

  dir.create(here::here("data"), showWarnings = FALSE)
  e <- new_environment()
  e[["Specimen"]] <- specimen_merged
  save(list = "Specimen", file = here::here("data", "Specimen.rda"),
       envir = e, compress = "bzip2")
}

main()
