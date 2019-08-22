ui <- fluidPage(
  selectInput("dataset", 
              "Data set:", 
              c("diamonds", "rock", "pressure", "cars")),
  conditionalPanel(
    condition = "output.nrows",
    checkboxInput("headonly", "Only use first 1000")
  )
)

server <- function(input, output, session) {
  datasetInput <- reactive({
    switch(input$dataset, 
           "pressure" = pressure, 
           "cars" = cars)
  })
  
  output$nrows <- reactive({nrow(datasetInput())})
  
  outputOptions(output, "nrows", suspendWhenHidden = FALSE)
}

shinyApp(ui, server)
