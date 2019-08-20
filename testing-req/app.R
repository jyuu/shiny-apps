ui <- fluidPage(
  textInput('data', 'Enter a dataset from the "datasets" package', 'cars'),
  p('(E.g. "cars", "mtcars", "pressure", "faithful")'), hr(),
  tableOutput('tbl')
)

server <- function(input, output) {
  output$tbl <- renderTable({
    
    ## to require that the user types something, use: `req(input$data)`
    ## but better: require that input$data is valid and leave the last
    ## valid table up
    req(exists(input$data, "package:datasets", inherits = FALSE),
        cancelOutput = FALSE)
    
    head(get(input$data, "package:datasets", inherits = FALSE))
  })
}

shinyApp(ui, server)