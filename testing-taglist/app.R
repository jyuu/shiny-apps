library(shiny)

moduleUI <- function(id){
  ns <- NS(id)
  
  # return a list of tags
  tagList(h4("Select something"),
          selectInput(ns("select"), "Select here", choices=1:10))
}

module <- function(input, output, session){}

ui <- shinyUI(
  fluidPage(wellPanel(moduleUI("module"))) # wrap everything that comes from the moduleUI in a wellPanel
)

server <- shinyServer(function(input, output, session){
  callModule(module, "module")
})

shinyApp(ui = ui, server = server)