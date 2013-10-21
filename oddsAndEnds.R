#script contains odd and ends from other scrips

mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, occupation != "homemaker"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, genre != "Childrens"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, genre != "War"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, occupation != "none"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, genre != "Animation"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, occupation != "doctor"))
mlDat_genre_occup <- droplevels(subset(mlDat_genre_occup, occupation != "salesman"))

#get data ready for heatmap
goHeat <- ggplot(mlDat_genre_occup, aes(x = genre, y = occupation, fill = mean_rating))
#rotate labels
goHeat <- goHeat + geom_tile() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#add colours
goHeat <- goHeat + scale_fill_gradientn(colours = heatMapPalette(100))
#change background
goHeat <- goHeat + theme(panel.background = element_rect(fill='white'),panel.grid.major = theme_blank())
print(goHeat)

#temporary occupation table
mlDat_occupation <- ddply(mlDat_user, ~occupation, summarize, number_of_users = length(user_id), 
                          mean_age = mean(age), num_males = length(gender[gender == "M"]), 
                          num_female = length(gender[gender == "F"]))

mlDat_gender <- ddply(mlDat_multi, movie_title + genre, summarize, mean_rating = mean(rating), movie_counts = length(movie_title))
genrGendPlot <- ggplot(mlDat_gender, aes(x=reorder(genre,genre,
                                                   function(x)-length(x)), fill = gender)) + geom_bar()
#fix axis
genrGendPlot <- genrGendPlot + theme(axis.text.x = element_text(angle = 90, hjust = 1))
genrGendPlot <- genrGendPlot + ylab("number of rating per genre") + xlab("genre")
#flip axis to make professions easier to read
genrGendPlot <- genrGendPlot + coord_flip()

genrGendProp_dat <- ddply(mlDat_gender, ~genre, summarize, perc_male = (length(gender[gender == "M"])/length(gender)), counts = -length(user_id))

#sorts by number of users
genrGendPropPlot <- ggplot(genrGendProp_dat, aes(x=reorder(genre, counts), perc_male)) + geom_bar(stat="identity")
#fix axis
genrGendPropPlot <- genrGendPropPlot + theme(axis.text.x = element_text(angle = 90, hjust = 1))
genrGendPropPlot <- genrGendPropPlot + ylab("percent male") + xlab("genre")
#flip axis to make professions easier to read
genrGendPropPlot <- genrGendPropPlot + coord_flip()

mlDat_gender_pure <- ddply(mlDat, ~user_id + movie_title+ gender + genre, summarize, mean_rating = mean(rating), movie_counts = length(movie_title))
genrGendPlot_pure <- ggplot(mlDat_gender_pure, aes(x=reorder(genre,genre,
                                                             function(x)-length(x)), fill = gender)) + geom_bar()
#fix axis
genrGendPlot_pure <- genrGendPlot_pure + theme(axis.text.x = element_text(angle = 90, hjust = 1))
genrGendPlot_pure <- genrGendPlot_pure + ylab("number of movies") + xlab("genre")
#flip axis to make professions easier to read
genrGendPlot_pure <- genrGendPlot_pure + coord_flip()

genrGendProp_dat_pure <- ddply(mlDat_gender_pure, ~genre, summarize, perc_male = (length(gender[gender == "M"])/length(gender)), counts = -length(user_id))

#sorts by number of users
genrGendPropPlot_pure <- ggplot(genrGendProp_dat_pure, aes(x=reorder(genre, counts), perc_male)) + geom_bar(stat="identity")
#fix axis
genrGendPropPlot_pure <- genrGendPropPlot_pure + theme(axis.text.x = element_text(angle = 90, hjust = 1))
genrGendPropPlot_pure <- genrGendPropPlot_pure + ylab("percent male") + xlab("genre")
#flip axis to make professions easier to read
genrGendPropPlot_pure <- genrGendPropPlot_pure + coord_flip()

vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
print(genrGendPlot, vp = vplayout(1, 1))
print(genrGendPropPlot, vp = vplayout(1, 2))
print(genrGendPlot_pure, vp = vplayout(2, 1))
print(genrGendPropPlot_pure, vp = vplayout(2, 2))