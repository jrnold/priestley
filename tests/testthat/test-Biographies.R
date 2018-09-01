context("Biographies")
library(glue)
library(stringr)
library(rlang)

data("Biographies", package = "priestley")

START_YEAR <- -1300
END_YEAR <- 1800

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
    born_max = list(class = "integer",
                   is_na = TRUE,
                   conditions = list(
                     quo(is.na(born_max) | born_max > START_YEAR),
                     quo(is.na(born_max) | born_max < END_YEAR)
                   )),
    born_min = list(class = "integer",
                   is_na = FALSE,
                   conditions = list(
                     quo(born_min > START_YEAR),
                     quo(born_min < END_YEAR),
                     quo(is.na(born_max) | (born_max >= born_min))
                   )),
    died_min = list(class = "integer",
                 is_na = TRUE,
                 conditions = list(
                   quo(died_min[!is.na(died_min)] > START_YEAR),
                   quo(died_min[!is.na(died_min)] < END_YEAR),
                   quo(is.na(died_min) | (died_min <= died_max)),
                   quo(is.na(born_max) | !is.na(died_min)),
                   quo(is.na(born_max) | born_max < died_min),
                   quo(is.na(born_max) | (died_min - born_max < 120))
                 )),
    died_max = list(class = "integer",
                 is_na = FALSE,
                 conditions = list(
                   quo(died_max > START_YEAR),
                   quo(died_max < END_YEAR),
                   quo(born_min < died_max),
                   quo(died_max - born_min < 120)
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
                              quo(is.na(flourished) | !is.na(flourished_about))
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
    in_1764 = list(class = "logical", is_na = FALSE),
    in_1778 = list(class = "logical", is_na = FALSE),
    in_names_omitted = list(class = "logical", is_na = FALSE),
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
      expect_true(all(eval_tidy(UQ(cond), data = Biographies)))
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
    eval_tidy(quo(expect_true(all(is.na(UQ(sym(nm))) |
                                    UQ(sym(nm)) %in% UQ(enum)))),
              data = Biographies)
  })
}
