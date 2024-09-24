### Today we are going to practice joins with data from Becker and Silbiger (2020) ####
### Created by: Savannah Damiano #############
### Updated on: 2024-09-25 ####################


#### Load Libraries ######

library(tidyverse)
library(here)


### Load data ######

# Environmental data from each site                                              #long data
EnviroData<-read_csv(here("Week_05","Data", "site.characteristics.data.csv"))    #pull the data from our repository
#Thermal performance data                                                        #wide data
TPCData<-read_csv(here("Week_05","Data","Topt_data.csv"))                        #pull the data from our repository

glimpse(EnviroData)
view(EnviroData)
glimpse(TPCData)
View(TPCData)

### Data Analysis #####                  # make sure to view data after every line of code

#Step 1: convert data so they are wide format- convert Envirodata to wide

EnviroData_wide <- EnviroData %>%
  pivot_wider(names_from = parameter.measured,                                  # use parameter.measured because in long data it was grouped by the paremeter.measured column
              values_from =values)                                              # now it is wide data (double check)

#Step 2: Arrange() to sort the dataframe by site

EnviroData_wide <- EnviroData %>%
  pivot_wider(names_from = parameter.measured,                                  # use parameter.measured because in long data it was grouped by the paremeter.measured column
              values_from =values) %>%                                          # now it is wide data (double check)
  arrange(site.letter)                                                          #arranges the dataframe by site

#Step 3: use left_join() to join the 2 datasets together by the common key- site.letter

FullData_left<- left_join(TPCData,EnviroData_wide)                              # joining the data together by left_join(). Double check with head(FullData_left)

#Step 4: Relocating the data so that all the metadata is on the left side and the collected numerical data is on the right

FullData_left<- left_join(TPCData,EnviroData_wide)%>%                           # joining the data together by left_join(). Double check with head(FullData_left)
  relocate(where(is.numeric), .after = where(is.character))                     # relocate all the numeric data after the character data

#Think, Pair, Share Step 5: Calculate the mean and variance of all collected (TPC and Envirnmental) data by site

FullData_left<- left_join(TPCData,EnviroData_wide)%>%                           # joining the data together by left_join(). Double check with head(FullData_left)
  relocate(where(is.numeric), .after = where(is.character))                     # relocate all the numeric data after the character data

FullData_left%>%       
  pivot_longer(cols = E:substrate.cover,                                        # The columns I want to pivot longer. This says select the E to substrate.cover. We used the exact names in the dataset.                                      # 
               names_to = "Variables",                                          # The name of the new column with the variables I chose - E to substrate.cover
               values_to = "Values") %>%                                        # Names of the column with all the values
  group_by(Variables, site.letter) %>%                                          # Group by everything we want (Variables, site.letter)
  summarise(Param_means = mean(Values, na.rm = TRUE),                           # getting the mean of all the values
            Param_vars = var(Values, na.rm = TRUE))                             # getting the vars of all the values

View(FullData_left)


######################################
## Now we are learning about Tibbles##

#Make 1 tibble
T1 <- tibble(Site.ID = c("A", "B", "C", "D"),
             Temperature = c(14.1, 16.7, 15.3, 12.8))

T1                                                                              #Check the tibble

#Make another tibble
T2 <-tibble(Site.ID = c("A", "B", "D", "E"), 
            pH = c(7.3, 7.8, 8.1, 7.9))
T2                                                                              #Check

# left_join vs right_join

left_join(T1, T2)                                                               # Joins to T1 - notice the NA

right_join(T1, T2)                                                              # Joins to T2 - notice where the NA is here


# inner_join vs full_join




#semi_join vs. anti_join

