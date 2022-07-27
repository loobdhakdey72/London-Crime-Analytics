#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)

setwd("C:/Users/loobd/Documents/Projects/London Crime Analytics")
source("data.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Crime Visulaizer Dashboard"),
  dashboardSidebar(
    selectInput("year", "Year:",
                colnames(crimes[-(1:2)])),
    selectInput("crime", "Crime:",
                unique(crimes[1]))
    ),
  dashboardBody(
    fluidRow(box(width = 12, leafletOutput(output = "map"))),
    fluidRow(box(width = 12, plotOutput(output = "graph")))
  )
)
