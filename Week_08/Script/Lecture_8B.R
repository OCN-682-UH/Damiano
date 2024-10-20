
### Lecture Week 8B ###
### Created by: Savannah Damiano #####
### Updated on 2024-10-19#############


#### Class Outline ####
#Advanced plotting
##{patchwork} - bringing plots together
##{ggrepel} - repel your labels on your plots
##{gganimate} - add some animations to your plots
##{magick} - photo processing


#### Load Libraries ####

library(tidyverse)
library(here)
library(patchwork)      # for bringing plots together
library(ggrepel)        # for repelling labels
library(gganimate)      # animations
library(magick)         # for images
library(palmerpenguins) # bc we love those little rascals 


#### Data Analysis ####

### Intro to Patchwork

#Goal: Make two simple plots that are unique from each other that we will patchwork together. They will be named p1 and p2.

# plot 1
p1<-penguins %>%
  ggplot(aes(x = body_mass_g,        #map body mass and bill length
             y = bill_length_mm, 
             color = species))+
  geom_point()
p1


# plot 2
p2<-penguins %>%
  ggplot(aes(x = sex,               #map sex and body mass
             y = body_mass_g, 
             color = species))+
  geom_jitter(width = 0.2)
p2

#bring the plots together!
p1+p2  +                                             # + puts the plots next to each other (side to side)
  plot_layout(guides = 'collect') +                  # makes it only one legend (guide) instead of two 
  plot_annotation(tag_levels = 'A')                  # adds tags to plots. can tag the plots with anything- digits, letters, roman numerals


### Intro to ggrepel

view(mtcars)

ggplot(mtcars, aes(x = wt,                           #weight
                   y = mpg,                          #miles per gallon
                   label = rownames(mtcars))) +      #labels the dots so you can see which car is each dot. ALSO, this is how you extract row names, since the car names are the row headers. 
  geom_text_repel() +                                #creates a text label. repels the labels so they are not on top of eachother  
  geom_point(color = 'red')


# use the label function 
ggplot(mtcars, aes(x = wt, 
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_label_repel() +                               #creates a text label. repels the labels so they are not on top of each other. puts labels under them 
  geom_point(color = 'red')


### Intro to gganimate

#Let's go back to our penguin plot, but animate the figure by year. 
#Our static plot.

penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year,                                                    #what we are animating by 
    transition_length = 2,                                   #The relative length of the transition.
    state_length = 1) +                                      #The length of the pause between transitions
  ease_aes("sine-in-out") +                                  # the aes for transitions. There are several to chose from (look at notes)
  labs(title = 'Year: {closest_state}')  +                   # create a title label to change the year with the animation. Year is what we want the label to be named. The stuff inside the {} is what we want animated 
  anim_save(here("Week_08", "Output", "penguingif1.gif"))    # how to save as gif

 
#animate figure by sex
penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    sex,                                                    #what we are animating by 
    transition_length = 2,                                  #The relative length of the transition.
    state_length = 1) +                                     #The length of the pause between transitions
  ease_aes("sine-in-out") +                                 # the aes for transitions. There are several to chose from (look at notes)
  labs(title = 'Sex: {closest_state}') +                    # create a title label to change the year with the animation. Sex is what we want the label to be named. The stuff inside the {} is what we want animated 
 anim_save(here("Week_08", "Output", "penguingif2.gif"))    # how to save as gif


### Intro to magick

#We are going to put a penguin picture into our plot
#Read in an image of a penguin (can be from your computer or the internet)

penguin<-image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")
penguin     #stop hes so cute

#To put our cute penguin into your plot, we first need to save the plot as an image (.png or .jpg)

penguins %>%
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() 
  ggsave(here("Week_08", "Output", "penguinplot.png"))

penguinplot <- image_read(here("Week_08", "Output", "penguinplot.png"))        #read in your plot
out <- image_composite(penguinplot, penguin, offset = "+70+30")                #whatever you want in background (penguinplot), put first. whatever you want on top (penguin), put second. offset tells R where we want to penguin to be on the plot
out

#ggsave(here("Week_08", "Output", "penguinplot2.png"))    #how do I save with the penguin on top?





#you can add gifs too
# Read in a penguin gif
pengif<-image_read("https://media3.giphy.com/media/H4uE6w9G1uK4M/giphy.gif") 
outgif <- image_composite(penguinplot, pengif, gravity = "center")             #penguinplot in background, pengif in front. gravty="center" centers the image on the plot 
animation <- image_animate(outgif, fps = 10, optimize = TRUE) 

# we can save this with anim_save
#anim_save(here("Week_08", "Output", "penguingif3.gif"))       # this is not saving the penguin gif?






### Totally Awesome R package 

#sourdough recipes in R

library(sourrr)
build_recipe( final_weight = 900, hydration = 0.75)





