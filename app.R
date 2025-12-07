#APPLICATION SHINY SUR LE JEU DIAMONDS

#chargement des autres packages
library(shiny)
library(ggplot2)
library(dplyr)
library(bslib)
library(plotly)
library(DT)
thematic::thematic_shiny(font = "auto")

# Définition de l'UI
ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
  
  # Titre de l'application
  
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
    
    # affichage
    mainPanel(
      plotlyOutput(outputId = "distPlot"),
      DTOutput(outputId = "table")
    )
  )
)

# server 
server <- function(input, output) {
 
  rv <- reactiveValues(df = NULL)
  
  observeEvent(input$bouton,{
    
      rv$df <- diamonds %>%
        filter(price <= input$prix_max,
               color == input$choix) %>%
        select(carat, cut, color, clarity, depth, table, price)
      
      col <- ifelse(input$rose == "Oui", "pink", "black") 
      
      pty <- ggplot(rv$df, aes(x = carat, y = price)) +
        geom_point(color = col, alpha = 0.3) +
        labs(
          x = "carat",
          y = "price",
          title = paste("prix:", input$prix_max, "& color:", input$choix)
        ) +
        theme_minimal()
      
      rv$graph <- ggplotly(pty)
      rv$table <- datatable(rv$df)
      
      showNotification(paste("prix:", input$prix_max,"& color:", input$choix),
                       type="message"
                       )
    })
  
  #graphique plotly
  output$distPlot <- renderPlotly({
    rv$graph
  })
  
  # Tableau interactif 
  output$table <- renderDT({
    
   rv$table
  })

}
# Run the application 
shinyApp(ui = ui, server = server)


