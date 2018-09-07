#' List of persons in Priestley's A Chart of Biography
#'
#' Table with biographical information: names, birth dates, death dates,
#' ages, occupation, category, and the lifespan segments to use in the
#' timeline for all individuals in the 1st (1764) and 7th (1778) editions
#' of Joseph Priestley's *A Chart of Biography*.
#'
#' @source Davis, S. B. (2010) "Names from Desc Chart 1764 OCRcorrected.pdf" <https://drive.google.com/file/d/0B4KIGf4GncycZGRmNWY4Y2QtZjNjNS00OGEzLWE0MjctMzY0NzFhM2I2YjFj/view?authkey=CPGfreEB>.
#'
#' @references
#' Priestley, J. (1765) *A chart of biography to the Right Honourable Hugh Lord Willoughby of Parham this chart is with the greatest respect and gratitude inscribed by his Lordship's most obedient and most humble servant Joseph Priestley*. 1st ed. London. <http://explore.bl.uk/BLVU1:LSCOP-ALL:BLLSFX3360000000234303>
#' Priestley, J. (1764) *A Description of a Chart of Biography* 1st ed. Warrington.
#' Priestley, J. (1778). *A Description of a Chart of Biography; with a Catalogue of All the Names Inserted in It, and the Dates Annexed to Them*. 7th ed. London: J. Johnson.
#'
#' @format A data frame with 2418 rows and 29 columns.
#' \describe{
#' \item{text}{(string) Original text from name index.}
#' \item{name}{(string) Name of the individual}
#' \item{description}{(string) Natural language description of the individual.}
#' \item{in_1764}{(boolean) Is this entry in the 1764 edition?}
#' \item{in_1778}{(boolean) Is this entry in the 1778 edition?}
#' \item{in_names_omitted}{(boolean) Is this entry in the "Names Omitted" section of the 1764 edition?}
#' \item{division}{(string) The *Chart* divides individuals into six categories of occupations, which are referred to as "divisions" in the text.}
#' \item{occupation_abbr}{(string) Abbreviation of the occupation, as used in the name index.}
#' \item{occupation}{(string) Full name of the occupation. These values are generally the same as the provided documentation from the *Description*, but in a few cases they were modernized to avoid archaic or offensive language.}
#' \item{sect_abbr}{(string) Abbreviation of the particular sect/school of Greek philosophy to which the individual belonged, as used in the}
#' \item{sect}{(string) Name of the particular sect/school of Greek philosophy to which the individual belonged.}
#' \item{born_min}{(integer) Lower estimate of the birth year of an individual. This is used as the start of the uncertain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born_max}{(integer) Upper estimate of the birth year of an individual. This is used as the start of the certain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_min}{(integer) Lower estimate of the death year of an individual. This is used as the end of the certain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_max}{(integer) Upper estimate of the death year of an individual. This is used as the end of the uncertain segment of a lifespan on the timeline. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born}{(integer) Birth year of an individual. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{born_about}{(boolean) Indicator for whether the birth year is approximate: "born about".}
#' \item{died}{(integer) Death year of an individual. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{died_about}{(boolean) Indicator for whether the death year is approximate: "died about".}
#' \item{died_after}{(boolean) Indicator for whether the death year should be interpreted as the lower value of a death, "died after".}
#' \item{age}{(integer) Age at which an individual died.}
#' \item{age_about}{(boolean) Is the age listed in `age` an approximation, "age about"?}
#' \item{flourished}{(integer) Year in which an a individual was flourishing, meaning that the individual was active in their occupation. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{flourished_about}{(boolean) Indicator for whether `flourished` is approximate, "flourished about".}
#' \item{flourished_before}{(boolean) Indicator for whether `flourished `means "flourished before".}
#' \item{flourished_after}{(boolean) Indicator for whether `flourished` means "flourished after".}
#' \item{flourished_century}{(boolean) Indicator for whether the year in `flourished` refers to the century.}
#' \item{lived}{(integer) Year that an individual lived after. Negative numbers are years BCE (0 = 1 BCE, -1 = 2 BCE).}
#' \item{lifetype}{(list) A vector describing which of born, died, flourished, etc. is available for this entry.}
#'}
#'
#' @docType data
"Biographies"