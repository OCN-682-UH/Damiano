Homework 13a: Interactive Coding
================
Savannah Damiano
2024-12-8

## Homework

- You have a set of 4 .csv files in data/homework.

- Each of these files is a time series of temperature and light data
  collected in tide pools in Oregon by Jenn Fields.

- Your goal is to bring in all 4 files and calculate the mean and
  standard deviation of both temperature (Temp.C) and light
  (Intensity.lux) for each tide pool.

- Use both a for loop and map() functions in your script. (Basically, do
  it twice).

- Due Tuesday at 1pm.

## Load Libraries

``` r
library(tidyverse)
library(here)
```

## Load Data

``` r
# I am only loading the .csv here so I can view the data before I start the HW.

#TP1<-read_csv(here("Week_13","Data", "homework", "TP1.csv"))

#TP2<-read_csv(here("Week_13","Data", "homework", "TP2.csv"))

#TP3<-read_csv(here("Week_13","Data", "homework", "TP3.csv"))

#TP4<-read_csv(here("Week_13","Data", "homework", "TP2.csv"))
```

## for loop

``` r
#Step 1: Tell .R the location of the files on the computer
Tpath <- here("Week_13","Data", "homework")         #location of folder
Tfiles <- dir(path = Tpath, pattern = ".csv")       #every file in the folder that has a .csv pattern
Tfiles                                              #check to make sure all 4 .csv are in 'files' value
```

    ## [1] "TP1.csv" "TP2.csv" "TP3.csv" "TP4.csv"

``` r
#Step 2: Pre-allocate space for a loop & calculate mean and sd
loopdata<- tibble( filename= rep(NA, length(Tfiles)),    #column name for PoolID. length is the number of files we imported
                   mean_temp= rep(NA, length(Tfiles)),   #column name for mean temp calc.
                   sd_temp= rep(NA, length(Tfiles)),     #column name for sd temp calc.
                   mean_light= rep(NA, length(Tfiles)),  #column name for mean light calc.
                   sd_light= rep(NA, length(Tfiles)))     #column name for sd light calc.
                   
loopdata #check df
```

    ## # A tibble: 4 × 5
    ##   filename mean_temp sd_temp mean_light sd_light
    ##   <lgl>    <lgl>     <lgl>   <lgl>      <lgl>   
    ## 1 NA       NA        NA      NA         NA      
    ## 2 NA       NA        NA      NA         NA      
    ## 3 NA       NA        NA      NA         NA      
    ## 4 NA       NA        NA      NA         NA

``` r
#Step 3: Write a basic code to calculate mean to check that the code works
# We will test by reading in the first file [1] 
# paste0 is a function used to combine strings without any space or separator between them
# "/" used to separate the directory path and the filename
raw_data <- read_csv(paste0(Tpath,"/",Tfiles[1]))   
head(raw_data) #check df
```

    ## # A tibble: 6 × 7
    ##   PoolID Foundation_spp Removal_Control Date.Time    Temp.C Intensity.lux
    ##    <dbl> <chr>          <chr>           <chr>         <dbl>         <dbl>
    ## 1      1 Phyllospadix   Control         6/16/19 0:01   10.2             0
    ## 2      1 Phyllospadix   Control         6/16/19 0:16   10.1             0
    ## 3      1 Phyllospadix   Control         6/16/19 0:31   10.2             0
    ## 4      1 Phyllospadix   Control         6/16/19 0:46   10.1             0
    ## 5      1 Phyllospadix   Control         6/16/19 1:01   10.1             0
    ## 6      1 Phyllospadix   Control         6/16/19 1:16   10.1             0
    ## # ℹ 1 more variable: LoggerDepth <dbl>

``` r
mean_temp <- mean(raw_data$Temp.C, na.rm = TRUE)   #calculate the mean of temp.c
mean_temp
```

    ## [1] 13.27092

``` r
#Step 4: Turn it into a for loop
for (i in 1:length(Tfiles)) {       #loop through the number of files in Tfiles
  raw_data <- read_csv(paste0(Tpath,"/",Tfiles[1]))  #read in .csv in the Tfiles index.  

  loopdata$filename[i] <-Tfiles[i]  #put the file names in this column
  
  loopdata$mean_temp[i] <- mean(raw_data$Temp.C, na.rm = TRUE)   #calculate the mean temp (for each file) and place it in the corresponding row
  loopdata$sd_temp[i] <- sd(raw_data$Temp.C, na.rm = TRUE)       #calculate the sd temp (for each file) and place it in the corresponding row
  loopdata$mean_light[i] <- mean(raw_data$Intensity.lux, na.rm = TRUE) #calculate the mean light (for each file) and place it in the corresponding row
  loopdata$sd_light[i] <- sd(raw_data$Intensity.lux, na.rm = TRUE) #calculate the sd light (for each file) and place it in the corresponding row
}

loopdata #check df
```

    ## # A tibble: 4 × 5
    ##   filename mean_temp sd_temp mean_light sd_light
    ##   <chr>        <dbl>   <dbl>      <dbl>    <dbl>
    ## 1 TP1.csv       13.3    2.32       427.    1661.
    ## 2 TP2.csv       13.3    2.32       427.    1661.
    ## 3 TP3.csv       13.3    2.32       427.    1661.
    ## 4 TP4.csv       13.3    2.32       427.    1661.

## map()

``` r
#Step 1: Tell .R the location of the files on the computer
TPpath<- here("Week_13","Data", "homework")
files<- dir(path = TPpath, pattern = ".csv", , full.names =TRUE)
files #check to make sure all 4 .csv are in 'files' value
```

    ## [1] "C:/Users/savan/OneDrive/Desktop/Repositories/Damiano/Week_13/Data/homework/TP1.csv"
    ## [2] "C:/Users/savan/OneDrive/Desktop/Repositories/Damiano/Week_13/Data/homework/TP2.csv"
    ## [3] "C:/Users/savan/OneDrive/Desktop/Repositories/Damiano/Week_13/Data/homework/TP3.csv"
    ## [4] "C:/Users/savan/OneDrive/Desktop/Repositories/Damiano/Week_13/Data/homework/TP4.csv"

``` r
#Step 2: Read in the files using map()
mapdata <- files %>%
  set_names() %>%                      # this set's the .id of each list to the file name 
  map_df(read_csv, .id = "filename")%>% # asks .r to map the data into a df and to label the column with the filenames 'filenames'. And saves the entire path name.

#Step 3: Calculate mean and standard deviation of both temperature (Temp.C) and light (Intensity.lux) for each tide pool
group_by(PoolID) %>%  #group by Tide Pool
summarise(
    mean_temp = mean(Temp.C, na.rm = TRUE),        #calculate mean temp, remove NA
    sd_temp = sd(Temp.C, na.rm = TRUE),            #calculate standard deviation, remove NA
    mean_light = mean(Intensity.lux, na.rm = TRUE),#calculate mean temp, remove NA
    sd_light = sd(Intensity.lux, na.rm = TRUE))    #calculate standard deviation, remove NAA

mapdata #check df
```

    ## # A tibble: 4 × 5
    ##   PoolID mean_temp sd_temp mean_light sd_light
    ##    <dbl>     <dbl>   <dbl>      <dbl>    <dbl>
    ## 1      1      13.3    2.32       427.    1661.
    ## 2      2      13.2    2.31      5603.   11929.
    ## 3      3      13.1    2.32      5605.   12101.
    ## 4      4      13.2    2.27       655.    2089.
