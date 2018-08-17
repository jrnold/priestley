library("shiny")
library("ggplot2")
library("dplyr")
library("rlang")
library("purrr")
library("ggrepel")

START_YEAR = -1300
END_YEAR = 1800

library("priestley")
data("Biographies", package = "priestley")
DIVISIONS <- unique(Biographies$division)

add_layout_rows <- function(start, end, hgap = 100, vgap = 2, fudge = 1) {
  # keep it "deterministic"
  set.seed(12345)
  # initial guess about number of rows
  years <- seq(min(end, na.rm = TRUE), max(end, na.rm = TRUE),
               by = 10)
  overlapping <- max(map_int(years,
                             function(.x) {
                               sum(.x >= (start - hgap / 2) &
                                     .x <= (end + hgap / 2),
                                   na.rm = TRUE)
                             }))
  n <- overlapping * fudge
  last_values <- rep(-Inf, n)
  rows <- rep(NA_integer_, length(start))
  for (i in seq_along(start)) {
    choices <- which(last_values < (start[[i]] - hgap))
    if (length(choices)) {
      # row <- min(choices)
      r <- sample(choices, 1L)
    } else {
      # if no open rows, then double the number of rows
      last_values <- c(last_values, rep(-Inf, length(last_values)))
      r <- sample(which(last_values < end[[i]] - gap ), 1L)
    }
    rows[[i]] <- r
    last_values[[i]] <- end[[i]]
  }
  rows * vgap
}

ui <- fluidPage(

  titlePanel("A Chart of Biography"),
  sidebarPanel(
    sliderInput("yearRange", h3("Years"), min = START_YEAR,
                max = END_YEAR, value = c(START_YEAR, END_YEAR),
                step = 100, sep = ""),
    checkboxGroupInput("divisions", h3("Divisions"), choices = DIVISIONS,
                       selected = DIVISIONS),
    checkboxInput("colorDivisions", "color divisions?", value = FALSE),
    checkboxInput("groupDivisions", "group divisions?", value = TRUE)
  ),
  mainPanel(
    plotOutput(outputId = "timelinePlot"),
    textOutput(outputId = "stuff")
  )
)

server <- function(input, output) {

  dat <- reactive({
    out <- priestley::Biographies %>%
      filter(start_2 >= input$yearRange[1],
             end_2 <= input$yearRange[2],
             division %in% input$divisions) %>%
      filter(!is.na(id_1764)) %>%
      # drop any missing values
      # mutate(division = factor(division)) %>%
      arrange(division, start_2, end_2) %>%
      group_by(division) %>%
      mutate(row = add_layout_rows(start_2, end_2))
  })

  label_size <- 1.25
  nudge_y <- 1.5
  # plot sizing
  res <- 200

  # height <- reactive({max(dat()$row) * res})
  height <- 128 * res
  # width <- reactive({abs(diff(year_range())) * res * 100})
  width <- 32 * res

  output$timelinePlot <- renderPlot({
    centuries <- seq(input$yearRange[1], input$yearRange[2], by = 100)
    decades <- seq(input$yearRange[1], input$yearRange[2], by = 20)

    if (input$colorDivisions) {
      p <- ggplot(dat(), aes(y = row, yend = row, color = division))
    } else {
      p <- ggplot(dat(), aes(y = row, yend = row))
    }

    p <- p +
      geom_segment(aes(x = start_1, xend = end_1)) +
      geom_segment(aes(x = start_2, xend = end_2), alpha = 0.5) +
      geom_text_repel(aes(x = (start_2 + end_2) * 0.5,
                          y = row, label = name), nudge_y = 0.1,
                      size = label_size, force_pull = 1, box.padding = 0,
                      segment.size = 0.2, segment.alpha = 0.5) +
      # geom_text(aes(x = (start_2 + end_2) * 0.5, y = row, label = name),
      #               size = label_size, vjust = "top", nudge_y = 0.1) +
      scale_y_continuous("") +
      scale_x_continuous("", breaks = centuries, minor_breaks = decades,
                         limits = input$yearRange) +
      scale_color_discrete("") +
      theme_minimal() +
      theme(panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.ticks.x = element_line(),
            legend.position = "bottom")

    if (input$groupDivisions) {
      p <- p + facet_wrap(~ division, ncol = 1, shrink = TRUE,
                          scales = "free_y")
    }

    p
  }, res = res, height = height, width = width)

  output$stuff <- renderText({
  })

}

shinyApp(ui = ui, server = server)
