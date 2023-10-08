# Install and load the required packages
#install.packages("shiny")
library(shiny)
#install.packages("httr")
library(httr)
#install.packages("jsonlite")
library(jsonlite)

library(Lab5)

# Define UI for application
ui <- fluidPage(

  # Application title
  titlePanel("City Bike Information"),

  # Sidebar with a slider input
  sidebarLayout(
    sidebarPanel(
      selectInput("city_id", "Select City:",
                  choices = unique(Lab5::getCityNames())
      ),
      actionButton("get_info_button", "Get Information")),
    # Show a plot of the generated distribution
    mainPanel(
      textOutput("busiest_station_info"),
      textOutput("least_busy_station_info")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$get_info_button, {
    city_id <- input$city_id
    city_info <- Lab5::getCityInfo(city_id)

    if (!is.null(city_info)) {
      results <- Lab5::find_busiest_and_least_busy_stations(city_info)

      busiest_station <- results$busiest
      least_busy_station <- results$least_busy

      busiest_text <- paste(
        "Busiest Station Details:",
        "Name:", busiest_station$name,
        "Address:", busiest_station$extra$address,
        "Empty Slots:", busiest_station$empty_slots
      )

      least_busy_text <- paste(
        "Least Busy Station Details:",
        "Name:", least_busy_station$name,
        "Address:", least_busy_station$extra$address,
        "Empty Slots:", least_busy_station$empty_slots
      )

      output$busiest_station_info <- renderText(busiest_text)
      output$least_busy_station_info <- renderText(least_busy_text)
    } else {
      output$busiest_station_info <- renderText("No detailed information available for this city.")
      output$least_busy_station_info <- renderText(NULL)
    }
  })
}
# Run the application
shinyApp(ui = ui, server = server)
