library(shiny)
shinyApp(
  ui = fluidPage(
    useShinyjs(),  # Set up shinyjs
    actionButton("btn", "Click me"),
    disabled(
      textInput("element", NULL, "I was born disabled")
    )
  ),
  server = function(input, output) {
    observeEvent(input$btn, {
      enable("element")
    })
  }
)