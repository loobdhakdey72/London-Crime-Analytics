source("C:/Users/loobd/Documents/Projects/London Crime Analytics/Data.R")
library(ggplot2)
library(dplyr)
library(tibble)
library(janitor)

borough <- 'all'
time <- '2018'
crimetype <- 'all'
curr <- crimes

stopifnot(borough == 'all' | crimetype == 'all')

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


if (borough == 'all') {
  if (crimetype == 'all') {
    curr <- curr %>% 
      .[-1] %>%
      aggregate(.~ name, ., FUN = sum)
  } else {
    curr <- curr %>% 
      .[.$type == crimetype, ] %>%
      .[-1]
  }
  g <- curr %>% 
    ggplot(aes(x = reorder(name,total), y = total, fill = name)) + 
    labs(x  = 'Boroughs')

} else {
  curr <- filter(curr, name == borough)
  curr <- curr[-2]
  g <- curr %>% 
    ggplot(aes(x = reorder(type,total), y = total, fill = type)) +
    labs(x  = 'Type of Crime')
}

g <- g + 
  geom_bar(stat="identity", show.legend = FALSE) +
  geom_text(aes(label = total), size = 2, hjust = -0.1) +
  labs(y = 'Number of Crimes') +
  coord_flip() +
  theme_classic()

g
  
