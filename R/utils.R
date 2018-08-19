add_layout_rows <- function(start, end, hgap = 100, fudge = 1,
                            random = FALSE, k = 0) {
  # keep it "deterministic"
  set.seed(12345)
  # initial guess about number of rows
  years <- seq(min(end, na.rm = TRUE), max(end, na.rm = TRUE),
               by = 10)
  overlapping <- max(map_int(years,
                             function(.x) {
                               sum(.x >= (start - hgap / 2) &
                                     .x <= (end + hgap / 2),
                                   na.rm = TRUE)
                             }))
  n <- overlapping * fudge
  last_values <- rep(-Inf, n)
  rows <- rep(NA_integer_, length(start))
  for (i in seq_along(start)) {
    if (any(start[[i]] > last_values)) {
      choices <- which(start[[i]] > last_values)
      if (random) {
        if (length(choices) == 1L) {
          # If I don't do this, it will interpret a single number as the
          # number of obs to sample
          r <- choices[[1L]]
        } else {
          r <- base::sample(choices, size = 1L, prob = (1 / (seq_along(choices) ^ k)))
        }
      } else {
        r <- min(choices)
      }
    } else {
      # if no open rows, then double the number of rows
      last_values <- c(last_values, rep(-Inf, length(last_values)))
      choices <- which(start[[i]] > last_values)
      if (random) {
        if (length(choices) == 1L) {
          # If I don't do this, it will interpret a single number as the
          # number of obs to sample
          r <- choices[[1L]]
        } else {
          r <- base::sample(choices, size = 1L, prob = (1 / (seq_along(choices) ^ k)))
        }
      } else {
        r <- min(choices)
      }
    }
    rows[[i]] <- r
    last_values[[r]] <- end[[i]] + hgap
  }
  # remove empty rows
  as.integer(as.factor(rows))
}

year_format <- function(x) {
  if_else(x <= 0L, str_c(abs(x - 1L), " ", "BCE"), as.character(x))
}

cent_format <- function(x) {
  cent <- abs(x %/% 100) + 1
  str_c(case_when(
     cent == 1 ~ "1st",
     cent == 2 ~ "2nd",
     cent == 3 ~ "3rd",
     TRUE ~ str_c(cent, "th")
     ), " Century", if_else(x < 0, " BCE", ""))
}

format_person <- function(x) {
  rlang::eval_tidy(quo({
       born_str <- if_else(is.na(born), "",
                          str_c("Born ",
                                if_else(is.na(born_about), "about ", ""),
                                year_format(born), ". "))
       died_str <- if_else(is.na(died), "",
                          str_c("Died ",
                                if_else(died_about, "about ", ""),
                                if_else(died_after, "after ", ""),
                                year_format(died), ". "))
       flourished_str <- if_else(is.na(flourished),
                                "",
                                str_c(
                                  "Flourished ",
                                  if_else(flourished_about, "about ", ""),
                                  if_else(flourished_before, "before ", ""),
                                  if_else(flourished_after, "after ", ""),
                                  if_else(flourished_century,
                                          cent_format(flourished),
                                          year_format(flourished)),
                                  ". "
                                ))
       lived_str <- if_else(is.na(lived), "",
                           str_c("Lived after ", year_format(lived), ". "))
       age_str <- if_else(is.na(age), "", str_c("Age ", age, ". "))
       str_trim(str_c(name, " (", occupation, ") ",
                      born_str, died_str, flourished_str,
                      lived_str, age_str))
  }), data = x)
}