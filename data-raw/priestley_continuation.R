# Cleanup the List of Kings in continuation.csv and save to
# data/priestley_continuation.rda
#
# This is data from the Appendix "A Catalogue of All the Names in the
# Continuation of the Chart, According to the Hebrew Chronology" (p. 74--75)
# and "The Same According to the Septuagint, as Far as that Chronology
# Differs Considerably from Any Thing in the Hebrew." (p. 76)
suppressPackageStartupMessages({
  library("tidyverse")
})

continuation <-
  read_csv(here::here("data-raw", "continuation.csv"),
         col_types = cols(
           septuagint = col_logical(),
           text = col_character()
         ), na = "")

parsed <- str_match(continuation$text, "(.*?)\\s*(?:fl. (\\d+)|d. (\\d+)(?:\\. (\\d+))?)$")
continuation[["name"]] <- as.character(parsed[ , 2])
continuation[["flourished"]] <- as.integer(parsed[ , 3]) * -1
continuation[["died"]] <- as.integer(parsed[ , 4]) * -1
continuation[["age"]] <- as.integer(parsed[ , 5]) * -1

continuation <-
  mutate(continuation,
       start_1 = case_when(
         !is.na(died) & !is.na(age) ~ died - age,
         !is.na(died) & is.na(age) ~ died - 40,
         !is.na(flourished) ~ flourished - 20),
       start_2 = case_when(
         !is.na(died) & !is.na(age) ~ died - age,
         !is.na(died) & is.na(age) ~ died - 80,
         !is.na(flourished) ~ flourished - 50),
       end_1 = case_when(
         !is.na(died) & !is.na(age) ~ died,
         !is.na(died) & is.na(age) ~ died,
         !is.na(flourished) ~ flourished + 10),
       end_2 = case_when(
         !is.na(died) & !is.na(age) ~ died,
         !is.na(died) & is.na(age) ~ died,
         !is.na(flourished) ~ flourished + 30))

e <- rlang::new_environment()
e[["priestley_continuation"]] <-
  select(continuation, name, died, age, flourished, septuagint)
path = here::here("data", "priestley_continuation.rda")
save(list = ls(e), file = path, compress = "bzip2", envir = e)
