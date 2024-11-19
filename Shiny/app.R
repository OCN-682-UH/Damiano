#Palmer Penguins Shiny App
#Created by: Savannah Damiano
#Date Created: 2024-11-18

#First, I want to apologize for the lack of effort in this app. I got home from a conference in Australia on Sunday and the jet lag is kicking my butt! I promise to keep practicing shiny, but for now, I am going to defult to my emotional support palmer penguins dataset.   

#Load Libraries
library(shiny)            #building a shiny app
library(palmerpenguins)   #dataset
library(tidyverse)        
library(plotly)           #converting ggplot to interactive plot
library(rsconnect)

#Data
view(penguins)

# Define UI (user interface)
ui <- fluidPage(
  titlePanel("Palmer Penguin Analysis"),        #title of the app
  
  sidebarLayout(                                #layout with sidebar and main panel
    sidebarPanel(                               #sidebar panel (contains input controls)
      selectInput(inputId = "species",                  
                  label = "Select Species", 
                  choices = unique(penguins$species),   #allows viewer to make a choice between species
                  selected = "Adelie"),                  #default species
    
      # Dropdown input for selecting a numeric variable
      selectInput(inputId = "variable", 
                  label = "Select  Variable", 
                  choices = c("Bill Length" = "bill_length_mm",  #Options for variables
                              "Bill Depth" = "bill_depth_mm",
                              "Flipper Length" = "flipper_length_mm"),
                  selected = "bill_length_mm")                   #Default vaiable selection
      ),
    
    mainPanel(                                          #Main panel (displays the plot)
      plotlyOutput("penguinPlot"),                      #makes it a plotly interactive plot
     
      plotlyOutput("histogramPlot"),                    #Output for the histogram plot
      
    verbatimTextOutput("summaryStat")                   #output for summary statistics
     )
  )
)

# Define server 
server <- function(input, output) {
  
  #render the plot based on my previous input
  output$penguinPlot <- renderPlotly({                  
    
    # Filter data based on selected species
    filtered_data <- subset(penguins, species == input$species)  
    
    # Create a ggplot
    p <- ggplot(filtered_data, aes(x = bill_length_mm, y = bill_depth_mm, color = island)) +
      geom_point(size = 3) +
      labs(title = paste("Penguin Bill Length vs Bill Depth -", input$species),
           x = "Bill Length (mm)",
           y = "Bill Depth (mm)") +
      theme_minimal()
    
    # Convert ggplot to plotly for interactivity
    ggplotly(p)
  })
  
  # Render histogram based on ui
  output$histogramPlot <- renderPlotly({
    
    # Filter the dataset based on the selected species
    filtered_data <- subset(penguins, species == input$species)
    
    # Create a histogram for the selected variable
    p2 <- ggplot(filtered_data, aes_string(x = input$variable, fill = "island")) +
      geom_histogram(binwidth = 1, color = "black", alpha = 0.7) +       # Histogram for selected variable
      labs(title = paste(input$species, "Penguins: Distribution of", input$variable),
           x = input$variable,  # X-axis label based on selected variable
           y = "Count") +       # Y-axis label (frequency)
      theme_minimal()           # Use minimal theme
    
    # Convert ggplot object to a plotly 
    ggplotly(p2)
  })
  
  # Render the summary statistic based on ui
  output$summaryStat <- renderPrint({
    
    # Filter the data based on the selected species
    filtered_data <- subset(penguins, species == input$species)
    
    # Calculate the summary statistic (mean)
    # i used mean() and set na.rm for True to get rid of NAs
    stat_value <- mean(filtered_data[[input$variable]], na.rm = TRUE)
    
    # Print the summary statistic
    cat("Mean of", input$variable, "for", input$species, "penguins: ", round(stat_value, 2))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
