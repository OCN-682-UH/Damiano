### Today we going to plot penguin data all by ourselves###
### Created by: Savannah Damiano #####
### Updated on 2024-09-24#############

### Load Libraries #####
library(palmerpenguins)                   #for penguin data
library(ggplot2)                          #to use ggplot
library(tidyverse)
library(here)                             #to enable easy file referencing
library(PNWColors)                        #added theme package

### Load data###
#The data is part of the package and is called penguins
#ALWAYS VIEW DATA FIRST- head, tail, view

glimpse(penguins)                        #shows the structure and data of the dataframe
head(penguins)                           #looks at the top 6 lines of the dataframe
tail(penguins)                           #looks at the bottom 6 lines of the dataframe
view(penguins)                           #opens a new window to look at the entire dataframe
str(penguins)                            #structure of data

###Functions###

#no functions


###Data Analysis###

ggplot(data = penguins,                             # Mapping is directly related to your data
       mapping = aes(x = body_mass_g,               # x-axis body mass in g
                     y = flipper_length_mm,         # y-axis flipper length in mm
                     group = species,               # groups data by species
                     fill = species))+              #fills in the species data with color

  geom_violin(alpha = 0.5)+                                                               # violin plot. Alpha changes transparency.
  geom_boxplot(width = 0.5) +                                                             # box plot inside violin 
   labs( title = "Flipper Length and Body Mass of Palmer Penguins",                       # added a title to the graph
         subtitle = "Dimentions for Adelie, Chinstrap, and Gentoo Penguins by Island",    # added a subtitle to the graph
         x = "Body Mass (g)",                                                             # changed x-axis title
         y = "Flipper Length (mm)",                                             # changed y-axis title
         caption = "Source: Palmer Station") +                                  # added a caption at bottom of page- source of data
  guides(fill=FALSE) +                                                          # delete legend
  theme_bw()+                                                                   # adds theme to graph
  scale_fill_manual(values = c("#24492e","#e69b99","#89689d")) +                # from PNW palette- changed the color of the graph to specific colors in palette
  scale_y_continuous(breaks = c(170, 190, 210, 230)) +                          # simplified y-axis tick mark numbers
  scale_x_continuous(breaks = c(3000, 4500, 6000))+                             # simplified x-axis tick mark numbers
  facet_grid(island~species)+                                                   # (rows~columns) a matrix of panels- 2d grid                                               
  theme(plot.title = element_text(size = 18))                                   # changed title size


ggsave(here("Week_03","Output","PalmerPenguin_Homework.png"),                   # Saves the graph to Damiano- Week 3- Outputs- and names it Penguin.pdf
       width=7, height=5)                                                       # Altered the size of the saved graph to  7x5 inches


 

  
    
  



