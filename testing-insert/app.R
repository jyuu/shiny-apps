pivotCodeUI <- function(id, insert_code = TRUE) {
  ns <- NS(id)
  tagList(
    if (insert_code) {
      actionLink(
        inputId = ns("insert_code"),
        label = "Insert code in script",
        icon = icon("arrow-circle-left")
      )
    },
    tags$br()
  )
}

pivotCodeServer <- function(input, output, session) {
  
  observeEvent(input$insert_code, {
    context <- rstudioapi::getSourceEditorContext()
    if (input$insert_code == 1) {
      code <- paste("library(tidyr)", sep = "\n\n")
    }
    rstudioapi::insertText(text = paste0("\n", code), id = context$id)
  })
}

ui <- fluidPage(
  pivotCodeUI("dad")
)

server <- function(input, output, session) {
  callModule(pivotCodeServer, id = "dad")
}