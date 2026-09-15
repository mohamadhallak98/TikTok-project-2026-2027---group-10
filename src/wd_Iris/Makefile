all: figures/average_videos_watched_distribution.png

figures/average_videos_watched_distribution.png: data_analysis.qmd
	quarto render data_analysis.qmd

clean:
	if exist figures\average_videos_watched_distribution.png del /Q figures\average_videos_watched_distribution.png

