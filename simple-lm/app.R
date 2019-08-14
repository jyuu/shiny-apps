library(shiny)
library(shinythemes)

ui <- fluidPage(
  
  theme = "cerulean", 
  
  headerPanel("Comparing butchered and non-butchered fitted lm model objects"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("model", "Upload fitted SLR model:",
                accept = ".rds",
                placeholder = "Nothing selected."), 
      numericInput("new", "Enter new observation to predict:", 
                   value = 2, 
                   min = 0, max = Inf), 
      actionButton("predict", "Predict!")
    ),
    mainPanel(
      textOutput("text2")
    )
  )
)

server <- function(input, output, session) {
  
  options(shiny.maxRequestSize=30*1024^4) 
  
  outputPredicted <- eventReactive(input$predict, {
    inFile <- input$model
    if (is.null(inFile))
      return(NULL)
    newModel <- readRDS(inFile$datapath)
    newData <- data.frame(Petal.Width = input$new)
    predict(newModel, newData)
  })

  output$text2 <- renderText({
    outputPredicted()
  })
}

shinyApp(ui = ui, server = server)
