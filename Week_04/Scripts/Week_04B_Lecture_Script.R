#### Today we are going to practice tidy with biogeochemistry data from Hawaii#####
#### Created by: Savannah Damiano##################
#### Updated on: 2024_09_21###################

#### Load Libraries ####

library(tidyverse)                 # "for data tidying"
library(here)                      # "to enable easy file referencing in project-oriented workflows"
library(ggbernie)                  # github package that turns your points into Bernie Sanders

#### Load Data ####

ChemData <- read.csv(here("Week_04", "Data", "chemicaldata_maunalua.csv" ))     # loading in our data. Since we have real data, we have to load the data in a CSV. Naming it the original dataset ChemData for easy referencing!
View(ChemData)                                                                  # make sure to look/ view your data in a couple different ways to see what it looks like
glimpse(ChemData)
head(ChemData)
tail(ChemData)

#### Data Analysis ####      #remember, with every new line of code to check the dataset with view(), head(), etc.

ChemData_clean <- ChemData %>%
  filter(complete.cases(.)) %>%                                                 # this filters out everything that is not a complete row. Similar to the function drop_na()
  separate(col = Tide_time,                                                     # choose the tide_time column that we want to separate into two individual columns. Removes/ Deletes the original column, unless you use remove = FALSE. 
           into = c("Tide", "Time"),                                            # separates it into two columns Tide and time
           sep = "_",                                                           # separate by _ because the original dataset used a _ to separate Tide and Time .
           remove = FALSE) %>%                                                  # keeps the original tide_time column
  
  unite(col= "Site_Zone",                                                       # the name of the NEW column. Needs to be in "" because it a new column,                                                                  
        c(Site,Zone),                                                           # the columns we want to unite
        sep = ".",                                                              # put a . in the middle of the two words in the data
        remove = FALSE)                                                         # Keeps the original columns in the dataset
  
ChemData_long <-ChemData_clean %>%                                              # Example of how to change wide data format to long data format
  pivot_longer(cols = Temp_in:percent_sgd,                                      # the cols you want to pivot. This says select the temp to percent SGD. We used the exact names in the dataset.
               names_to = "Variables",                                          # the names of the new cols with all the column names
               values_to = "Values")                                            # names of the column with all the values

ChemData_long %>%
  group_by(Variables, Site) %>%                                                 # group by everything we want
  summarize(Param_means = mean(Values, na.rm = TRUE),                           # get mean
            Param_vars = var(Values, na.rm = TRUE))                             # get variance

#Practice Question (Slide 21)- "Calculate mean, variance, and standard deviation for all variables by site, zone, and tide."
ChemData_long %>%
  group_by(Variables, Site, Zone, Tide) %>%                                     # group by everything we want (Variables, Zone, Site, Tide)
  summarize(Param_means = mean(Values, na.rm = TRUE),                           # get mean of the values
            Param_vars = var(Values, na.rm = TRUE),                             # get variance of the values
            Param_sd = sd(Values, na.rm = TRUE))                                # get standard deviation


ChemData_long %>%                                                               # facet wrap with the long format data
  ggplot(aes(x = Site, y = Values)) +
  geom_boxplot()+
  facet_wrap(~Variables, scales = "free")                                       # scales = "free" frees the x and the y axis variables so each box plot has it's own variables associated with the Value

ChemData_wide <- ChemData_long %>%                                              # Example of how to change long data to wide data
  pivot_wider(names_from = Variables,                                           # column with the names for the new column
              values_from = Values)                                             # column with the values

head(ChemData_clean)                                                            # look at the dataset without NA
View(ChemData_long)                                                             # look at the dataset transformed to long format 
View(ChemData_wide)                                                             # look at the dataset transformed back to wide format


### Calculating summary statistics and exporting to csv file ## (Slide 25) We are going to completely pipe through to create a clean script.
###### With every line of code, STOP and VIEW the current dataset- Double check for mistakes. Do this in the console, not the script. ##

#Step 1
ChemData_clean<- ChemData %>%
  drop_na()                                                                     # filters out everything that is not a complete row
                                                                              
#Step 2
ChemData_clean<- ChemData %>%
  drop_na() %>%
  separate(col = Tide_time,                                                     # choose the tide and time column
           into = c("Tide", "Time"),                                            # separate Tide_time into two separate columns - Tide and Time
           sep = "_",                                                           # separate by _ because the original dataset used a _ to seperate Tide and Time .
           remove = FALSE)                                                      # Keeps the original columns (Tide_time) in the dataset

#Step 3
ChemData_clean<- ChemData %>%
  drop_na() %>%                                                                 
  separate(col = Tide_time,
           into = c("Tide", "Time"),
           sep = "_",
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd,                                      # The columns you want to pivot. This says select the temp to percent SGD cols. So we can have all the biogeochem data in ONE column
               names_to = "Variables",                                          # The name of the new columns - with all the column names
               values_to = "Values")                                            # The name of the new column - with all the values

#Step 4
ChemData_clean<- ChemData %>%
  drop_na() %>%
  separate(col = Tide_time,
           into = c("Tide", "Time"),
           sep = "_",
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, Site, Time) %>%
  summarise(mean_vals = mean(Values, na.rm = TRUE))

#Step 5
ChemData_clean<- ChemData %>%
  drop_na() %>%
  separate(col = Tide_time,
           into = c("Tide", "Time"),
           sep = "_",
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, Site, Time) %>%                                           # Group by everything we want (Variables, Site, Time)
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>%                         # Get mean of the values. Double check all NAs are gone.              
  pivot_wider(names_from = Variables,                                           # How to change long data to wide data so that it looks nicer. column with the names for the new column.
              values_from = mean_vals)                                          # Column with the values. Notice it is now mean_vals as the col name




#All together- Final Script
ChemData_clean <- ChemData %>%
  drop_na() %>%
  separate(col = Tide_time,
           into = c("Tide", "Time"),
           sep = "_",
           remove = FALSE) %>%
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") %>%
  group_by(Variables, Site, Time) %>%
  summarise(mean_vals = mean(Values, na.rm = TRUE)) %>%
  pivot_wider(names_from = Variables,
              values_from = mean_vals) %>%
  
write_csv(here("Week_04", "Output", "ChemData_Lecture_Summary_4B.csv"))         # exports as a csv to the correct folder

ggplot(ChemData) +                                                              # make a ggplot with the ChemData
  geom_bernie(aes(x = Salinity, y = NN), bernie = "sitting")                    # x axis- Salinity, y axis- NN, points - sitting Bernie Sanders
