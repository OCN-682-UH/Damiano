### Lecture Week 4A Homework Question 1 ###
### Created by: Savannah Damiano #####
### Updated on 2024-09-18#############

### Load Libraries #####
library(palmerpenguins)                           # load in our dataset
library(tidyverse)                                # "for data tidying"
library(here)                                     # "to enable easy file referencing in project-oriented workflows"

### Load data #######
glimpse(penguins)                                 #shows the structure and data of the dataframe
head(penguins)                                    #looks at the top 6 lines of the dataframe 
 
###Data Analysis#


#QUESTION 1: calculate the mean and variance of body mass by species, island, and sex without any NAs

penguins%>%
  drop_na(species,island, sex) %>%                                          # drops all the NAs from the columns you sepecify
  group_by(species, island, sex) %>%                                        # use group_by to summarize values by certain groups - here we grouped by species, island, and sex
  summarize(mean_body_mass = mean(body_mass_g, na.rm = TRUE),               # calculate the mean body mass in g
            var_body_mass = var(body_mass_g, na.rm = TRUE))                 # calculate the variance of body mass in g
