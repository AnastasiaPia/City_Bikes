# Install and load the required packages
#install.packages("shiny")
library(shiny)
#install.packages("httr")
library(httr)
#install.packages("jsonlite")
library(jsonlite)




if(!("Lab5" %in% installed.packages()[,"Package"])){
  devtools::install_github("NAZLIBILGIC/Lab5")
  library(Lab5)
}

# Define UI for application
ui <- fluidPage(

  # Application title
  titlePanel("City Bike Station Status"),

  # Sidebar with a slider input
  sidebarLayout(
    sidebarPanel(
      selectInput("city", "Select City:",
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
  results<-reactive({
    city<-input$city
    network_ids<-if(city=="malmobybike")"malmobybike"else "lundahoj"
    bikeStationStatus(network_ids)
  })
  #create the table for the output
  output$results_table<-renderTable({
    data<-results()

  if(!is.null(results())){
    # Extract information from the results and create a data frame
    city_names <- sapply(data, function(city_info) city_info$network$location$city)
    busiest_names <- sapply(data, function(city_info) city_info$busiest$name)
    busiest_addresses <- sapply(data, function(city_info) city_info$busiest$extra$address)
    least_busy_names <- sapply(data, function(city_info) city_info$least_busy$name)
    least_busy_addresses <- sapply(data, function(city_info) city_info$least_busy$extra$address)

    result_df <- data.frame(
      City = city_names,
      Busiest_Station_Name = busiest_names,
      Busiest_Station_Address = busiest_addresses,
      Least_Busy_Station_Name = least_busy_names,
      Least_Busy_Station_Address = least_busy_addresses
    )

    return(result_df)
  } else {
    return(NULL)
  }
  })
}


# Run the application
shinyApp(ui = ui, server = server)
