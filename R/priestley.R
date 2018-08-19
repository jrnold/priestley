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
#' The data frame \code{Kings} is a list of rulers (Kings of Judah,
#' Kings of Persia, Ptolemies of Egypt, Roman Emperors, Kings of England)
#' which are used to annotated the margin of the chart. These data are from
#' the list titled "The Times When Kings in Those Successions Which Are Noted
#' in the Margin of the Chart Began Their Reigns".
#' These data are from the 1st Edition (1764), pp. 77--80.
#'
#' @format \code{Biographies} is a data frames with the columns:
#' \tabular{lll}{
#' \code{name} \tab \code{character} \tab Person's name \cr
#' \code{text} \tab \code{character} \tab Original text description \cr
#' \code{division} \tab \code{character} \tab Division \cr
#' \code{profession} \tab \code{character} \tab Profession of the person. These
#'    were kept as close to the original source. However, a few had to be changed
#'    because they had not aged well. \cr
#' \code{sect} \tab \code{character} \tab Philsophers are further categorized into sects, e.g. "Stoic".
#' \code{sect_abbr} \tab \code{character} \tab Philsophers are further categorized into sects, e.g. "Stoic".
#' \code{start_1} \tab \code{numeric} \tab Timeline start (conservative). Negative numbers indicate B.C.E. years. \cr
#' \code{start_2} \tab \code{numeric} \tab Timeline start (uncertain) \cr
#' \code{end_1} \tab \code{numeric} \tab Timeline end (conservative) \cr
#' \code{end_2} \tab \code{numeric} \tab Timeline end (uncertain) \cr
#' \code{life} \tab \code{list} \tab List data with the available age (at death), birth,
#'    death, flourished, and lived values for that person.
#' }
#' Each row is a unique person. Note that \code{name} does not uniquely identify individuals.
#'
#' \code{Kings} is a data frame with two columns:
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
"Biographies"


#' @rdname priestley
"Kings"

#' @rdname priestley
"Specimen"