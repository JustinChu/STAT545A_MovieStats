##Author: Justin Chu

all: makeMovieLensPlots.html makeMovieLensPlots.pdf Results/unifiedMLDataMulti.csv Results/unifiedMLData.csv

makeMovieLensPlots.pdf: makeMovieLensPlots.md
	pandoc -s makeMovieLensPlots.md -o makeMovieLensPlots.pdf;

makeMovieLensPlots.html makeMovieLensPlots.md: Results/unifiedMLData.csv Results/unifiedMLDataMulti.csv
	Rscript -e "knitr::knit2html('makeMovieLensPlots.Rmd')";

Results/unifiedMLData.csv Results/unifiedMLDataMulti.csv: ml-100k/u.data ml-100k/u.item ml-100k/u.user ml-100k/u.genre ml-100k/u.occupation
	Rscript cleanMovieLensData.R;

clean:
	rm -rf  Results/*.csv *.pdf 0*.md *.html figure
