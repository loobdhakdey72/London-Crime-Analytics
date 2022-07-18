library(tidyverse)

#Importing updated data
crimesURL <- "https://data.london.gov.uk/download/recorded_crime_summary/2bbd58c7-6be6-40ac-99ed-38c0ee411c8e/MPS%20Borough%20Level%20Crime%20%28Historical%29.csv"
crimes <- read.csv(crimesURL, check.names = FALSE)
censusURL <- "https://data.london.gov.uk/download/land-area-and-population-density-ward-and-borough/77e9257d-ad9d-47aa-aeed-59a00741f301/housing-density-borough.csv"
census <- read.csv(censusURL, check.names = FALSE)

#Data Cleaning
crimes$MinorText <- NULL
years <- cbind(colnames(crimes)[-(1:2)])
colnames(crimes)[colnames(crimes) %in% c("MajorText", "LookUp_BoroughName")] <- c("type", "name")
colnames(crimes)[-(1:2)] <- format(as.Date(paste0(as.character(years), '01'), format='%Y%m%d'))
crimes <- aggregate(.~ type + name, crimes, FUN = sum)

census <- census %>%
  select('Name', 'Year', 'Population') %>%
  mutate(Year = format(as.Date(paste0(as.character(Year), '0101'), format='%Y%m%d')))


