uitest <- function(id){
  ns <- NS(id)
  htmltools::tagList(
    uiOutput(ns("moreControls"))
  )
}

servertest <- function(input, output, session) {
  output$moreControls <- renderUI({
    tagList(
      sliderInput("n", "N", 1, 1000, 500),
      textInput("label", "Label")
    )
  })
}

ui <- fluidPage(
  uitest("module")
)

server <- shinyServer(function(input, output, session){
  callModule(servertest, "module")
})

shinyApp(ui, server)
