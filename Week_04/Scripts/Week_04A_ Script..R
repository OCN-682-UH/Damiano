### Today we going to plot penguin data with tidyverse###
### Created by: Savannah Damiano #####
### Updated on 2024-09-17#############

### Load Libraries #####
library(palmerpenguins)
library(tidyverse)
library(here)


### Load data###
#The data is part of the package and is called penguins
#ALWAYS VIEW DATA FIRST- head, tail, view
#How else besides glimpse can we inspect data?

glimpse(penguins)                                 #shows the structure and data of the dataframe
head(penguins)                                    #looks at the top 6 lines of the dataframe 

###Data Analysis#

filter(.data = penguins, year == "2008")                                        #extract rows with filter

filter(.data = penguins, body_mass_g >= 5000)


filter(.data = penguins, year == "2008" | year == "2009")
view(penguins)

filter(.data = penguins, island != "Dream")

filter(.data = penguins, species %in% c("Adelie","Gentoo"))

data2 <- mutate(.data = penguins,                                               #make a new column with mutate
                body_mass_kg = body_mass_g/1000)
view(data2)

data2 <- mutate(.data = penguins,
                body_mass_kg = body_mass_g/1000,                                #convert mass to kg
                bill_length_depth = bill_length_mm/bill_depth_mm)               #calculate the ratio of bill length to depth
view(data2)

data2<- mutate(.data = penguins,
               after_2008 = ifelse(year>2008, "After 2008", "Before 2008"))              # used ifelse to create a new column that tells you if the data was after or before 2008
view(data2)

data2 <- mutate(.data = penguins,
                flipper_plus_mass = body_mass_g + flipper_length_mm,                     # made a new column to add flipper length and body mass together
                thicc_penguins = ifelse(body_mass_g > 4000, "Big boi", "Smol boi"))      # used ifelse to create a new column where body mass greater than 4000 is labeled as big and everything else is small
view(data2)

          # %>% means and - do - then
          #Dataframe %>% # select the dataframe and then
              #verb1() %>% # do verb 1 and then
                  #verb2() # do verb 2


penguins%>%                                                                     # Use penguin dataframe  #When you use %>% the dataframe carries over so you don't need to write it out anymore
  filter (sex == "female") %>% #select females                                  # This filters female penguins
  mutate(log_mass = log(body_mass_g)) %>% #calculate log biomass                # Mutate- adds a new column that calculates the log body mass
  select(Species = species, island, sex, log_mass)


penguins %>%                                                                  # computer a summarized data              
  summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE),               # calculate the the mean flipper length and exclude NA's. 
            min_flipper = min(flipper_length_mm, na.rm = TRUE))               # calculate mean and min flipper length

view(penguins)

#GOAL :Filter only female penguins and add a new column that calculates the log body mass. When you use %>% the dataframe carries over so you don't need to write it out anymore 

penguins%>%                                                                   # use penguin dataframe
  filter(sex == "female") %>%                                                 # select females
  mutate(log_mass = log(body_mass_g)) %>%                                     # calculate log biomass
  select(Species = species, island, sex, log_mass)                            # selects out the columns I want to keep. Renamed species to a captital S

#Summarize- GOAL1: calculate mean flipper length (and exclude NAs). GOAL2: Calculate mean and min flipper length 

penguins%>%
  summarize(mean_flipper = mean(flipper_length_mm, na.rm = TRUE),              # na.rm removed all NAs
           min_flipper = min(flipper_length_mm, na.rm = TRUE))

#GROUP_BY - Goal:calculate the mean and max bill length by island and sex. Then drop rows with NAs from a specific colum (sex)

penguins %>% 
  drop_na (sex) %>%                                                           # drops an NA in the column you specify, but it will keep NAs in the columns you dont specify 
  group_by(island, sex) %>%                                                   # use group_by to summarize values by certain groups - here we grouped by island and sex
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),            # calculate the mean bill length
             max_bill_length = max(bill_length_mm, na.rm=TRUE))               # calculate the max bill length 


#Pipe into ggplot 
#Once your back in ggplot you have to use plus signs (+)
penguins %>%
  drop_na(sex)%>%
  ggplot(aes(x=sex, y= flipper_length_mm)) +
  geom_boxplot()
  



