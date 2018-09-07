#' List of Rulers of Major Empires, 1300 BCE to 1800
#'
#' This table contains a list of rulers and the dates of their successions
#' which were used annotate the margin of Joseph Priestley's a Chart of
#' History. The list consists Kings of Judah (1095 BCE--608 BCE),
#' Nebuchadnezzer (608 BCE), Kings of Persia (604 BCE--335 BCE), Alexander
#' the Great (336 BCE), Ptolemies of Egypt (323 BCE--46 BCE), Roman
#' Emperors (31 BCE--1059), and the Kings of England (1066--1760). These
#' data are from the list titled "The Times When Kings in Those
#' Successions Which Are Noted in the Margin of the Chart Began Their
#' Reigns", (1st edition, 1764, pp. 77--80).
#'
#' @source Davis, S. B. (2010) "Names from Desc Chart 1764 OCRcorrected.pdf" <https://drive.google.com/file/d/0B4KIGf4GncycZGRmNWY4Y2QtZjNjNS00OGEzLWE0MjctMzY0NzFhM2I2YjFj/view?authkey=CPGfreEB>.
#'
#' @references
#' Priestley, J. (1765) *A chart of biography to the Right Honourable Hugh Lord Willoughby of Parham this chart is with the greatest respect and gratitude inscribed by his Lordship's most obedient and most humble servant Joseph Priestley*. 1st ed. London. <http://explore.bl.uk/BLVU1:LSCOP-ALL:BLLSFX3360000000234303>
#' Priestley, J. (1764) *A Description of a Chart of Biography* 1st ed. Warrington.
#' Priestley, J. (1778). *A Description of a Chart of Biography; with a Catalogue of All the Names Inserted in It, and the Dates Annexed to Them*. 7th ed. London: J. Johnson.
#'
#' @format A data frame with 164 rows and 3 columns.
#' \describe{
#' \item{name}{(string) Name of the individual}
#' \item{year}{(integer) Year in which the ruler ascended to power. Negative values indicate years BCE.}
#' \item{category}{(string) The empire or kingdom that the ruler ruled.}
#'}
#'
#' @docType data
"Kings"