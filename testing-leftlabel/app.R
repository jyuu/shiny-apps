library(shiny)
ui <- fluidPage(
  fluidRow(
    tags$head(
      tags$style(type="text/css","label{ display: table-cell; text-align: center;vertical-align: middle; } .form-group { display: table-row;}") 
    ),
    column(5,style='background-color:#f2f2f2;min-width: 300px;',
           h4("Label Issue"),
           br(),
           tags$table(
             tags$tr(width = "100%",
                     tags$td(width = "60%", div(style = "font-size:10px;", "This is label1. I want all labels on left")),
                     tags$td(width = "40%", textInput(inputId = "a", label = NULL))),
             tags$tr(width = "100%",
                     tags$td(width = "60%", tags$div(style = "font-size:10pX;", "label2")),
                     tags$td(width = "40%", textInput(inputId = "b", label = NULL)))
           )
    )
  )
)
server <- function(input, output,session) {
}
shinyApp(ui, server)
