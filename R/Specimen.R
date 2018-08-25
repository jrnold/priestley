#' List of persons in Priestley's A Specimen of A Chart of Biography
#'
#' The "Specimen" only contains ... individuals, divided into two
#' categories ("Statesmen" and "Men of Learning") rather than six.
#' Otherwise, the data is identical to that in `Biographies`.
#'
#' @format A data frame with 59 rows and 23 columns.
#' \describe{
#' \item{row}{(integer) The row (from top to bottom, within each `division`) which the individual appears in the chart.}
#' \item{label}{(string) The label used for the individual in the "Specimen" chart. This may be different than the one used in the name index.}
#' \item{text}{(string) Text entry in the name index of the source.}
#' \item{name}{(string) Name of the individual}
#' \item{division}{(string) In the Specimen chart, individuals are divided into two broad classes of occupations: "Statesmen" and "Men of Learning".}
#' \item{occupation_abbr}{(string) Abbreviation of the occupation, as used in the name index.}
#' \item{occupation}{(string) Full name of the occupation. These values are generally the same as the provided documentation from the *Description*, but in a few cases they were modernized to avoid archaic or offensive language.}
#' \item{start_1}{(integer) Upper estimate of the birth year of an individual. This is used as the start of the certain segment of an lifespan on a chart. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{end_1}{(integer) Lower estimate of the death year of an individual. This is used as the end of the certain segment of an lifespan on a chart. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{start_2}{(integer) Lower estimate of the birth year of an individual. This is used as the start of the uncertain segment of an lifespan on a chart. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{end_2}{(integer) Upper estimate of the death year of an individual. This is used as the end of the uncertain segment of an lifespan on a chart. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born}{(integer) Birth year of an individual. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born_about}{(boolean) Indicator for whether the birth year is approximate: "born about".}
#' \item{died}{(integer) Death year of an individual. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_about}{(boolean) Indicator for whether the death year is approximate: "died about".}
#' \item{died_after}{(boolean) Indicator for whether the death year should be interpreted as the lower value of a death, "died after".}
#' \item{age}{(integer) Age at which an individual died.}
#' \item{flourished}{(integer) Year in which an a individual was flourishing, meaning that the individual was active in their occupation. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{flourished_about}{(boolean) Indicator for whether `flourished` is approximate, "flourished about".}
#' \item{flourished_before}{(boolean) Indicator for whether `flourished `means "flourished before".}
#' \item{flourished_after}{(boolean) Indicator for whether `flourished` means "flourished after".}
#' \item{flourished_century}{(boolean) Indicator for whether the year in `flourished` refers to the century.}
#' \item{lived}{(integer) Year that an individual lived after. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#'}
#'
#' @docType data
"Specimen"