#' Layout segments in rows without overlapping
#'
#' Given vectors specifying the start (`x`) and end (`xend`) of line segments
#' assign them to different categories (`y`) so that they do not overlap.
#'
#' @param x A vector of the start locations of each segment.
#' @param xend A vector of the end locations of each segment.
#' @param gap Extra space required between non-overlapping segments.
#' @param random Whether to layout segments deterministically or randomly.
#'   See 'Details`.`
#' @param k If `random = TRUE` parameter to use for the amount of randomness.
#'   See 'Details'.
#'
#' @return A vector of positive integer `y` locations to use for each segment
#'   so that they do not overlap.
#'
#' @details
#'
#' The vectors are sorted in ascending order by `x` and `xend`.
#' The function makes two passes through the data.
#' First, to determine the number of categories in `y`,
#' it scans through all unique values of `x` and `xend` to find the
#' maximum number of overlapping segments at a point in time.
#'
#' Second, it processes each segment sequentially, assigning each segment a `y`
#' that will not overlap with previous segments.  There are two methods which
#' can be used to choose this `y`.
#'
#' 1. **minimum**: If `random = FALSE`, then the minimum `y` such that the segment will not
#'    overlap previous segments.
#' 1. **random**: If `random = TRUE`, then `y` is randomly sampled from all among
#'    all the choices in which the segment would not overlap. The samples are
#'    weighted by `(1 / y) ^ k`, where `k` is a parameter that determines how
#'    much lower values of `y` are weighted. The default value of `k = 0` weights
#'    all values equally, and `k = Inf` is equivalent to the method of selecting
#'    the minimum `y` (as in `random = TRUE`).
#'
#' @importFrom purrr map_int
#' @importFrom tibble tibble
#' @importFrom dplyr mutate rename count if_else full_join arrange
#' @export
layout_segments <- function(x, xend, gap = 0, random = FALSE, k = 0) {

  dat <- tibble(x = as.numeric(x), xend = as.numeric(xend),
                .id = seq_along(x), y = NA_integer_)
  dat <- arrange(dat, .data$x, .data$xend)
  # find the number of rows needed
  # xgrid <- seq(min(x, na.rm = TRUE), max(xend, na.rm = TRUE), xgrid_size)
  # for maximum size only need to check the locations of new segments.
  # in the future it may make sense to sample these instead of using all
  # unique values
  xgrid <- full_join(rename(count(dat, .data$x), start = .data$n),
                     rename(count(mutate(dat, xend = .data$xend + gap),
                                  .data$xend), end = .data$n, x = .data$xend),
                     by = "x")
  xgrid <- mutate(xgrid,
                  start = if_else(is.na(.data$start), 0L, .data$start),
                  end = if_else(is.na(.data$end), 0L, .data$end))
  xgrid <- mutate(xgrid,
                  start = cumsum(.data$start),
                  end = cumsum(.data$end),
                  current = .data$start - .data$end)
  n <- max(xgrid$current)
  # keep track of the last-seen values for each y
  last_values <- rep(-Inf, n)
  for (i in seq_len(nrow(dat))) {
    if (!is.na(dat[["x"]][[i]]) & !is.na(dat[["xend"]][[i]])) {
      choices <- which(dat[["x"]][[i]] > last_values)
      # if no choices, then double the number of rows
      if (length(choices) == 0L) {
        last_values <- c(last_values, rep(-Inf, length(last_values)))
        choices <- which(dat[["x"]][[i]] > last_values)
      }
      if (random) {
        if (length(choices) > 1L) {
          # If I don't do this, it will interpret a single number as the
          # number of obs to sample
          y <- base::sample(choices, size = 1L,
                            prob = (1 / (seq_along(choices) ^ k)))
        } else {
          y <- choices[[1]]
        }
      } else {
        y <- min(choices)
      }
      dat[["y"]][[i]] <- y
      last_values[[y]] <- dat[["xend"]][[i]] + gap
    }
  }
  # compress rows by removing empty rows
  dat <- mutate(dat, y = as.integer(as.factor(y)))
  # sort back into original order and return y
  arrange(dat, .data$.id)[["y"]]
}
