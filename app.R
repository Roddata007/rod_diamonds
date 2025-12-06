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
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
  
  # Application title
  titlePanel("Exploration des Diamants "),
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons(
        inputId = "rose",
        label = "Colorier les points en rose ?",
        choices = c("Oui","Non"),
        selected = "Oui"
      ),
      
      selectInput(
        inputId = "choix",
        label = "Choisir une couleur à filtrer",
        choices = c("D", "E", "F","G","H","I","J")
      ),
      
      sliderInput(
        inputId = "prix_max",
        label = "Prix maximum :",
        min = 300,
        max = 20000,
        value = 5000),
    
    actionButton(
      inputId = "bouton",
      label = "Visualisez le graph"
    )
  ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput(outputId = "distPlot"),
      DTOutput(outputId = "table")
    )
  )
)

# server 
server <- function(input, output) {
  thematic::thematic_shiny(font = "auto")
  
  observeEvent(
    c(input$rose, input$choix, input$prix_max, input$bouton),
    {
      message("vous avez cliqué sur le bouton")
    }
    )
  
  #graphique plotly
  output$distPlot <- renderPlotly({
    d <- diamonds %>%
      filter(price <= input$prix_max,
             color == input$choix) %>%
      select(carat, cut, color, clarity, depth, table, price)
    
    col <- ifelse(input$rose == "Oui", "pink", "steelblue") 
    
    pty<-ggplot(d, aes(x = carat, y = price)) +
      geom_point(color=col,alpha = 0.3) +
      labs(
        x = "Carat",
        y = "Price",
        title = paste("prix:", input$prix_max,"& color:", input$choix)
      ) +
      theme_minimal()
    ggplotly(pty)
  })
  # Tableau interactif 
  output$table <- renderDT({
    
    d <- diamonds %>%
      filter(price <= input$prix_max) %>%
      select(carat, cut, color, clarity, depth, table, price)
    
    datatable(d)
  })

  
}

# Run the application 
shinyApp(ui = ui, server = server)



