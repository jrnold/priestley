context("Biographies")
library(glue)
library(stringr)
library(rlang)
library(purrr)

data("Specimen", package = "priestley")

ROWS <- list("Men of Learning" = c(1, 4, 4, 4, 6, 4, 4, 3),
             "Statesmen" = c(3, 5, 4, 6, 5, 4, 2))

ENUM <- list(
  divisions = c("Mathematicians and Physicians", "Statesmen and Warriors",
                "Divines and Metaphysicians", "Poets and Artists",
                "Historians, Antiquarians, and Lawyers", "Orators and Critics"),
  occupation = c("Physician",  "Christian Religious Person", "Poet",
                 "Jewish Religious Person",
                 "Historian", "Geographer", "Lawyer", "Philosopher",
                 "Mathematician",
                 "Critic", "Pope", "Christian Father", "Orator", "Architect",
                 "Painter", "Musician", "Muslim Religious Person", "Antiquary",
                 "Metaphysician", "Moralist", "Actor", "Statuary", "Writer",
                 "Printer",
                 "Chemist", "Political Writer", "Chronologer", "Traveller",
                 "Engineer", "Engraver", "Politician/Military Person"),
  occupation_abbr = c("Ph", "D", "P", "J", "H", "Geo", "L", "H P", "M", "Cr",
                      "Po", "F", "Or", "Ar", "Pa", "Mu", "Moh", "Ant", "Met", "Mor",
                      "Act", "St", "Bel", "Pr", "Chy", "Pol", "Ch", "Trav", "Engineer",
                      "Eng"),
  sect_abbr = c("Soc", "Ital", "Ion", "Eleat", "Per", "Cyr", "Ac", "Sto",
                "Cyn", "Meg", "Ep", "Eleack", "Scept"),
  sect = c("Socratic", "Italic", "Ionic", "Eleatic", "Peripatetic",
           "Cyrenaic", "Academic", "Stoic", "Cynic", "Megaric", "Epicurean",
           "Eleack", "Sceptic")
)

START_YEAR <- -700
END_YEAR <- 25

SPECIMEN_COLUMNS <-
  list(
    row = list(class = "integer", is_na = FALSE,
               conditions = list(quo(all(row >= 1 & row <= 8)))),
    label = list(class = "character", is_na = FALSE),
    name = list(class = "character", is_na = FALSE),
    division = list(class = "character", is_na = FALSE,
                    enum = c("Men of Learning", "Statesmen")),
    text = list(class = "character", is_na = FALSE),
    occupation_abbr = list(class = "character", is_na = TRUE,
                           enum = ENUM$occupation_abbr),
    start_1 = list(class = "integer",
                   is_na = TRUE,
                   conditions = list(
                     quo(is.na(start_1) | is.na(end_1) | start_1 < end_1),
                     quo(is.na(start_1) | start_1 > START_YEAR),
                     quo(is.na(start_1) | start_1 < END_YEAR),
                     quo(is.na(start_1) | (end_1 - start_1) < 150)
                   )),
    start_2 = list(class = "integer",
                   is_na = FALSE,
                   conditions = list(
                     quo(start_2 < end_2),
                     quo(start_2 > START_YEAR),
                     quo(start_2 < END_YEAR),
                     quo(is.na(start_1) | start_1 >= start_2)
                   )),
    end_1 = list(class = "integer",
                 is_na = TRUE,
                 conditions = list(
                   quo(end_1[!is.na(end_1)] > START_YEAR),
                   quo(end_1[!is.na(end_1)] < END_YEAR)
                 )),
    end_2 = list(class = "integer",
                 is_na = FALSE,
                 conditions = list(
                   quo(end_2 > START_YEAR),
                   quo(end_2 < END_YEAR),
                   quo(is.na(end_1) | (end_1 <= end_2 & end_2 - end_1 < 120))
                 )),
    flourished = list(class = "integer",
                      is_na = TRUE,
                      conditions = list(
                        quo(flourished[!is.na(flourished)] > START_YEAR),
                        quo(flourished[!is.na(flourished)] < END_YEAR)
                      )),
    flourished_about = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              quo(is.na(flourished) |
                                     !is.na(flourished_about))
                            )),
    flourished_after = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              quo(is.na(flourished) |
                                     !is.na(flourished_after))
                            )),
    flourished_before = list(class = "logical",
                             is_na = TRUE,
                             conditions = list(
                               quo(is.na(flourished) |
                                      !is.na(flourished_before))
                             )),
    flourished_century = list(class = "logical",
                              is_na = TRUE,
                              conditions = list(
                                quo(is.na(flourished) |
                                       !is.na(flourished_century))
                              )),
    age = list(class = "integer",
               is_na = TRUE,
               conditions = list(
                 quo(is.na(age) | (age > 0 & age < 120))
               )),
    died = list(class = "integer",
                conditions = list(
                  quo(is.na(died) | (died > START_YEAR & died < END_YEAR))
                )),
    died_about = list(class = "logical",
                      conditions = list(
                        quo(is.na(died) | !is.na(died_about))
                      )),
    died_after = list(class = "logical",
                      conditions = list(
                        quo(is.na(died) | !is.na(died_after))
                      )),
    born = list(class = "integer",
                conditions = list(
                  quo(is.na(born) | born > START_YEAR & born < END_YEAR)
                )),
    born_about = list(class = "logical", is_na = TRUE,
                      conditions = list(
                        quo(is.na(born) | !is.na(born_about))
                      )),
    lived = list(class = "integer", is_na = TRUE,
                 conditions = list(
                   quo(is.na(lived) | lived > START_YEAR & lived < END_YEAR)
                 )),
    occupation = list(class = "character", is_na = FALSE,
                      enum = ENUM$occupation)
  )

test_that("Specimen has the correct number of rows", {
  expected <- sum(map_int(ROWS, ~ as.integer(sum(.))))
  expect_equal(nrow(Specimen), expected)
})

test_that("Specimen is a tibble", {
  expect_is(Specimen, "tbl_df")
})

test_that("Specimen nas all columns", {
  expect_named(Specimen, names(SPECIMEN_COLUMNS), ignore.order = TRUE)
})

for (nm in names(SPECIMEN_COLUMNS)) {
  test_that(glue("{nm} has correct class"), {
    expect_is(Specimen[[UQ(nm)]], SPECIMEN_COLUMNS[[nm]][["class"]])
  })
}

for (nm in names(SPECIMEN_COLUMNS)) {
  is_na <- SPECIMEN_COLUMNS[[nm]][["is_na"]]
  if (!is.null(is_na) && !is_na) {
    test_that(glue("{nm} has no missing values"), {
      expect_true(!any(is.na(Specimen[[UQ(nm)]])))
    })
  }
}

for (nm in names(SPECIMEN_COLUMNS)) {
  conditions <- SPECIMEN_COLUMNS[[nm]][["conditions"]]
  if (is.null(conditions)) next
  for (cond in conditions) {
    test_that(glue("{nm} meets condition"), {
      expect_true(all(eval_tidy(UQ(cond), data = Specimen)))
    })
  }
}

for (nm in names(SPECIMEN_COLUMNS)) {
  enum <- SPECIMEN_COLUMNS[[nm]][["enum"]]
  if (is.null(enum)) next
  test_that(glue("{nm} only takes values: {str_c(enum, collapse = \",\")}"), {
    eval_tidy(quo(expect_true(all(is.na(UQ(sym(nm))) | UQ(sym(nm)) %in% UQ(enum)))), data = Specimen)
  })
}
