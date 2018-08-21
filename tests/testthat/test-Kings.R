context("Biographies")
library(glue)
library(stringr)
library(rlang)

data("Kings", package = "priestley")

KINGS_COLUMNS <-
  list(
    name = list(class = "character",
                is_na = FALSE),
    year = list(class = "integer",
                is_na = FALSE,
                conditions = list(
                  expr(year > -1300 & year < 1800)
                )),
    category = list(class = "character", is_na = TRUE,
                    enum = c(str_c("Kings of ", c("Judah", "Persia", "England")),
                             "King of Babylon",
                             "Ptolemies of Egypt", "Roman Emperors"))
  )

test_that("Kings has right number of rows", {
  expect_true(nrow(Kings) == 164L)
})

test_that("Biographies is a tibble", {
  expect_is(Kings, "tbl_df")
})

test_that("Biographies nas all columns", {
  expect_named(Kings, names(KINGS_COLUMNS), ignore.order = FALSE)
})

for (nm in names(KINGS_COLUMNS)) {
  test_that(glue("{nm} has correct class"), {
    expect_is(Kings[[UQ(nm)]], KINGS_COLUMNS[[nm]][["class"]])
  })
}

for (nm in names(KINGS_COLUMNS)) {
  is_na <- KINGS_COLUMNS[[nm]][["is_na"]]
  if (!is.null(is_na) && !is_na) {
    test_that(glue("{nm} has no missing values"), {
      expect_true(!any(is.na(Kings[[eval_tidy(UQ(nm))]])))
    })
  }
}

for (nm in names(KINGS_COLUMNS)) {
  conditions <- KINGS_COLUMNS[[nm]][["conditions"]]
  if (is.null(conditions)) next
  for (cond in conditions) {
    test_that(glue("{nm} meets condition: {cond}"), {
      expect_true(all(eval_tidy(cond, data = Kings)))
    })
  }
}

for (nm in names(KINGS_COLUMNS)) {
  enum <- KINGS_COLUMNS[[nm]][["enum"]]
  if (is.null(enum)) next
  test_that(glue("{nm} only takes values: {str_c(enum, collapse = \",\")}"), {
    expect_true(eval_tidy(quo(all(is.na(UQ(sym(nm))) | UQ(sym(nm)) %in% UQ(enum))),
                          data = Kings))
  })
}