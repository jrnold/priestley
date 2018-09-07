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
    name = list(class = "character", is_na = FALSE),
    division = list(class = "character", is_na = FALSE,
                    enum = c("Men of Learning", "Statesmen")),
    text = list(class = "character", is_na = FALSE),
    born_min = list(class = "integer",
                   is_na = TRUE,
                   conditions = list(
                     quo(is.na(born_min) | is.na(died_min) | born_min < died_min),
                     quo(is.na(born_min) | born_min > START_YEAR),
                     quo(is.na(born_min) | born_min < END_YEAR),
                     quo(is.na(born_min) | (died_min - born_min) < 150)
                   )),
    born_max = list(class = "integer",
                   is_na = FALSE,
                   conditions = list(
                     quo(born_max < died_max),
                     quo(born_max > START_YEAR),
                     quo(born_max < END_YEAR),
                     quo(is.na(born_min) | born_max >= born_min)
                   )),
    died_min = list(class = "integer",
                 is_na = TRUE,
                 conditions = list(
                   quo(died_min[!is.na(died_min)] > START_YEAR),
                   quo(died_min[!is.na(died_min)] < END_YEAR)
                 )),
    died_max = list(class = "integer",
                 is_na = FALSE,
                 conditions = list(
                   quo(died_max > START_YEAR),
                   quo(died_max < END_YEAR),
                   quo(is.na(died_min) | (died_min <= died_max & died_max - died_min < 120))
                 ))
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
    eval_tidy(quo(expect_true(all(is.na(UQ(sym(nm))) |
                                    UQ(sym(nm)) %in% UQ(enum)))),
              data = Specimen)
  })
}
