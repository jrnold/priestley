suppressPackageStartupMessages({
  library("yaml")
  library("dplyr")
  library("tidyr")
  library("purrr")
  library("rlang")
})

main <- function() {
  load(here::here("data", "Biographies.rda"))

  specimen <- read_yaml(here::here("data-raw", "small-chart.yml")) %>%
    imap_dfr(~ tibble(division = .y, name = .x)) %>%
    group_by(division) %>%
    mutate(row = row_number()) %>%
    unnest(name) %>%
    ungroup() %>%
    mutate(id = row_number())

  specimen_merged <-
    left_join(specimen,
              select(filter(Biographies, !is.na(id_1764)), -division),
              by = "name") %>%
    # delete duplicates
    filter(!(name == "Aratus" & start_2 > 0),
           !(name == "Socrates" & start_2 > 0))

  dir.create(here::here("data"), showWarnings = FALSE)
  e <- new_environment()
  e[["Specimen"]] <- specimen_merged
  save(list = "Specimen", file = here::here("data", "Specimen.rda"),
       envir = e, compress = "bzip2")
}

main()
