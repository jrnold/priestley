#' Priestley's Chart of Biography Data
#'
#' These are several datasets from the Joseph Priestley's \emph{A Chart of Biography},
#' which is the first known use of a visual timeline to display historical data.
#' The data consist of the lives of approximately 2,000 individuals between 1200 B.C.E.
#' and about 1800 C.E. The \emph{Chart of Biogrpahy} was published in numerous
#' editions between 1764 and 1815. This package provides the data associated
#' with the 1st (1764) and 74th (1778) editions.x
#'
#' These datasets comprise the biographical data in Priestley's
#' \emph{Chart of Biography}. The data frame \code{priestley_1764} has
#' the biographical data for the 1st edition (1764), \code{priestley_bios_1778}
#' has the biographical data for the 2nd edition (1778).
#' Each biographical entry lists the name of the individual, their primary profession
#' as used to organize them in the chart, and some combination of birth, death,
#' lived, or "flourished" years.
#'
#' The data frame \code{priestly_kings} is a list of rulers (Kings of Judah,
#' Kings of Persia, Ptolemies of Egypt, Roman Emperors, Kings of England)
#' which are used to annotated the margin of the chart. These data are from
#' the list titled "The Times When Kings in Those Successions Which Are Noted
#' in the Margin of the Chart Began Their Reigns".
#' These data are from the 1st Edition (1764), pp. 77--80.
#'
#' The data frame \code{priestly_continuation} is from two Appendix Tables in
#' the 1st edition titled, "A Catalogue of All the Names in the
#' Continuation of the Chart, According to the Hebrew Chronology" (p. 74--75)
#' and "The Same According to the Septuagint, as Far as that Chronology
#' Differs Considerably from Any Thing in the Hebrew." (p. 76). These are lists
#' of famous Old Testament people, along with their purported death years and ages
#' according to both the Hebrew and Septuagint versions of Old Testament of
#' the Bible.
#'
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