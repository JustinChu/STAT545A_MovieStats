##Author: Justin Chu

all: makeMovieLensPlots.html Results/unifiedMLDataMulti.csv Results/unifiedMLData.csv

makeMovieLensPlots.html: Results/unifiedMLData.csv Results/unifiedMLDataMulti.csv
	Rscript -e "knitr::knit2html('makeMovieLensPlots.Rmd')";

Results/unifiedMLData.csv Results/unifiedMLDataMulti.csv: ml-100k/u.data ml-100k/u.item ml-100k/u.user ml-100k/u.genre ml-100k/u.occupation
	Rscript cleanMovieLensData.R;

clean:
	rm -rf  Results/*.csv *.png 0*.md *.html figure