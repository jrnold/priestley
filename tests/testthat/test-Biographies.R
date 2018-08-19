context("Biographies")
library(glue)
library(stringr)
library(rlang)

data("Biographies", package = "priestley")

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


BIOGRAPHY_COLUMNS <-
  list(
    name = list(class = "character",
                is_na = FALSE),
    text = list(class = "character",
                is_na = FALSE),
    division = list(class = "character", is_na = FALSE,
                    enum = ENUM$division),
    occupation_abbr = list(class = "character", is_na = TRUE,
                           enum = ENUM$occupation_abbr),
    sect_abbr = list(class = "character",
                     is_na = TRUE, enum = ENUM$sect_abbr),
    start_1 = list(class = "integer",
                   is_na = TRUE,
                   conditions = list(
                     expr(is.na(start_1) | is.na(end_1) | start_1 < end_1),
                     expr(is.na(start_1) | start_1 > -1300),
                     expr(is.na(start_1) | start_1 < 1800)
                   )),
    start_2 = list(class = "integer",
                   is_na = FALSE,
                   conditions = list(
                     expr(start_2 < end_2),
                     expr(start_2 > -1300),
                     expr(start_2 < 1800),
                     expr(is.na(start_1) | start_1 >= start_2)
                   )),
    end_1 = list(class = "integer",
                 is_na = TRUE,
                 conditions = list(
                   expr(end_1[!is.na(end_1)] > -1300),
                   expr(end_1[!is.na(end_1)] < 1800)
                 )),
    end_2 = list(class = "integer",
                 is_na = FALSE,
                 conditions = list(
                   expr(end_2 > -1300),
                   expr(end_2 < 1800),
                   expr(is.na(end_1) | end_1 <= end_2)
                 )),
    flourished = list(class = "integer",
                      is_na = TRUE,
                      conditions = list(
                        expr(flourished[!is.na(flourished)] > -1300),
                        expr(flourished[!is.na(flourished)] < 1800)
                      )),
    flourished_about = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              expr(is.na(flourished) | !is.na(flourished_about))
                            )),
    flourished_after = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              expr(is.na(flourished) | !is.na(flourished_after))
                            )),
    flourished_before = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              expr(is.na(flourished) | !is.na(flourished_before))
                            )),
    flourished_century = list(class = "logical",
                            is_na = TRUE,
                            conditions = list(
                              expr(is.na(flourished) | !is.na(flourished_century))
                            )),
    age = list(class = "integer",
               is_na = TRUE,
               conditions = list(
                 expr(is.na(age) | (age > 0 & age < 120))
               )),
    died = list(class = "integer",
                conditions = list(
                  expr(is.na(died) | (died > -1300 & died < 1800))
                )),
    died_about = list(class = "logical",
                      conditions = list(
                        expr(is.na(died) | !is.na(died_about))
                      )),
    died_after = list(class = "logical",
                      conditions = list(
                        expr(is.na(died) | !is.na(died_after))
                      )),
    born = list(class = "integer",
                conditions = list(
                  expr(is.na(born) | born > -1300 & born < 1800)
                )),
    born_about = list(class = "logical", is_na = TRUE,
                      conditions = list(
                        expr(is.na(born) | !is.na(born_about))
                      )),
    lived = list(class = "integer", is_na = TRUE,
                 conditions = list(
                   expr(is.na(lived) | lived > -1300 & lived < 1800)
                 )),
    id_1764 = list(class = "integer", is_na = TRUE,
                   conditions = list(
                     expr(is.na(id_1764) | id_1764 >= 1 | id_1764 < 3000)
                   )),
    id_1778 = list(class = "integer", is_na = TRUE,
                   conditions = list(
                     expr(is.na(id_1778) | id_1778 >= 1 | id_1778 < 3000)
                   )),
    occupation = list(class = "character", is_na = FALSE,
                      enum = ENUM$occupation),
    sect = list(class = "character", is_na = TRUE, enum = ENUM$sect)
  )

test_that("Biographies is a tibble rows", {
  expect_true(nrow(Biographies) > 2000L)
})

test_that("Biographies is a tibble", {
  expect_is(Biographies, "tbl_df")
})

test_that("Biographies nas all columns", {
  expect_named(Biographies, names(BIOGRAPHY_COLUMNS), ignore.order = TRUE)
})

for (nm in names(BIOGRAPHY_COLUMNS)) {
  test_that(glue("{nm} has correct class"), {
    expect_is(Biographies[[UQ(nm)]], BIOGRAPHY_COLUMNS[[nm]][["class"]])
  })
}

for (nm in names(BIOGRAPHY_COLUMNS)) {
  is_na <- BIOGRAPHY_COLUMNS[[nm]][["is_na"]]
  if (!is.null(is_na) && !is_na) {
    test_that(glue("{nm} has no missing values"), {
      expect_true(!any(is.na(Biographies[[UQ(nm)]])))
    })
  } else {
    test_that(glue("{nm} is not all missing values"), {
      expect_true(any(!is.na(Biographies[[UQ(nm)]])))
    })
  }
}

for (nm in names(BIOGRAPHY_COLUMNS)) {
  conditions <- BIOGRAPHY_COLUMNS[[nm]][["conditions"]]
  if (is.null(conditions)) next
  for (cond in conditions) {
    test_that(glue("{nm} meets condition"), {
      expect_true(all(eval_tidy(cond, data = Biographies)))
    })
  }
}

test_that("Sect is only non-missing for H P", {
  expect_true(eval_tidy(quo(all(is.na(sect) | occupation_abbr == "H P")),
                        data = Biographies))
})


for (nm in names(BIOGRAPHY_COLUMNS)) {
  enum <- BIOGRAPHY_COLUMNS[[nm]][["enum"]]
  if (is.null(enum)) next
  test_that(glue("{nm} only takes values: {str_c(enum, collapse = \",\")}"), {
    eval_tidy(quo(expect_true(all(is.na(UQ(sym(nm))) | UQ(sym(nm)) %in% UQ(enum)))), data = Biographies)
  })
}
