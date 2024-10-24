
### Lecture Week 9A ###
### Created by: Savannah Damiano #####
### Updated on 2024-10-122#############

#### Class Outline ####

#When to Write a Function
#How to make a custom function

#### Load Libraries ####

library(here)
library(tidyverse)   
library(palmerpenguins)
library(PNWColors)

#### Load Data ####

#### Data Analysis ####

#First set-up your script and create a dataframe of random numbers

df <- tibble(
  a = rnorm(10), # rnorm draws 10 random values from a normal distribution
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
head(df)

# Rescale every column individually 
# Let's use an example where we want to rescale data in multiple columns (value - min/(max - min))

#equation is  (value - min/(max - min))
df<-df %>%
  mutate(a = (a-min(a, na.rm = TRUE))/(max(a, na.rm = TRUE)-min(a, na.rm = TRUE)),      #mutate to create a new column
         b = (b-min(b, na.rm = TRUE))/(max(b, na.rm = TRUE)-min(b, na.rm = TRUE)),      #copy and paste all function so they are identical for a-d
         c = (c-min(c, na.rm = TRUE))/(max(c, na.rm = TRUE)-min(c, na.rm = TRUE)),      #be careful about making mistakes!
         d = (d-min(d, na.rm = TRUE))/(max(d, na.rm = TRUE)-min(d, na.rm = TRUE)))

# did we make a mistake?
# We can write a function for this to avoid mistakes 

#function/ equation 
rescale01 <- function(x) {
  value <-(x-min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE)-min(x, na.rm =TRUE))
  return(value)
}

#using our newly created function, we can plug it in to avoid mistakes 

df %>%
  mutate(a = rescale01(x = a),      # replace x with a
         b = rescale01(x = b),
         c = rescale01(x = c),
         d = rescale01(x = d))

#Make a function to covert degrees Fahrenheit to Celsius
#What is the calculation for F to C?

temp_C <- (temp_F - 32) * 5 / 9     # arrow just means equal to
                                    # function to convert Celsius from faren

#Step 1: Name the function
#backbone of our function! Make sure to use curly brackets!

fahrenheit_to_celsius <- function() {
}

#Step 2: Put in the equation
#paste our equation in

fahrenheit_to_celsius <- function() { 
  temp_C <- (temp_F - 32) * 5 / 9
}

#Step 3: Decide what the arguments are


fahrenheit_to_celsius <- function(temp_F) {             #added temp_F
  temp_C <- (temp_F - 32) * 5 / 9 
}

#Step 4: Decide what is being returned

fahrenheit_to_celsius <- function(temp_F) { 
  temp_C <- (temp_F - 32) * 5 / 9 
  return(temp_C)                                       #added return
}

#Step 5: Test it
#replace (temp_F) with our temp in F

fahrenheit_to_celsius( temp_F= 32)
fahrenheit_to_celsius(212)

#Question: Write a function that converts Celsius to kelvin. (Remember Kelvin is celcius + 273.15).

celcius_to_kelvin <- function(celcius) {
  kelvin <- celcius + 273.15
  return(kelvin)
}
celcius_to_kelvin(celcius = 32)       #to test the function, it can be written in two different ways
celcius_to_kelvin(32)

##Making plots into a function 
#Let's say you have a specifically formatted plot that you like and that you plan to use over and over again. By turning it into a function, you only have to code it once.

pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 

ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
  geom_point()+
  geom_smooth(method = "lm")+ # add a linear model
  scale_color_manual("Island", values=pal)+   # use pretty colors and another example of how to manually change the legend title for colors
  theme_bw()

#name and set-up the function 

myplot<-function(){              #backbone
  
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
  
}

#What do you think our arguments should be? dataframe, x, y, etc.
#Make the names broad so it can be applicable to several values

myplot<-function(data, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  
ggplot(data, aes(x = x, y =y , color = island))+                                #not right
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}

#Test it
myplot(data = penguins, x = body_mass_g, y = bill_length_mm)

#I got an error.... why do we think that is?
### we did not add "curly-curly" {{}} to help us assign variables that are column names in dataframes

myplot<-function(data, x, y){ 
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
 
ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+                       #now it is right! curly-curly around x and y
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}  

#Test again
myplot(data = penguins, x = body_mass_g, y = bill_length_mm)

myplot(data = penguins, x = body_mass_g, y = flipper_length_mm)

#Adding Defaults
#lets say you want to create a default for the function to always default to the penguins dataset

myplot<-function(data = penguins, x, y){
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  
ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+ # add a linear model
    scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
    theme_bw()
}
#test
myplot(x = body_mass_g, y = flipper_length_mm)

#Layering the plot
#you can layer onto your plot using the '+' just like a regualr ggplot to change things- like your labels

myplot(x = body_mass_g, y = flipper_length_mm)+
  labs(x = "Body mass (g)",
       y = "Flipper length (mm)")





#if -else statements 
# you can add if-else statements for more flexibility 
# Imagine you want a variable to be equal to a certain value if a condition is met. This is a typical problem that requires the if ... else ... construct.

a <- 4
b <- 5

#Suppose that if a > b then f should be = to 20 orrrrr else f should be equal to 10. Using if/else we:

if (a > b) {                       #my question
    f <- 20                        #if it is true give me answer 1
} else {                           #else give me answer 2
    f <-10
  }

f

#now, using if...else... we can make our function even more flexible. Let's say we want the option of adding the geom_smooth lines. We can create a variable that if set to TRUE add the geom_smooth, otherwise print without.
#First add a new argument for lines and make the default TRUE for ease

myplot<-function(data = penguins, x, y ,lines=TRUE ){          # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete")                # my color palette 

ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
    geom_point()+
    geom_smooth(method = "lm")+                                # add a linear model
    scale_color_manual("Island", values=pal)+                  # use pretty colors and change the legend title
    theme_bw()
}

# now add in the if-else 

myplot<-function(data = penguins, x, y, lines=TRUE ){ # add new argument for lines
  pal<-pnw_palette("Lake",3, type = "discrete") # my color palette 
  
if(lines==TRUE){
ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      geom_smooth(method = "lm")+ # add a linear model
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
  }
else{
ggplot(data, aes(x = {{x}}, y = {{y}} , color = island))+
      geom_point()+
      scale_color_manual("Island", values=pal)+   # use pretty colors and change the legend title
      theme_bw()
      #DOES NOT INCLUDE GEOM_SMOOTH
}
}

#with lines
myplot(x = body_mass_g, y = flipper_length_mm)
#without lines
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)



#Today awesome R package
library(emokid)
iamsad()
iamlesssad()
mymood()








