library(shiny)
library(esquisse)

ui <- fluidPage(
  tags$h2("Drop Input"),
  dropInput(
    inputId = "mydrop",
    choicesNames = tagList(
      list(icon("home"), style = "width: 100px;"),
      list(icon("flash"), style = "width: 100px;"),
      list(icon("cogs"), style = "width: 100px;"),
      list(icon("fire"), style = "width: 100px;"),
      list(icon("users"), style = "width: 100px;"),
      list(icon("info"), style = "width: 100px;")
    ),
    choicesValues = c("home", "flash", "cogs",
                      "fire", "users", "info"),
    dropWidth = "220px"
  ),
  verbatimTextOutput(outputId = "res")
)

server <- function(input, output, session) {
  output$res <- renderPrint({
    input$mydrop
  })
}

shinyApp(ui, server)