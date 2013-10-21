##Author: Justin Chu
##This script's purpose is to clean + consoldate and output all data from MovieLens data set for further analysis
##script assumes that ml-100k folder exist with unaltered files from http://grouplens.org/datasets/movielens/
##names of colmuns used in this script are dervived from README file in ml-100k directory

#initialize libraries
library(plyr)

##preparing dataTbl
dataTbl <- read.table(file="ml-100k/u.data")

#assign names to columns for ease of processing
colnames(dataTbl) <- c("user_id", "item_id", "rating", "timestamp")

#drop timestamp from table
dataTbl <- subset(dataTbl, select = -c(timestamp) )

#check import was okay and table is as expected
# str(dataTbl)
# head(dataTbl)
# tail(dataTbl)

## preparing userTbl
userTbl <- read.table(file="ml-100k/u.user", sep ="|")

#assign names to columns for ease of processing
colnames(userTbl) <- c("user_id", "age" , "gender","occupation", "zip_code")

#dropping zip code - decided not useful for me
userTbl <- subset(userTbl, select = -c(zip_code) )

#check import was okay and table is as expected
# str(userTbl)
# head(userTbl)
# tail(userTbl)

##preparing genreTbl - will be used later to fill in genre fields (rather than the numeric ID)
##"Childern's" quote character needs to be ignored
genreTbl <- read.table(file="ml-100k/u.genre", sep = "|", quote = "" )

#check import was okay and table is as expected
# str(genreTbl)
# head(genreTbl)
# tail(genreTbl)

##preparing itemTbl
##URLS will mess up parsing due to use of quote charaters
itemTbl <- read.table(file="ml-100k/u.item", sep ="|", quote = "")

#create vector used to assign names in for columns:
genreVect <- as.vector(genreTbl[["V1"]])
#change Childern's to childerns to prevent errors
genreVect[genreVect %in% "Children\'s"] <- "Childrens"

#assign names to columns for ease of processing
colnames(itemTbl) <- c(c("item_id", "movie_title", "release_date", "video_release_date", 
                       "IMDb_URL"), genreVect)

#drop video_release_date (seems to not be filled) and URL from table
itemTbl <- subset(itemTbl, select = -c(IMDb_URL, video_release_date) )

#fix dates field
itemTbl$release_date <- as.Date(itemTbl$release_date, "%d-%b-%Y")

#check import was okay and table is as expected
# str(itemTbl)
# head(itemTbl)
# tail(itemTbl)

##create unified table
#merge itemTbl
unifiedTbl <- merge(dataTbl, itemTbl)
unifiedTbl <- subset(unifiedTbl, select = -c(item_id) )

#merge userTbl and remove user_id
unifiedTbl <- merge(unifiedTbl, userTbl)

#turns out there are duplicate rows (rows with a unique user_id and movie title)
unifiedTbl <- unique(unifiedTbl)

##function to create a single genre field, applying "multiple" to movies with 
##multiple genres because I may want the genre fields as a single variable for
##ease of processing
##function assumes x will contain a single factor/row
##intended use with ddply
createGenreFieldSingle <- function(x){
  #temporarally remove variables to make looping easier,
  tempDat <- subset(x, select = -c(user_id, rating, movie_title, 
                                   release_date, age, gender, occupation))  
  count <- 0
  genre <- "unknown" #unknown genre is default
  
  #some movies are have multiple rating from same user!
  #check if there are muliple rows in x
  if(nrow(x) > 1){
    #set tempDat to only have one row
    tempDat <- head(tempDat, n = 1)
  }
  
  for (i in names(tempDat)){
    if(tempDat[i] == 1){
      count <- count + 1
      genre <- i
    }
  }
  if(count > 1){
    genre <- "multiple"
  }
  names(genre) <- "genre"
  return(genre)
}

#will remove elements where user had voted twice for the same movie (THIS IS REALLY SLOW)
genreDat <- ddply(unifiedTbl, ~user_id + movie_title, createGenreFieldSingle)

unifiedTblSingle <- merge(genreDat, unifiedTbl)

#keep only stuff I need
unifiedTblSingle <- subset(unifiedTblSingle, select = 
                             c(user_id, movie_title, rating, genre,
                               release_date, age, gender, occupation) )

#check table is as expected
# str(unifiedTbl)
# head(unifiedTbl)
# tail(unifiedTbl)

#output table as csv file
write.csv(unifiedTblSingle, "Results/unifiedMLData.csv", row.names = FALSE)

#create file with possible muliple files added

##function to create potentially multiple values or rows
##intended use with ddply
createGenreFieldMultiple <- function(x){
  #temporarally remove variables to make looping easier,
  tempDat <- subset(x, select = -c(user_id, rating, movie_title, 
                                   release_date, age, gender, occupation))  
  genreItem <- data.frame()
  
  #some movies are have multiple rating from same user!
  #check if there are muliple rows in x
  if(nrow(x) > 1){
    #set tempDat to only have one row
    tempDat <- head(tempDat, n = 1)
  }

  for (i in names(tempDat)){
    if(tempDat[i] == 1){
      genreItem<- rbind(genreItem,i)
    }
    genreItem<- rbind(genreItem, NA)
  }
  names(genreItem) <- "genre"
  return(genreItem)
}
#create multiple based on number of genres
unifiedTblMulti <- ddply(unifiedTbl, ~movie_title , createGenreFieldMultiple)

#remove all NA
unifiedTblMulti <- na.omit(unifiedTblMulti)

#clean and remerge
unifiedTblMulti <- merge(unifiedTblMulti, ddply(unifiedTbl, ~movie_title + user_id, 
                                                summarize, release_date))
unifiedTblMulti <- merge(unifiedTblMulti, unifiedTbl)

#some element re-added have no genre at all - removing from data
unifiedTblMulti <- unifiedTblMulti[unifiedTblMulti$genre != "1",]

unifiedTblMulti <- subset(unifiedTblMulti, 
                          select = c(user_id, movie_title, genre, rating,
                                     release_date, age, gender, occupation) )

#check table is as expected
# str(unifiedTblMulti)
# head(unifiedTblMulti)
# tail(unifiedTblMulti)

write.csv(unifiedTblMulti, "Results/unifiedMLDataMulti.csv", row.names = FALSE)

#finally print session info
sessionInfo()