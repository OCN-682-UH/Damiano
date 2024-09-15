### This is my Week 3 script. I am learning how to input data and make a plot.
### Created by: Savannah Damiano
### Created on: 2024-09-10
##################################################

### Load libraries #########
library(palmerpenguins)
library(tidyverse)
glimpse (penguins)

#look at the data
view(penguins)
head(penguins)
tail(penguins)
glimpse(penguins)

#make a plot
ggplot(data=penguins,
  mapping= aes(x= bill_depth_mm,
               y=bill_length_mm,
               color=species,
               size= body_mass_g,
               alpha=flipper_length_mm
               ))+
  geom_point() +
    facet_wrap (~species,ncol=2) +


    labs(title="Bill depth and lenght",
         subtitle = "Dimensions for Adelle, Chinstrap, and Gentoo Penguins",
            x= "bill depth (mm)", y= "bill length (mm)",
            color= "Species",
            caption = "Source: Palmer Station LTER/ palmerpenguins package")+
  scale_color_viridis_d() +
  facet_grid(species~sex) +
  guides (color= FALSE)
 
  
  

      
