### Lecture Week 5B Homework - Data Wrangling: Joins & Lubridate Dates and Times ###
### Created by: Savannah Damiano #####
### Updated on 2024-09-26#############


#### Load Libraries ######

library(tidyverse)                  # for data tidying
library(here)                       # easy file referencing
library(lubridate)                  # package to deal with dates and times
library(PNWColors)                  # color palette 

#### Load Data  #####

CondData<-read.csv(here("Week_05","Data", "CondData.csv"))                      # pull data from repository

DepthData<-read.csv(here("Week_05", "Data", "DepthData.csv"))                   # pull data from repository

view(CondData)
head(CondData)
view(DepthData)
head(DepthData)

### Data Analysis ####

CondData_date <- CondData %>%                                                   # renamed dataframe- Goal is to mutate the 'date' coulm to be the unique key to join the 2 dataframes
  mutate(date = mdy_hms(date),                                                  # mutate the 'date' column to ISO datetime (to match DepthData)- used mdy_hms because that was what the original dataset was
         date = round_date(date, "10s"))                                        # mutate the 'date' column again to round_date the seconds to the nearest 10 seconds to match the Depth data                                              

DepthData_date <- DepthData %>%   
  mutate(date = ymd_hms(date))                                                  # mutated the date column to ISO

FullData_join<- inner_join(CondData_date, DepthData_date)                       # joined the 2 dataframes together. inner_join keeps only the data that is complete in both dataframes.

Summary_Data <- FullData_join%>%                                                # rename dataframe
  mutate (minutes = minute(date),                                               # extract minutes into new column                                       # 
          hour = hour(date)) %>%                                                # extract hours because there are multiple hours within the data
pivot_longer(cols = c(Temperature, Salinity, Depth),                            # pivot longer to help summarize data 
             names_to = "Variables",                                            # names the columns with all the variables 
             values_to = "Values") %>%                                          # names the columns with all the values
  group_by(minutes, hour, date, Variables) %>%                                  # group_by minutes, hours, date and variables (Temp, Salinity, Depth)
  summarise(Mean_Values = mean(Values, na.rm = TRUE)) %>%                       # to find the averages of each variable by minute.
  
write_csv(here("Week_05", "Data", "Homework_Summary_4B.csv"))                   # exports as a csv to the correct folder

ggplot(data = Summary_Data,                                                     # using the data from my new Summary_Data dataframe
        aes( x = date,                                                          # x axis will be date
            y = Mean_Values,                                                    # y axis will be the mean values of each variables
            color = Variables)) +                                               # fills the variable data with color
geom_line() +                                                                   # line graph 
facet_wrap(~Variables, scales = "free",                                         # facet wrap to create multiple panels according to the variables. scales = free allows the x and y axis marks to reflect the data. 
           labeller = labeller(Variables = c(`Depth` = "Depth (m)",             # YAY I learned in office hours how to change the facet titles. I changed the names to set facet title to include units
                                             `Salinity` = "Salinity",           # I wanted to try by new skill by adding units
                                             `Temperature` = "Temperature (°C)"))) +                                      
labs(title = "Averages of Temperature, Salinity, and Depth Across Time",        # title
       y = "Average of Variables (mean)",                                       # x-axis title with capital letters
       x = "Hours") +                                                           # y-axis title with capital letter
scale_color_manual(values = c("#cb74ad", "#11c2b5", "#f9ad2a"))+                # I'm feeling like I want a coral-ish color theme
theme(plot.title = element_text(size = 20),                                     # enlarging the title font
      axis.title = element_text(size = 11),                                     # enlarge the axis font
      legend.position = "none",                                                 # remove legend because we do not need it for this graph- the variable names/ colors are already in the graph 
      panel.background = element_rect(fill = "lavenderblush"))                  # I wanted to play around and practice adding a background color
   
ggsave(here("Week_05","Output","Homework_5B.png"),                              # Saves the graph to Damiano- Week 5- Outputs- and names it 
       width=9, height=6)                                                       # Altered the size of the saved graph to  7x5 inches












