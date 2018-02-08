#' Priestley's Chart of Biography Data
#'
#' These datasets comprise the biographical data in Priestley's
#' \emph{Chart of Biography}. The data frame \code{priestley1764} has
#' the biographical data for the 1st edition (1764), and \code{priestley1778}
#' has the biographical data for the 2nd edition (1778).
#'
#' @format Both \code{priestley1764} and \code{priestley1778} are data frames with the same column formats:
#' \tabular{lll}{
#' \code{name} \tab \code{character} \tab Person's name \cr
#' \code{text} \tab \code{character} \tab Original text description \cr
#' \code{division} \tab \code{character} \tab Division \cr
#' \code{category} \tab \code{character} \tab Category (profession) of the person. \cr
#' \code{subcategory} \tab \code{character} \tab Sub-category of the person; only relevant for category "H P.". \cr
#' \code{start_1} \tab \code{numeric} \tab Timeline start (conservative) \cr
#' \code{start_2} \tab \code{numeric} \tab Timeline start (uncertain) \cr
#' \code{end_1} \tab \code{numeric} \tab Timeline end (conservative) \cr
#' \code{end_2} \tab \code{numeric} \tab Timeline end (uncertain) \cr
#' \code{life} \tab \code{list} \tab List data with the
#' }
#' @docType data
#' @name priestley
"priestley1764"


#' @rdname priestley
"priestley1778"