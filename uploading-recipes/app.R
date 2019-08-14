# Load libraries
library(shiny)
library(shinythemes)
library(AmesHousing)
library(DT)
library(recipes)
library(ggplot2)

# Prepare dataset
ames <- make_ames()
og_predictors <- names(ames)
og_predictors <- og_predictors[!og_predictors %in% "Sale_Price"]
og_predictors <- og_predictors[sapply(ames, is.numeric)]

# Recipe options
possible_steps <- c(
  "step_knnimpute", 
  "step_BoxCox",
  "step_inverse",
  "step_center",
  "step_scale",
  "step_spatialsign",
  "step_nzv"
)

ui <- fluidPage(
  
  # Use shiny theme 
  theme = "cerulean",
  
  # Header
  headerPanel("Visualizing recipe steps on the Ames data set"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      
      # Load data
      # fileInput("data", "Upload data:", 
      #           accept = c(".rds", ".rda"),
      #           placeholder = "Nothing provided."),
      
      # Select variable for viz
      # varSelectInput("ycol", 
      #                "Select a response", 
      #                ames, 
      #                selected = "Lot_Frontage",
      #                multiple = FALSE),
      
      # Select variable for viz
      varSelectInput("xcol", 
                     "Select a predictor to view", 
                     ames, 
                     selected = "Lot_Frontage",
                     multiple = FALSE),
      
      # Select steps 
      checkboxGroupInput("recipe_steps", 
                         "Which steps would you like to perform?", 
                         possible_steps), 

      # Action
      actionButton("bake", "Bake!")
    ),
    
    mainPanel(
      plotOutput("ggplot_data"),
      br(),
      textOutput("check_inside"),
      br(),
      dataTableOutput("transformed_data")
    )
    
  )
)

server <- function(input, output, server) {
  
  options(shiny.maxRequestSize=30*1024^4) 

  # Get booleans 
  knnTrue <- reactive(!"step_knnimpute" %in% input$recipe_steps)
  boxTrue <- reactive(!"step_BoxCox" %in% input$recipe_steps)
  invTrue <- reactive(!"step_inverse" %in% input$recipe_steps)
  cenTrue <- reactive(!"step_center" %in% input$recipe_steps)
  scaTrue <- reactive(!"step_scale" %in% input$recipe_steps)
  spaTrue <- reactive(!"step_spatialsign" %in% input$recipe_steps)
  nzvTrue <- reactive(!"step_nzv" %in% input$recipe_steps)
  
  # Apply recipe steps
  applyRecipe <- eventReactive(input$bake, {
    
    # inFile <- input$data
    # if (is.null(inFile)) {
    #   return(NULL)
    # } else {
    #   newData <- readRDS(inFile$datapath)
      recipe(Sale_Price ~ ., data = ames) %>%
        step_knnimpute(all_predictors(), skip = knnTrue()) %>%
        step_BoxCox(all_numeric(), skip = boxTrue()) %>%
        step_inverse(all_numeric(), skip = invTrue()) %>%
        step_center(all_numeric(), skip = cenTrue()) %>%
        step_scale(all_numeric(), skip = scaTrue()) %>%
        step_spatialsign(all_numeric(), skip = spaTrue()) %>%
        step_nzv(all_numeric(), skip = nzvTrue()) %>%
        prep() %>% bake(new_data = ames)
  })
  
  output$check_inside <- renderText({
    transformed <- applyRecipe()
    check <- c(as.name(input$xcol)) %in% names(transformed)
    if(!check) {
      print("Sorry, after baking the prepared recipe, 
            this predictor is not available!")
    }
  })
  
  # Plot if variable exists
  output$ggplot_data <- renderPlot({ 
    transformed <- applyRecipe() 
    selectedName <- as.name(input$xcol)
    if(c(selectedName) %in% names(transformed)) {
    transformed %>%
      ggplot(aes(x = !!input$xcol, y = Sale_Price)) +
      geom_point(alpha = 0.5) +
      ylab("Sale Price") 
    } else {
      ggplot()
    }
  })
  
  # Show new data set
  output$transformed_data <- renderDataTable({
    newData <- applyRecipe() %>%
      select(Sale_Price, !!input$xcol)
    datatable(newData,
              options = list(
                autowidth = TRUE,
                lengthMenu = c(5, 30, 50),
                columnDefs = list(list(width = '20px',
                                       targets = "_all")),
                pageLength = 10)
              )
  })
}

shinyApp(ui = ui, server = server)

