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

add_layout_rows <- priestley:::add_layout_rows

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
    selectInput("dataset", "Dataset",
                c("1764 Edition" = '1764',
                  "1778 Edition" = '1778',
                  "Specimen" = 'specimen',
                  selected = 'specimen')),
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
  label_size <- 2
  res <- 100
  # height <- reactive({max(dat()$row) * res})
  height <- 45 * res
  # width <- reactive({abs(diff(year_range())) * res * 100})
  width <- 32 * res

  dat <- reactive({
    # Choose initial dataset to use
    if (input$dataset == "specimen") {
      out <- priestley::Specimen
    } else if (input$dataset == "1764") {
      out <- priestley::Biographies %>%
        filter(!is.na(id_1764))
    } else if (input$dataset == "1778") {
      out <- priestley::Biographies %>%
        filter(!is.na(id_1778))
    } else {
      stop("Invalid dataset", call. = FALSE)
    }
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
      mutate(row = add_layout_rows(start_2, end_2, hgap = 100)) %>%
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
                                 color = !!sym(color))) +
      geom_segment(data = segments1,
                   mapping = aes(x = start, xend = end, y = row, yend = row,
                                 color = !!sym(color)),
                   alpha = 0.5) +
      geom_text_repel(data = segments2,
                      mapping = aes(x = (start + end) * 0.5,
                                    y = row,
                                    color = !!sym(color),
                                    label = name),
                      nudge_y = 0.1,
                      size = label_size, force_pull = 1, box.padding = 0,
                      segment.size = 0.2, segment.alpha = 0.5)

    if (input$groupDivisions) {
      p <- p + facet_wrap(vars(division), ncol = 1, shrink = TRUE,
                          scales = "free_y", strip.position = "top")
    }

    p <- p +
      scale_y_continuous("") +
      scale_x_continuous("", breaks = centuries, minor_breaks = decades,
                         limits = input$yearRange) +
      scale_color_discrete("") +
      local_theme()

    p
  }, res = res, height = height, width = width)

  output$table <- renderDataTable(priestley::Biographies)

}

shinyApp(ui = ui, server = server)
