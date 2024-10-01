### Today we are going to practice Data Wrangling: Lubridate Dates and Times####
### Created by: Savannah Damiano #############
### Updated on: 2024-09-26 ####################


#### Load Libraries ######

library(tidyverse)
library(here)
library(lubridate)                  #package to deal with dates and times
library(devtools)
#install_github("Gibbsdavidl/CatterPlots")    #install the data
library(CatterPlots)

#### Load Data  #####

CondData<-read.csv(here("Week_05","Data", "CondData.csv")) 
view(CondData)
head(CondData)

### Data Analysis ##### 


##What time is it now?
now()                               # what time is now?
                                    # [1] "2024-09-26 16:22:51 HST"
now(tzone = "EST")                  # what time is it on the east coast?

now(tzone = "GMT")                  # what time in GMT?

today()                             # if you want today's date but not the time

today(tzone = "GMT")                # todays date in GMT

am(now())                           # is it morning? TRUE OR FALSE. CAn be helpful when you want to divide data into morning and afternoon/ night 

leap_year(now())                    # is it a leap year?


##Date specifications ----- dates must be a character- put in "quotes"

ymd("2021-02-24")                   # each of these will produce the same results as ISO dates (YYY-MM-DD)             
mdy("02/24/2021")
mdy("February 24 2021")             # the function changes depending on the order of date month year (not the begining of each function)    
dmy("24/02/2021")


##Date and Time Specifications ------ underscore between date and time

ymd_hms("2021-02-24 10:22:20PM")                  # each of these will produce the same results as ISO dates (YYY-MM-DD)  
mdy_hms("02/24/2021 22:22:20")                    # it will assume military time if you do not specify AM or PM
mdy_hm("February 24 2021 10:22 PM")               # make sure you are double checking if the dataframe has seconds or not 


##Extracting specific date or time elements from datetimes

#make a character string
datetimes<-c("02/24/2021 22:22:20",
             "02/25/2021 11:21:10",
             "02/26/2021 8:01:52")

#convert to datetimes
datetimes <- mdy_hms(datetimes)                   #converts it to ISO format

month(datetimes)                                  # shows you the months from your character stream

month(datetimes, label = TRUE, abbr = FALSE)      # label = TRUE changes the labels of the month to words instead of numbers
                                                  # abbr = FALSE spells the labels out 
day(datetimes)                                    # extracts the days                               
 
wday(datetimes, label = TRUE)                     # extracts day of the week 

datetimes + hours(4)                              # this adds 4 hours - make sure to use plural hours

datetimes + days(2)                               # this adds 2 days - make sure to use plural days

round_date(datetimes, "minute")                   # round to nearest minute

round_date(datetimes, "5 mins")                   # round to nearest 5 minute


#Challenge:
#Read in the conductivity data (CondData.csv) and convert the date column to a datetime. 
#Use the %>% to keep everything clean.

Datetime <- CondData %>%
mutate(Datetime= mdy_hms(date))%>%                # a new column with corroct ISO datetime
select(Datetime, Temperature,Serial, Salinity)    # selects the columns that i chose to be in the dataframe



#CatterPlots
x <-c(1:10)    # make up some data
y<-c(1:10)
catplot(xs=x, ys=y, cat=3, catcolor='purple')






