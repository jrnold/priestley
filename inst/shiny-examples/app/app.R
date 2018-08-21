library("shiny")
library("ggplot2")
library("dplyr")
library("rlang")
library("purrr")
library("ggrepel")

START_YEAR = -1300
END_YEAR = 1800

library("priestley")

DIVISIONS <- unique(priestley::Biographies$division)

year_format <- function(x) {
  if_else(x <= 0L, str_c(abs(x - 1L), " ", "BCE"), as.character(x))
}

cent_format <- function(x) {
  cent <- abs(x %/% 100) + 1
  str_c(case_when(
    cent == 1 ~ "1st",
    cent == 2 ~ "2nd",
    cent == 3 ~ "3rd",
    TRUE ~ str_c(cent, "th")
  ), " Century", if_else(x < 0, " BCE", ""))
}

format_person <- function(x) {
  rlang::eval_tidy(quo({
    born_str <- if_else(is.na(born), "",
                        str_c("Born ",
                              if_else(is.na(born_about), "about ", ""),
                              year_format(born), ". "))
    died_str <- if_else(is.na(died), "",
                        str_c("Died ",
                              if_else(died_about, "about ", ""),
                              if_else(died_after, "after ", ""),
                              year_format(died), ". "))
    flourished_str <- if_else(is.na(flourished),
                              "",
                              str_c(
                                "Flourished ",
                                if_else(flourished_about, "about ", ""),
                                if_else(flourished_before, "before ", ""),
                                if_else(flourished_after, "after ", ""),
                                if_else(flourished_century,
                                        cent_format(flourished),
                                        year_format(flourished)),
                                ". "
                              ))
    lived_str <- if_else(is.na(lived), "",
                         str_c("Lived after ", year_format(lived), ". "))
    age_str <- if_else(is.na(age), "", str_c("Age ", age, ". "))
    str_trim(str_c(name, " (", occupation, ") ",
                   born_str, died_str, flourished_str,
                   lived_str, age_str))
  }), data = x)
}

local_theme <- function() {
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x.top = element_text(),
        axis.ticks.x = element_line(),
        axis.ticks.x.top = element_line(),
        strip.text = element_text(hjust = 0, face = "bold", size = rel(2)),
        legend.position = "bottom")
}

ui <- fluidPage(

  titlePanel("A Chart of Biography"),
  sidebarPanel(
    h2("Data"),
    sliderInput("yearRange", h3("Years"), min = START_YEAR,
                max = END_YEAR, value = c(START_YEAR, END_YEAR),
                step = 100, sep = ""),
    checkboxGroupInput("divisions", h3("Divisions"), choices = DIVISIONS,
                       selected = DIVISIONS),
    h2("Organization"),
    checkboxInput("colorDivisions", "Color divisions?", value = FALSE),
    checkboxInput("groupDivisions", "Group divisions?", value = TRUE),
    h2("Formatting")
  ),

  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Plot", plotOutput("timelinePlot")),
                tabPanel("Data", dataTableOutput("table"))
                )
  )
)

server <- function(input, output) {
  # plot sizing
  res <- 72
  # height <- reactive({max(dat()$row) * res})
  height <- 45 * res
  # width <- reactive({abs(diff(year_range())) * res * 100})
  width <- 32 * res

  dat <- reactive({
    out <- priestley::Biographies %>%
      filter(in_1778) %>%
      sample_n(256)
    # Use that dataset
    out <- out %>%
      filter(start_2 >= input$yearRange[1],
             end_2 <= input$yearRange[2])

    # arrange segments for plotting
    if (input$groupDivisions) {
      out <- out %>%
        arrange(division, start_2, end_2) %>%
        group_by(division)
    } else {
      out <- out %>%
        arrange(start_2, end_2) %>%
        ungroup()
    }
    out <- out %>%
      mutate(row = layout_rows(start_2, end_2, hgap = 100)) %>%
      ungroup(out)

    out
  })

  output$timelinePlot <- renderPlot({
    centuries <- seq(input$yearRange[1], input$yearRange[2], by = 100)
    decades <- seq(input$yearRange[1], input$yearRange[2], by = 20)

    data_ <- dat()

    # inner segments
    segments1 <- select(data_, start = start_1, end = end_1, row, division) %>%
      filter(!is.na(start), !is.na(end))

    # outer segments (with uncertainty)
    segments2 <- select(data_, start = start_2, end = end_2, everything())

    p <- ggplot()

    # this needs to be cleaned up with function factories or quasiquotation
    color <- if (input$colorDivisions) "division" else ""

    p <- p +
      geom_segment(data = segments2,
                   mapping = aes(x = start, xend = end,
                                 y = row, yend = row,
                                 color = !!sym(color)),
                   size = 1) +
      geom_segment(data = segments1,
                   mapping = aes(x = start, xend = end, y = row, yend = row,
                                 color = !!sym(color)),
                   alpha = 0.5) +
      geom_text(data = segments2,
                mapping = aes(x = (start + end) * 0.5,
                              y = row,
                              color = !!sym(color),
                              label = name),
                vjust = "bottom", nudge_y = 0.05, size = 3.86, alpha = 0.5)

    if (input$groupDivisions) {
      p <- p + facet_wrap(vars(division), ncol = 1, shrink = TRUE,
                          scales = "free_y", strip.position = "top")
    }

    p <- p +
      scale_y_continuous("") +
      scale_x_continuous("", breaks = centuries,
                         minor_breaks = decades,
                         limits = input$yearRange, position = "bottom",
                         sec.axis = dup_axis()) +
      scale_color_discrete("") +
      local_theme()

    p
  }, res = res, height = height, width = width)

  output$table <- renderDataTable(priestley::Biographies)

}

shinyApp(ui = ui, server = server)
