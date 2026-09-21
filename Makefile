all: src/wd_Iris/figures/average_videos_watched_distribution.png


# Generate the plot 
src/wd_Iris/figures/average_videos_watched_distribution.png: src/wd_Iris/data_analysis.qmd
	quarto render src/wd_Iris/data_analysis.qmd


# Clean yo generated files
clean:
ifeq ($(OS),Windows_NT)
	@if exist src\wd_Iris\figures\average_videos_watched_distribution.png del /Q src\wd_Iris\figures\average_videos_watched_distribution.png
else
	rm -f src/wd_Iris/figures/average_videos_watched_distribution.png
endif