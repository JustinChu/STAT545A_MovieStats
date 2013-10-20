STAT545A_MovieStats
===================

Exploratory analysis of Movie preference data set from http://grouplens.org/datasets/movielens/

Raw data is in the /ml-100k folder - see readme inside folder for details

Scripts:
cleanMovieLensData.R - Cleans and unifies dataset into something that I can easily manipulate and explore. Outputs unifiedMLData.csv in Results folder.
makeMovieLensPlots.R - Creates plots of various aspects of movie lens data. Uses output from cleanMovieLensData.R (Results/unifiedMLData.csv) .
makePlotsGuidedTour.Rmd - Same code as makeMovieLensPlots.R but with analysis and comments explaining plots.