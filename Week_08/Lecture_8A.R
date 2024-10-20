#### Introduction ####
### Lecture Week 8A ###
### Created by: Savannah Damiano #####
### Updated on 2024-10-15#############

#### Class Outline ####

##Working with words
#Using {stringr} to clean up strings (part of tidyverse)
#Intro to regex (regular expressions)
#Using {tidytext} for text mining/analysis
#Make a wordcloud

#### Load Libraries ####

library(here)
library(tidyverse)            #using {stringr} to clean up strings
library(tidytext)             #for text mining and making tidy text
library(wordcloud2)           #word cloud builder
library(janeaustenr)          #Jane Austen books

#### Load Data ####

#### Data Analysis ####

### Intro to {stringr}

words <- "This is a string"                                                     #a string and a character are the same thing.
words                                                                           #a string needs to be in quotations

words_vector<- c("Apples", "Bananas", "Oranges")                                #you can have several strings in a vector
words_vector


##{stringr} Manipulation 
paste("High temp", "Low pH")                                                    #Paste words together. This can be useful if say you have a two columns of treatments and you want to combine them into one 

# add a dash in between the words
paste("High temp", "Low pH", sep = "-")

# remove the space btwn words
paste0("High temp", "Low pH")

# Working with vectors
shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes)

two_cities <- c("best", "worst")
paste("It was the", two_cities, "of times.")                                    # this method can be useful when making labels for your plots

##{stringr} Manipulation: individual characters

# lets say you want to know how long a strong is:
shapes              #vector of shapes
str_length(shapes)  #how many letters are in each word?

# let's say you want to extract specific characters. Do you work with sequence data? This could be super useful to exact specific bases in a sequence.
seq_data<-c("ATCCCGTC")               #DNA
str_sub(seq_data, start = 2, end = 4) # extract the 2nd to 4th AA

# you can also modify strings
str_sub(seq_data, start = 3, end = 3) <- "A"      # add an A in the 3rd position
seq_data

# you can duplicate patterns in your string - example: duplicating it 2 and 3 times
str_dup(seq_data, times = c(2, 3))  # times is the number of times to duplicate each string



##{stringr} Whitespace

#Example: you have a column and you did not copy and paste your treatments.  You now have some words with extra white spaces and R thinks its an entirely new word.
badtreatments<-c("High", " High", "High ", "Low", "Low")
badtreatments                        # see all the extra whitespace?

str_trim(badtreatments)              # this removes whitespace

str_trim(badtreatments, side = "left") # you can pick what side of the word you want to remove whitespace from. this removes left

#The opposite of str_trim is str_pad, to add white space or characters to either side
str_pad(badtreatments, 5, side = "right")            # add a white space to the right side after the 5th character

str_pad(badtreatments, 5, side = "right", pad = "1") # add a 1 to the right side after the 5th character



##{stringr} Locale Sensitive
# default language is English. Will perform differently in different places in the world

x <- "I love R!"

str_to_upper(x)      #makes in uppercase
str_to_lower(x)      #makes in lowercase
str_to_title(x)      #makes it title case (Cap letter for each word)



##{stringr} Pattern Matching
#{stringr} has functions to view, detect, locate, extract, match, replace, and split strings based on specific patterns.

#view patterns
data<-c("AAA", "TATA", "CTAG", "GCTT")
str_view(data, pattern = "A")            # find all the strings with an A

#detect patterns
str_detect(data, pattern = "A")          # TRUE FALSE
str_detect(data, pattern = "AT")

#locate patterns
str_locate(data, pattern = "AT")



### Intro to regex: regular expressions

#Metacharacters: The metacharacters in Extended Regular Expressions (EREs) are: . \ | ( ) [ { $ * + ?

vals<-c("a.b", "b.c","c.d")

# we want to replace all the "." with a space
str_replace(vals, "\\.", " ")                   #string, pattern, replace

#Each function in {stringr} has two forms a basic form that searches for the first instance of a character and a *_all that searches for all instances. For example:
# now lets pretend we had multiple "." in our character vector

