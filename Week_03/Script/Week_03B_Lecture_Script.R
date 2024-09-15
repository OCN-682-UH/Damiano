### Today we going to plot penguin data ###
### Created by: Savannah Damiano #####
### Updated on 2024-09-24#############

### Load Libraries #####
library(palmerpenguins)
library(tidyverse)
library(here)
library(beyonce)           #added the Beyonce color palette
library(ggthemes)          #added a theme package

### Load data###
#The data is part of the package and is called penguins
#ALWAYS VIEW DATA FIRST- head, tail, view
#How else besides glimpse can we inspect data?

glimpse(penguins) #shows the stucture and data of the dataframe
head(penguins)                           #looks at the top 6 lines of the dataframe
tail(penguins)                           #looks at the bottom 6 lines of the dataframe
view(penguins)                           #opens a new window to look at the entire dataframe

###Data Analysis#

plot1<-ggplot(data = penguins,
    mapping = aes (x = bill_depth_mm,     #Mapping is directly related to your data
                  y = bill_length_mm,      
                  group= species,
                  color=species))+        # + means your adding a layer
  geom_point()+                           #Setting configures aspects of the plots appearance and behavior
  geom_smooth(method = "lm")+             #Goes in after geom_point because it affects appearance
    labs(x = "Bill depth (mm)",
          y = "Bill length (mm)"
  )+
  scale_color_viridis_d()+                                      # ALWAYS REMEMBER YOU + SIGN
  scale_x_continuous(breaks = c(14,17,21),                      # c() means concatenate. Anytime you change a vector of numbers, you have to use c()
                    labels = c("low","medium","high"))+         # Changed x axis labels
  scale_color_manual(values = beyonce_palette(2))+              # Use _manual because we are manually changing the colors of the graph points 
  theme_bw() +                                                  # Adds themes to the graphs
  theme(axis.title = element_text(size = 20,                    # Changes the axis title text size to 20 pt. font
                                  color= "red"),                # Changes the axis title text color
        panel.background = element_rect(fill="linen"),          # 'fill' fills in the graph background
        legend.background = element_rect(color = "pink"),       # colors the legend outline box pink
        axis.ticks = element_line(linewidth = 2))               # made the axis tick mark linewidth thicker
 
ggsave(here("Week_03","Output","Penguin.png"),                  # Saves the graph to Damiano- Week 3- Outputs- and names it Penguin.pdf
       width=7, height=5)                                       # Altered the size of the saved graph to  7x5 in inches

 
#### This is a new graph to show us how to change coordinates: Transform the x and y-axis (log10)###
  
ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  coord_trans(x = "log10", y = "log10")

  
  
  