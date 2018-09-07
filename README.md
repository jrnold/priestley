[![Travis build
status](https://travis-ci.org/jrnold/priestley.svg?branch=master)](https://travis-ci.org/jrnold/priestley)

Joseph Priestley’s [A Chart of
Biography](https://en.wikipedia.org/wiki/A_Chart_of_Biography) was one
of the first examples of a timeline in its current form. The first
edition was printed in 1764, and it was reprinted in various editions.
Data from the 1st (1764) and 1778 editions are included in this package.
*A Chart of Biography* visualizes the lifespans of more than 2,000
famous individuals from 1300 BCE to 1800 AD. A smaller example chart, “A
Specimen of a Chart of Biography”, is displayed below.

This R package contains the data from that chart. It comprises three
data sets.

-   `Biographies` contains names, occupations, birth dates, and death
    dates of the approximately 2,000 individuals in the full chart.
-   `King` contains names and dates of the rulers of major empires,
    which was used to annotate the axis of the chart.
-   `Specimen` contains the names, occupations, birth dates, and death
    dates of the individuals in the “Speciment” chart.

![](vignettes/PriestleyChart.gif)
