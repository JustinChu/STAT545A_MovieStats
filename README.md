STAT545A_MovieStats
===================

Exploratory analysis of Movie preference data set from http://grouplens.org/datasets/movielens/

Raw data is in the /ml-100k folder - see readme inside folder for details

Instructions: To generate html and plots run "make" in the main directory. Figures will be outputted to main directory upon running code

Scripts:

* cleanMovieLensData.R - Cleans and unifies dataset into something that I can easily manipulate and explore. Outputs unifiedMLData.csv and unifiedMLDataMulti.csv in Results folder.
* makeMovieLensPlots.Rmd - Creates plots of various aspects of movie lens data with analysis and comments explaining plots. Uses output from cleanMovieLensData.R (Results/unifiedMLData.csv).