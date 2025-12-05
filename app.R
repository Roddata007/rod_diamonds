#APPLICATION SHINY SUR LE JEU DIAMONDS

#chargement des autres packages
library(shiny)
library(ggplot2)
library(dplyr)
library(bslib)
library(plotly)
library(DT)



# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),
  
  # Application title
  titlePanel("Exploration des Diamants "),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "prix_max",
        label = "Prix maximum :",
        min = 300,
        max = 20000,
        value = 5000)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("distPlot"),
      DTOutput("table")
    )
  )
)

# server 
server <- function(input, output) {
  
  output$distPlot <- renderPlotly({
    d <- diamonds %>%
      filter(price <= input$prix_max)
    
    pty<-ggplot(d, aes(x = carat, y = price)) +
      geom_point(alpha = 0.3) +
      labs(
        x = "Carat",
        y = "Price",
        title = paste("Prix maximum :", input$prix_max)
      ) +
      theme_minimal()
    ggplotly(pty)
  })
  

}

# Run the application 
shinyApp(ui = ui, server = server)



