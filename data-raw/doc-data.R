suppressPackageStartupMessages({
  library("yaml")
  library("glue")
  library("stringr")
  library("tibble")
  library("readr")
  library("purrr")
})

create_docs <- function(docs, input) {
  load(input, envir = e <- rlang::new_environment())

  name <- ls(e)[[1]]

  docs <- read_yaml(docs) %>%
    pluck("resources") %>%
    keep(~ .$name == name) %>%
    pluck(1)

  contents <- glue(
    "#' <title>",
    "#'",
    "<description>",
    "#'",
    "#' @format A data frame with <rows> rows and <cols> columns.",
    "#' \\describe{",
    "<columns>",
    "#'}",
    "#'",
    "#' @docType data",
    "\"<name>\"",
    .sep = "\n",
    .open = "<",
    .close = ">",
    .envir = list(
      title = docs$title,
      description = str_c(strwrap(docs$description, 75,
                                  prefix = "#' ", initial = "#' "),
                          collapse = "\n"),
      columns = docs$schema$fields %>%
        map(~ .x[c("name", "type", "description")]) %>%
        map_dfr(as_tibble) %>%
        glue_data("#' \\item{<name>}{(<type>) <str_trim(description)>}",
                  .open = "<",
                  .close = ">") %>%
        glue_collapse(sep = "\n"),
      rows = nrow(e[[name]]),
      cols = ncol(e[[name]]),
      name = name
    )
  )

  output <- here::here("R", str_c(name, ".R"))
  cat(glue("Writing to {output}"), "\n")
  write_file(contents, output)
}

args <- commandArgs(TRUE)

create_docs(args[[1]], args[[2]])