vals<-c("a.b.c", "b.c.d","c.d.e")
str_replace(vals, "\\.", " ")                   #string, pattern, replace

#str_replace only replaces the first instance. Let's try str_replace_all()
str_replace_all(vals, "\\.", " ")               #string, pattern, replace


#Sequences
#Sequences, as the name suggests refers to the sequences of characters which can match. We have shorthand versions (or anchors) for commonly used sequences in R:

#subset the vector to only keep strings with digits
val2<-c("test 123", "test 456", "test")
str_subset(val2, "\\d")                        #string, pattern



#Character Class
#A character class or character set is a list of characters enclosed by square brackets [ ]. Character sets are used to match only one of the different characters. For example, the regex character class [aA] matches any lower case letter a or any upper case letter A.

#count the number of lowercase vowels in each string
str_count(val2, "[aeiou]")  #count the number if lowercase vowels
str_count(val2, "[0-9]")    # count the number of digits in each character


#Quantifiers
#Example: find phone numbers

strings<-c("550-153-7578",
           "banana",
           "435.114.7586",
           "home: 672-442-6739")

phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"     #look at ppt notes for explination

#Which strings contain phone numbers?
str_detect(strings, phone)
#subset only the strings with phone numbers
test<-str_subset(strings, phone)
test

##Think, Pair, Share

strings<-c("550-153-7578",
           "banana",
           "435.114.7586",
           "home: 672-442-6739")
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

test<-str_subset(strings, phone)


new_string <- test %>%    # rename dataset
  str_replace_all( "\\.", "-") %>% # replace periods with -
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") %>% # remove all the things we don't want
  str_trim() # trim the white space


#tidytext
#The function to get all of the text from all of Jane Austen's books is austen_books()

head(austen_books()) #explore
tail(austen_books())

#Clean it up and add a column for line and chapter
original_books <- austen_books() %>%                                            # get jane austen books
  group_by(book) %>%
  mutate(line = row_number(),                                                   # find every line
         chapter = cumsum(str_detect(text,regex("^chapter, [\\divxlc]",         # count the chapters (starts with the word chapter followed by a digit or roman numeral)
                                                ignore_case = TRUE)))) %>%      # ignore lower or uppercase
  ungroup()                                                                     # ungroup it so we have a dataframe again

# don't try to view the entire thing... its >73000 lines...
head(original_books)

# make it where there is only one word per row
# in tidytext each word is refered to as a token

tidy_books <- original_books %>%
  unnest_tokens(output = word, input = text) # add a column named word, with the input as the text column

head(tidy_books) # there are now >725,000 rows. Don't view the entire thing!

# now we have a lot of words and not all words are meaningful for our analysis 
#see an example of all the stopwords
head(get_stopwords())

# use a join to remove all stopwords
cleaned_books <- tidy_books %>%
  anti_join(get_stopwords()) # dataframe without the stopwords

head(cleaned_books)

# count the most common words across all her books
cleaned_books %>%
  count(word, sort = TRUE)       #count them

##Sentiment Analysis:  (how many positive and negative words) using get_sentiments()

sent_word_counts <- tidy_books %>%
  inner_join(get_sentiments()) %>% # only keep pos or negative words
  count(word, sentiment, sort = TRUE) # count them
head(sent_word_counts)[1:3,]          #shows you negative and positive words according to R

#lets ggplot it
sent_word_counts %>%
  filter(n > 150) %>% # take only if there are over 150 instances of it
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>% # add a column where if the word is negative make the count negative
  mutate(word = reorder(word, n)) %>% # sort it so it goes from largest to smallest
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col() +
  coord_flip() +
  labs(y = "Contribution to sentiment")


###Wordcloud
words<-cleaned_books %>%
  count(word) %>% # count all the words
  arrange(desc(n))%>% # sort the words
  slice(1:100) #take the top 100
wordcloud2(words, shape = 'triangle', size=0.3) # make a wordcloud out of the top 100 words




