library(shiny)
library(dplyr)
library(ggplot2)
library(ggiraph)
library(rlang)

link <- paste0(dirname(dirname(getwd())), '/chess_0_ggplot/ratings.Rds')
ratings <- readRDS(link)

ui <- shinyUI(fluidPage(
  
  titlePanel("Shiny & ggiraph"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("time",
                  "select time:",
                  selected = 'SRtng',
                  choices = c('SRtng', 'RRtng', 'BRtng')
      )
    ),
    
    mainPanel(
      ggiraphOutput("plot")
    )
  )
))


server <- shinyServer(function(input, output) {
  ratings_subset <- reactive({
    ratings |> 
      filter(is.element(Fed, c('USA', 'IND', 'RUS'))) |> 
      select(Fed, !!sym(input$time))

  })
  
  output$plot <- renderggiraph({
    gg <- ggplot(ratings_subset(), aes(x = .data[[input$time]], fill = Fed))
    gg <- gg + geom_histogram_interactive(
      aes(tooltip = ratings_subset()$Fed), size = 2
    )
    ggiraph(code = print(gg))
  })
  
})


shinyApp(ui = ui, server = server)