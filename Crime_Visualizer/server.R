#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output) {
    
  source("map.R")
  source("graphs.R")
  thismap <- reactive({
    year = paste(input$year)
    crime = paste(input$crime)
    return(getMap(year, crime))
  })
  
  thisgraph <- reactive({
    year = paste(input$year)
    crime = paste(input$crime)
    return(getGraph(year, crime))
  })
  output$map <- renderLeaflet(thismap())
  output$graph <- renderPlot(thisgraph())
})
