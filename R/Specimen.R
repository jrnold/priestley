#' List of persons in Priestley's A Specimen of A Chart of Biography
#'
#' The "Specimen" only contains ... individuals, divided into two
#' categories ("Statesmen" and "Men of Learning") rather than six.
#' Otherwise, the data is identical to that in `Biographies`.
#'
#' @source Davis, S. B. (2010) "Names from Desc Chart 1764 OCRcorrected.pdf" <https://drive.google.com/file/d/0B4KIGf4GncycZGRmNWY4Y2QtZjNjNS00OGEzLWE0MjctMzY0NzFhM2I2YjFj/view?authkey=CPGfreEB>.
#'
#' @references
#' Priestley, J. (1765) *A chart of biography to the Right Honourable Hugh Lord Willoughby of Parham this chart is with the greatest respect and gratitude inscribed by his Lordship's most obedient and most humble servant Joseph Priestley*. 1st ed. London. <http://explore.bl.uk/BLVU1:LSCOP-ALL:BLLSFX3360000000234303>
#' Priestley, J. (1764) *A Description of a Chart of Biography* 1st ed. Warrington.
#' Priestley, J. (1778). *A Description of a Chart of Biography; with a Catalogue of All the Names Inserted in It, and the Dates Annexed to Them*. 7th ed. London: J. Johnson.
#'
#' @format A data frame with 59 rows and 8 columns.
#' \describe{
#' \item{row}{(integer) The row (from top to bottom, within each `division`) which the individual appears in the chart.}
#' \item{name}{(string) The name used for the individual in the "Specimen" chart. This may be different than the one used in the name index.}
#' \item{text}{(string) Original text from name index.}
#' \item{division}{(string) In the Specimen chart, individuals are divided into two broad classes of occupations: "Statesmen" and "Men of Learning".}
#' \item{born_min}{(integer) Lower estimate of the birth year of an individual. This is used as the start of the uncertain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born_max}{(integer) Upper estimate of the birth year of an individual. This is used as the start of the certain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_min}{(integer) Lower estimate of the death year of an individual. This is used as the end of the certain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_max}{(integer) Upper estimate of the death year of an individual. This is used as the end of the uncertain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#'}
#'
#' @docType data
"Specimen"