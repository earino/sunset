library(shiny)

WorldCities <- read.csv("WorldCities.csv", 
                        colClasses=c("character", "character", 
                                     "numeric", "numeric"))

citiesVector <- 1:nrow(WorldCities)
names(citiesVector) = c(paste0(as.character(WorldCities$city), ", ", 
                               as.character(WorldCities$country)))

losAngeles <- 1526 # a sensible default :-)

shinyUI(fluidPage(
  tags$head(
    tags$style(HTML("
      .span8, .well {
        opacity: .9 
      }

    "))),
    
  HTML('<div style="position: fixed; left: 0px; z-index: -99; width: 100%; height: 100%">
  <iframe frameborder="0" height="100%" width="100%" 
    src="https://youtube.com/embed/i1PuIdTIZJo?autoplay=1&controls=0&loop=1&showinfo=0&autohide=1&rel=0">
  </iframe>
</div>'),

  # Application title
  titlePanel(wellPanel("Sunsets in Google Calendar using R (redux)"),
             "Sunsets in Google Calendar using R (redux)"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("timezone", "Timezone:", choices = OlsonNames(), 
                  selected = "US/Pacific"),
      selectInput("city", "City: ", choices = citiesVector, 
                  selected=losAngeles),
      dateInput("start_date", "Start Date: ", value = format(Sys.Date(), "%Y/%m/%d"), 
                format = "yyyy/mm/dd"),
      sliderInput("num_days", "Number of Days: ", min = 1, max = 365, value=365),
      downloadButton('downloadData', 'Download')
    ),

    # Show a plot of the generated distribution
    mainPanel(wellPanel(
HTML('<h1>About</h1><p>This application builds a CSV of Sunset times, ready to be
      inported into <a href="http://calendar.google.com">Google Calendar.</a></p>
      <p>This is a simple shiny app written by <a href="http://DataScience.LA/team/#earino">Eduardo Ariño de la Rubia</a>.
      There is almost no real work in this app, and all the real work was done by 
      <a href="http://hilaryparker.com/">Hilary Parker</a> in her blog post
      <a href="http://hilaryparker.com/2014/05/27/sunsets-in-google-calendar-using-r/">Sunsets in Google Calendar using R</a>.
      The github repository for this code is <a href="https://github.com/earino/sunset">here</a>.
      </p>
      <p>I wanted to share this with some non-technical friends, and unfortunately
      simply installing and using R was a bridge too far. So, thanks to the fine
      folks at <a href="http://rstudio.org">RStudio</a> and their awesome <a href="https://www.shinyapps.io/">ShinyApps.io</a>
      shiny hosting service. I was able to throw a Shiny app for anyone to use
      in about 15 minutes during lunch.<p>

      <h1>How to use?</h1>
      <p>I will again direct you to <a href="http://hilaryparker.com/2014/05/27/sunsets-in-google-calendar-using-r/">Hilary\'s post</a> regarding how you actually get
      this file ingested by Google Calendar. However, to actually generate the
      CSV simply select the Timezone you will be in, the City you will see the
      sunset from, when you want the calendar to start, and how many days you 
      want a file generated for.</p>
      <p>Enjoy!</p>
      <h1>Inspiration</h1>
      <p>I captured the sunset in the video with my beautiful wife <a href="http://DataScience.LA/team/#leigh">Leigh</a> 
      in Santa Monica on the Winter Solstice in 2014. After seeing such a beautiful
      sunset, we decided that we should see more of them in the coming year, so I
      did what any Data Scientist would do... I stole some code from someone way
      smarter than me and built a this little tool :-)</p>')
    ))
  )
))
