#' Priestley's Chart of Biography Data
#'
#' These datasets comprise the biographical data in Priestley's
#' \emph{Chart of Biography}. The data frame \code{priestley_1764} has
#' the biographical data for the 1st edition (1764), and \code{priestley_bios_1778}
#' has the biographical data for the 2nd edition (1778).
#'
#' In these charts, the margin is annotated with the current ruler (Kings of Judah,
#' Kings of Persia, Ptolemies of Egypt, Roman Emperors, Kings of England).
#' The rulers data is from the 1st Edition (1764).
#'
#' @format \code{priestley_bios_1764} and \code{priestley_bios_1764} are data frames with the same column formats:
#' \tabular{lll}{
#' \code{name} \tab \code{character} \tab Person's name \cr
#' \code{text} \tab \code{character} \tab Original text description \cr
#' \code{division} \tab \code{character} \tab Division \cr
#' \code{category} \tab \code{character} \tab Category (profession) of the person. \cr
#' \code{subcategory} \tab \code{character} \tab Sub-category of the person; only relevant for category "H P.". \cr
#' \code{start_1} \tab \code{numeric} \tab Timeline start (conservative). Negative numbers indicate B.C.E. years. \cr
#' \code{start_2} \tab \code{numeric} \tab Timeline start (uncertain) \cr
#' \code{end_1} \tab \code{numeric} \tab Timeline end (conservative) \cr
#' \code{end_2} \tab \code{numeric} \tab Timeline end (uncertain) \cr
#' \code{life} \tab \code{list} \tab List data with the available age (at death), birth,
#'    death, flourished, and lived values for that person.
#' }
#' Each row is a unique person. Note that \code{name} does not uniquely identify individuals.
#'
#' \code{priestley_kings} is a data frame with two columns:
#' \tabular{lll}{
#' \code{name} \tab \code{character} \tab Name of the ruler \cr
#' \code{year} \tab \code{integer} \tab Year in which the ruler took power. Negative
#'   numbers indicate B.C.E. years \cr
#' \code{category} \tab \code{character} \tab Category of the ruler: "Kings of Judah" from 1095 to 608 BCE,
#' "King of Babylon" (Nebuchannezer) in 603 BCE, Kings of Persia from 559 to 335 BCE,
#' "Ptolemies of Egypt" from 323 to 46 BCE, "Roman Emperors" (including Easter rulers) from 31 BCE to 1059 CE,
#' "Kings of England" from 1066 to 1760 CE.
#' }
#' Each row is a unique ruler.
#'
#' @docType data
#' @name priestley
"priestley_bios_1764"


#' @rdname priestley
"priestley_bios_1778"

#' @rdname priestley
"priestley_kings"