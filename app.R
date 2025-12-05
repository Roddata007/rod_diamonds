#APPLICATION SHINY SUR LE JEU DIAMONDS

install.packages("usethis")
library(usethis)

#chargement des packages
library(dplyr)
library(ggplot2)
library(bslib)

#Premier morceau de code pour l'application
thematic::thematic_shiny(font = "auto")
# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(
    version = 5
  ),
  # Application title
  titlePanel("Starwars"),
  h1("Star Wars Characters"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "taille",
                  label = "Height of characters",
                  min = 0,
                  max = 250,
                  value = 30),
      actionButton(inputId = "boutton", label = "Cliquez-moi"),
      selectInput(
        inputId = "sexe",
        label = "Choisissez le genre",
        choices = c("masculine","feminine")
      )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      textOutput(outputId = "nbperso"),
      plotOutput(outputId = "StarWarsPlot"),
      DT::DTOutput(outputId = "tableau")
    )
    
  )
)


