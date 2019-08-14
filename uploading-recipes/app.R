library(shiny)
library(shinythemes)

possible_x <- c(1, 2, 3, 4, 5)
possible_steps <- c("hello", "world")
ui <- fluidPage(
  theme = "cerulean",
  headerPanel("Visualizing recipe steps"),
  sidebarLayout(
    sidebarPanel(
      
      fileInput("recipes", "Recipes object:"),
      
      # Select steps 
      checkboxGroupInput("recipe_steps", 
                         "Which steps would you like to perform?", 
                         possible_steps), 
      # Select variable for viz
      varSelectInput("xvariable", 
                     "Select a predictor to see on the independent axes", 
                     possible_x)
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

server <- function(input, output, server) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$possible_x)))
    hist(means, breaks = 20)
  })
}

shinyApp(ui = ui, server = server)

