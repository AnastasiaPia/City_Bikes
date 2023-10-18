# Install and load the required packages
#install.packages("shiny")
library(shiny)
#install.packages("httr")
library(httr)
#install.packages("jsonlite")
library(jsonlite)





source("Lab5.R")


if(!("Lab5" %in% installed.packages()[,"Package"])){
  devtools::install_github("NAZLIBILGIC/Lab5")
  library(Lab5)
}


# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("City Bike Station Info"),
  sidebarLayout(
    sidebarPanel(
      # Input for selecting the city
      selectInput("city", "Select a City:",
                  choices = c("lundahoj", "malmobybike"),
                  selected = "lundahoj"),

      # Button to trigger data fetching
      actionButton("fetchData", "Fetch Data")
    ),
    mainPanel(
      # Display the results
      verbatimTextOutput("resultOutput")
    )
  )
)

# Define the server logic for the Shiny app
server <- function(input, output) {
  cityData <- reactiveVal(NULL)

  observeEvent(input$fetchData, {
    selectedCity <- input$city

    # Call the fetchCityBikeData function with the selected city URL
    cityData(fetchCityBikeData(api_urls = paste0("http://api.citybik.es/v2/networks/", selectedCity)))
  })

  output$resultOutput <- renderPrint({
    if (is.null(cityData())) {
      return("Click 'Fetch Data' to get station information.")
    }

    # Display the results for the selected city
    cityData()[[input$city]]
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
