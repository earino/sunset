
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(StreamMetabolism)

#' Create a sunset calendar
#'
#' This function creates a .CSV of sunset appointments--with a user-specified location--that can be imported into Google Calendar. 
#' @param date Date at which you want the calendar to start, in yyyy/mm/dd format.
#' @param lat Latitude of location (for sunset time calculation)
#' @param long Longitude of location (for sunset time calculation, will be negative for continental US)
#' @param timezone Timezone of location (for sunset time calculation). 
#' @param num.days Number of days you want sunset appointments for.
#' @param file Filename for outputted .CSV file (to be uploaded to Google Calendar).
#' @param location Location of sunset appointment. Will be input into Google Calendar event as the event location.
#' @importFrom StreamMetabolism sunrise.set
#' @export
#' @examples \dontrun{
#' create_sunset_cal(location = "40.7127, -74.0059")
#'}
#' 

WorldCities <- read.csv("WorldCities.csv", colClasses=c("character", "character", "numeric", "numeric"))

shinyServer(function(input, output) {

  output$downloadData <- downloadHandler(

    filename= function() { "calendar.csv" },
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      date=input$start_date
      
      lat = WorldCities[input$city, "lat"]
      long = WorldCities[input$city, "long"]
      timezone = input$timezone
      num.days = input$num_days
      location = WorldCities[input$city, "city"]
      
      location <- gsub(",", "", location)
      
      dates <- seq(
        as.Date(date), 
        by = "day", 
        length.out = num.days
      )
      
      sunset_times <- sunrise.set(
        lat = lat, 
        long = long, 
        date = date, 
        timezone = timezone,
        num.days = num.days
      )$sunset
      
      nms <- c(
        'Subject',
        'Start Date',
        'Start Time',
        'End Date',
        'End Time',
        'All Day Event',
        'Description',
        'Location',
        'Private'
      )
      mat <- matrix(
        nrow = length(dates),
        ncol = length(nms)
      )
      mat <- data.frame(mat)
      colnames(mat) <- nms
      
      mat$Subject <- "Sunset"
      mat$"Start Date" <- dates
      mat$"End Date" <- dates
      mat$"All Day Event" <- "False"
      mat$Description <- "Sunset Calendar"
      mat$Location <- location
      mat$Private <- "False"
      
      starts <- strftime(sunset_times, format="%H:%M:%S %p")
      ends <- strftime(sunset_times+60*30, format="%H:%M:%S %p")
      mat$"Start Time" <- starts
      mat$"End Time" <- ends
      
      write.csv(
        mat,
        file=file,
        quote=FALSE,
        row.names=FALSE
      ) 
    }
  )
  

})
