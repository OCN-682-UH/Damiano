### Lecture Week 4A Homework Question 2 ###
### Created by: Savannah Damiano #####
### Updated on 2024-09-18#############

### Load Libraries #####
library(palmerpenguins)                           # load the penguin dataset
library(tidyverse)                                # for data tidying
library(here)                                     # "to enable easy file referencing in project-oriented workflows"
library(PNWColors)                                # add more colors!

### Load data #######
view(penguins)
glimpse(penguins)                                 #show the structure and data of the dataframe
head(penguins)                                    


###Data Analysis#

#QUESTION 2: 
#Refer to PPT slide #34 for help
# 1) Filters out (i.e. excludes) male penguins - get rid of male penguin data
# 2) Calculates the log body mass 
# 3) Selects only the columns for species, island, sex, and log body mass
# 4) Then use these data to make any plot. 
# Make sure the plot has clean and clear labels and follows best practices. 
# Save the plot in the correct output folder. 

penguins %>%                                                     
  filter (sex != "males") %>%                                                  # removes male data
  mutate( log_mass = log(body_mass_g)) %>%                                     # calculates log biomass
  select(species, island, sex, log_mass)%>%                                    # selects for only columns species, island, sex, and log mass 

ggplot(mapping = aes(x = log_mass,                                             # x axis is log mass
                     y = island,                                               # y axis is island
                     fill = species))+                                         # fills in the species with color

geom_violin(alpha= 0.8)+                                                       # I chose a violin plot. I chose Alpha 0.8 for a little bit of transparency to better see the grids.                                                    
  labs(title = "Body Mass of Female Penguins",                                 # title
       subtitle = "Dimentions for Adelie, Chinstrap, and Gentoo Penguins Across Three Islands",    #subtitle
       x = "Body Mass (log)",                                                  # x-axis title with capital letters
       y = "Island",                                                           # y-axis title with capital letter
       caption = "Source: Palmer Station LTER / palmerpenguins package")+      # added a caption to give credit where credit is due                                # 
  guides(fill=guide_legend(title = "Species"))+                                # capitalized the legend title
  theme_grey()+                                                                # adds a theme to the graph- grey background
  theme(axis.title= element_text(size = 13),                                   # change axis text size
        plot.title= element_text(size = 18),                                   # change title text size
        plot.caption.position = "plot") +                                      # make caption on the bottom right of the page
  scale_fill_manual(values = c("lavender","#c26a7a","pink"))+                   # make the colors in the graph a little more girly for the girl penguins
  
  
ggsave(here("Week_04","Output","PalmerPenguin_Homework_4A.png"),               # Saves the graph to Damiano- Week 4- Outputs- and names it
       width=7, height=5)                                                      # Altered the size of the saved graph to  7x5 inches
