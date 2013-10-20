##Author: Justin Chu
##This script's purpose is to clean + consoldate and output all data from MovieLens data set for further analysis
##script assumes that ml-100k folder exist with unaltered files from http://grouplens.org/datasets/movielens/
##names of colmuns used in this script are dervived from README file in ml-100k directory

##preparing dataTbl
dataTbl <- read.table(file="ml-100k/u.data")

#assign names to columns for ease of processing
colnames(dataTbl) <- c("user_id", "item_id", "rating", "timestamp")

#drop timestamp from table
dataTbl <- subset(dataTbl, select = -c(timestamp) )

#check import was okay and table is as expected
str(dataTbl)
head(dataTbl)
tail(dataTbl)

## preparing userTbl
userTbl <- read.table(file="ml-100k/u.user", sep ="|")

#assign names to columns for ease of processing
colnames(userTbl) <- c("user_id", "age" , "gender","occupation", "zip_code")

#dropping zip code - decided not useful for me
userTbl <- subset(userTbl, select = -c(zip_code) )

#check import was okay and table is as expected
str(userTbl)
head(userTbl)
tail(userTbl)

##preparing genreTbl - will be used later to fill in genre fields (rather than the numeric ID)
##"childern's" quote character needs to be ignored
genreTbl <- read.table(file="ml-100k/u.genre", sep = "|", quote = "" )

#check import was okay and table is as expected
str(genreTbl)
head(genreTbl)
tail(genreTbl)

##preparing itemTbl
##URLS will mess up parsing due to use of quote charaters
itemTbl <- read.table(file="ml-100k/u.item", sep ="|", quote = "")

#create vector used to assign names in for columns:
genreVect <- as.vector(genreTbl[["V1"]])

#assign names to columns for ease of processing
colnames(itemTbl) <- c(c("item_id", "movie_title", "release_date", "video_release_date", 
                       "IMDb_URL"), genreVect)

#drop video_release_date (seems to not be filled) and URL from table
itemTbl <- subset(itemTbl, select = -c(IMDb_URL, video_release_date) )

#fix dates field
itemTbl$release_date <- as.Date(itemTbl$release_date, "%d-%b-%Y")

#check import was okay and table is as expected
str(itemTbl)
head(itemTbl)
tail(itemTbl)

##create unified table
#merge itemTbl and remove item_id
unifiedTbl <- merge(dataTbl, itemTbl)
unifiedTbl <- subset(unifiedTbl, select = -c(item_id) )

#merge userTbl and remove user_id
unifiedTbl <- merge(unifiedTbl, userTbl)
unifiedTbl <- subset(unifiedTbl, select = -c(user_id) )

#check table is as expected
str(unifiedTbl)
head(unifiedTbl)
tail(unifiedTbl)

#output table as csv file
write.csv(unifiedTbl, "Results/unifiedMLData.csv")

#finally print session info
sessionInfo()