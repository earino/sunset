library(shiny)
library(StreamMetabolism)

WorldCities <- read.csv("WorldCities.csv", 
                        colClasses=c("character", "character", 
                                     "numeric", "numeric"))

shinyServer(function(input, output) {

  output$downloadData <- downloadHandler(

    filename= function() { "calendar.csv" },
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      # code by Hilary Parker, original available:
      # https://github.com/hilaryparker/Hilary/blob/master/R/create_sunset_cal.R
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
