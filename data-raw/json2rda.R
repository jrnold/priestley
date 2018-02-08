suppressPackageStartupMessages({
  library("jsonlite")
  library("purrr")
  library("tibble")
  library("stringr")
})

FILENAME <- here::here("data-raw", "priestley1764.json")
priestley <- read_json(FILENAME)

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

priestley %>% map_df(process_bio)
