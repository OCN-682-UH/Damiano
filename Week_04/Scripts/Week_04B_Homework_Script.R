#### INTRODUCTION###

#### Today I am going to practice tidy with biogeochemistry data from Hawaii for Homework Week_04B#####
#### Created by: Savannah Damiano##################
#### Updated on: 2024_09_21###################

#### Load Libraries ####

library(tidyverse)                 # "for data tidying"
library(here)                      # "to enable easy file referencing in project-oriented workflows"
library(PNWColors)                 # PNW color palette 

#### Load Data ####

ChemData <- read.csv(here("Week_04", "Data", "chemicaldata_maunalua.csv" ))     # Loading in our data. Since we have real data, we have to load the data in a CSV. Naming it the original dataset ChemData for easy referencing!
View(ChemData)                                                                  # make sure to look/ view your data in a couple different ways to see what it looks like
glimpse(ChemData)
head(ChemData)
tail(ChemData)

#### Data Analysis ####      # remember, with every new line of code to check the dataset with view(), head(), etc

ChemData_tidy <- ChemData %>%                                                   # naming my cleaned data set CleanData_tidy
  drop_na() %>%                                                                 # removing NAs
  separate(col = Tide_time,                                                     # choose the tide and time column to separate. Do not need "quotation marks" because it is already a column in dataset.
           into = c("Tide", "Time"),                                            # separate Tide_time into two separate columns - Tide and Time in "quotation marks" because we are creating a new column. 
           sep = "_",                                                           # separate by _ because the original dataset used a _ to separate Tide and Time .
           remove = FALSE) %>%                                                  # Keeps the original columns (Tide_time) in the dataset
  filter(Season != "SPRING") %>%                                                # Filtered out data from Spring because we only want to look at the Fall data
  pivot_longer(cols = Silicate:NN,                                              # The columns I want to pivot longer. This says select the Silicate to NN. We used the exact names in the dataset.
                names_to = "Variables",                                         # The name of the new column with the variables I chose - Silicate and NN
                values_to = "Values") %>%                                       # Names of the column with all the values
  group_by(Variables, Tide) %>%                                                 # Group by everything we want (Variables, Tide)
  mutate(mean_of_values = mean(Values)) %>%                                     # using mutate to create a separate column that finds the mean of the selected variables (NN and Silicate)- using mutate to summarize

write_csv(here("Week_04", "Output", "ChemData_Homework_Summary_4B.csv"))        # Exports as a csv to the correct folder

  
ggplot(data = ChemData_tidy,                                                    # data being used is the ChemData_tidy that I created
       mapping = aes( x = Values,                                               # x axis is values - you do not need a y axis for geom_density 
                      fill = Variables))+                                       # we are choosing to fill the variables with color on the plot
geom_density(alpha=0.8)+                                                        # we are working with a denisty plot. alpha to make it more transparency 
facet_grid(Tide ~ Variables, scales = "free", labeller = "label_value") +       # facet grid to create a matrix for easier viewing with two variables. The grid will represent data involving Tide and our variables (NN and Silicate). scales = free allows the x and y axis marks to reflect the data. 
geom_vline(aes(xintercept = mean_of_values)) +                                  # geom_vline adds a vertical line to highlight mean
labs(title = "Density of Nitrates and Silicates Levels by Tide Level",          # plot title
       subtitle = "Fall Field Season",                                          # subtitle- we removed Spring data
       caption= "Source: Silbiger et al. 2020",                                 # give credit 
       x = "Values",                                                            # x axis title
       y = "Density") +                                                         # y axis title
theme_bw() +                                                                    # adds a theme to the graph
scale_fill_manual(values = c("#b0986c","#f57946")) +                            # give her some fall colors for fall data
theme(plot.title = element_text(size = 14),                                     # increase title font size
      plot.caption.position = "plot")                                           # moves the source caption to the bottom right

#ggsave(here("Week_04","Outputs", "ChemData_Tidy_Homework_4B.pdf"),             # exports plot into a PDF into output folder
              #width=7, height=5)


  















