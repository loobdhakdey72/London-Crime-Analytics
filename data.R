library(tidyverse)

#Importing updated data
crimesURL <- "C:/Users/loobd/Documents/Projects/London Crime Analytics/Data/MPS Borough Level Crime (Historical).csv"
crimes <- read.csv(crimesURL, check.names = FALSE)
censusURL <- "C:/Users/loobd/Documents/Projects/London Crime Analytics/Data/housing-density-borough.csv"
census <- read.csv(censusURL, check.names = FALSE)

#Data Cleaning
crimes$MinorText <- NULL
years <- cbind(colnames(crimes)[-(1:2)])
colnames(crimes)[colnames(crimes) %in% c("MajorText", "LookUp_BoroughName")] <- c("type", "name")
crimes <- aggregate(.~ type + name, crimes, FUN = sum)
crimes <- crimes %>%  
  .[-(1:2)] %>%
  t() %>%
  rowsum(group = substr(rownames(.), 1,4), reorder = TRUE) %>%
  t() %>%
  cbind(crimes[1], crimes[2], .)

census <- census %>%
  select('Name', 'Year', 'Population')

