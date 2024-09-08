### This is my first script. I am learning how to input data.
### Created by: Savannah Damiano
### Created on: 2024-09-07
##################################################

### Load libraries #########
library(tidyverse)
library(here)

### Read in data ###########
Weightdata <- read_csv(here("Week_02","Data","weightdata.csv"))

### Data Analysis #########
head(Weightdata) #looks at the top 6 lines of the dataframe
tail(Weightdata) #looks at the bottom 6 lines of the dataframe
view(Weightdata) #opens a new window to look at the entire dataframe

