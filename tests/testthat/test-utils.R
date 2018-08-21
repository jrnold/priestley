context("utils")

test_that("layout_segments works", {
  expected <- c(1L, 2L, 1L, 2L)
  expect_equal(layout_segments(c(1, 2, 4, 8), c(3, 5, 10, 10)),
               expected)
})

test_that("layout_segments works with random", {
  y <- layout_segments(c(1, 2, 4, 8), c(3, 5, 10, 10), random = TRUE)
  expect_true(y[[1]] != y[[2]])
  expect_true(y[[3]] != y[[4]])
})

test_that("layout_segments works with random", {
  y <- layout_segments(c(1, 2, 4, 8), c(3, 5, 10, 10), random = TRUE, k = 5)
  expect_true(y[[1]] != y[[2]])
  expect_true(y[[3]] != y[[4]])
})

test_that("layout_segments works with gap", {
  expected <- c(1L, 2L, 3L, 1L)
  expect_equal(layout_segments(c(1, 2, 4, 8), c(3, 5, 10, 10), gap = 3),
               expected)
})
