library(rgdal)
library(leaflet)
library(viridis)
library(htmltools)

source("Data.R")

shpURL <- "Data/London_Borough_Excluding_MHW.shp"
boroughs <- readOGR(shpURL)
boroughs <- spTransform(boroughs, CRS("+proj=longlat +datum=WGS84"))

curr <- crimes

getMap <- function(time = '2010', crimetype = 'Arson and Criminal Damage') {
  class(time)
  curr <- curr[-(1:2)]
  if (time == 'all') {
    curr <- curr %>%
      mutate(total = rowSums(across())) %>%
      .['total']
  } else {
    curr <- curr %>%
      rename(., total = time) %>%
      .['total']
  }
  curr <- cbind(crimes[1], crimes[2], curr)
  
  if (crimetype == 'all') {
    curr <- curr %>% 
      .[-1] %>%
      aggregate(.~ name, ., FUN = sum)
  } else {
    curr <- curr %>% 
      .[.$type == crimetype, ] %>%
      .[-1]
  }
  
  #Removing Heathrow Airport and City of London because of Data Discrepancy
  curr <- subset(curr, is.element(curr$name, boroughs$NAME))
  boroughs <- subset(boroughs, is.element(boroughs$NAME, curr$name))
  
  #Aligning the shape file and the data
  boroughs <- boroughs[order(match(boroughs$NAME, curr$name)), ]
  
  #Creating the map
  bins <- round(seq(min(curr$total) - 100, max(curr$total) + 100, length.out = 10), -2)
  pal <- colorBin("magma", domain = curr$total, bins = bins, reverse = TRUE)
  pal(curr$total)
  
  llat <- 51.508610
  llng <- -0.163611
  
  labels <- paste("<p>", curr$name, "<p>",
                  "<p>", "Total crimes:", curr$total, "<p>",
                  sep = "")
  
  m <- leaflet(boroughs) %>%
    addProviderTiles("Esri.WorldTopoMap") %>%
    setView(llng, llat, 9) %>%
    addPolygons( weight = 1,
                 smoothFactor = 0.5,
                 color = 'white',
                 opacity = 1,
                 fillOpacity = 0.8,
                 fillColor = pal(curr$total),
                 highlight = highlightOptions(
                   weight = 5,
                   color = 'white',
                   dashArray = NULL,
                   fillOpacity = 0.7,
                   bringToFront = TRUE
                 ),
                 label = lapply(labels, HTML)) %>%
    addLegend(pal = pal,
              values = curr$total,
              opacity = 0.7,
              position = "topright")
  
  return(m)
}

