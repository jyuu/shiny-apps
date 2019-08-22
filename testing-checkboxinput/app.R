testUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$div(
      shinyWidgets::pickerInput(
        ns('tidyselector'), 
        label = 'Pivot variables selection helper', 
        choices = c("Starts With", "Ends With", "Select All"),
        width = "100%"
      )
    ),
    
    tags$div(
      style = "width:100%;",
      conditionalPanel(
        sprintf("input['%s'] != 'Select All'", ns("tidyselector")),
        # textInput("helper", "Enter helper text"),
        checkboxInput(ns("dropna"), "Drop NA values?"),
        verbatimTextOutput(ns("dropout"))
      )
    ), 
    
    actionButton(
      inputId = ns("valid_helpers"),
      label = "Apply selection rule", 
      width = "100%", 
      class = "btn-primary",
      disabled = "disabled"
    )
    
  )
  
}

testUIServer <- function(input, output, session) {
  observeEvent(input$tidyselector, {
    updateActionButton(
      session = session,
      inputId = "valid_helpers",
      label = "Apply selection rule"
    )
    
  })
  
  output$dropout <- renderText({
    input$dropna
  })
}

new_ui <- fluidPage(
  testUI('myNamespace')
)

server <- function(input, output, session) {
  callModule(testUIServer, "myNamespace")
}

shinyApp(ui = new_ui, server = server)
