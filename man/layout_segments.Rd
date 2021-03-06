% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{layout_segments}
\alias{layout_segments}
\title{Layout segments in rows without overlapping}
\usage{
layout_segments(x, xend, gap = 0, random = FALSE, k = 0)
}
\arguments{
\item{x}{A vector of the start locations of each segment.}

\item{xend}{A vector of the end locations of each segment.}

\item{gap}{Extra space required between non-overlapping segments.}

\item{random}{Whether to layout segments deterministically or randomly.
See 'Details`.`}

\item{k}{If `random = TRUE` parameter to use for the amount of randomness.
See 'Details'.}
}
\value{
A vector of positive integer `y` locations to use for each segment
  so that they do not overlap.
}
\description{
Given vectors specifying the start (`x`) and end (`xend`) of line segments
assign them to different categories (`y`) so that they do not overlap.
}
\details{
The vectors are sorted in ascending order by `x` and `xend`.
The function makes two passes through the data.
First, to determine the number of categories in `y`,
it scans through all unique values of `x` and `xend` to find the
maximum number of overlapping segments at a point in time.

Second, it processes each segment sequentially, assigning each segment a `y`
that will not overlap with previous segments.  There are two methods which
can be used to choose this `y`.

1. **minimum**: If `random = FALSE`, then the minimum `y` such that the segment will not
   overlap previous segments.
1. **random**: If `random = TRUE`, then `y` is randomly sampled from all among
   all the choices in which the segment would not overlap. The samples are
   weighted by `(1 / y) ^ k`, where `k` is a parameter that determines how
   much lower values of `y` are weighted. The default value of `k = 0` weights
   all values equally, and `k = Inf` is equivalent to the method of selecting
   the minimum `y` (as in `random = TRUE`).
}
