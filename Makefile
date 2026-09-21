all: gen/output/users_analysis/average_videos_watched_distribution_*png


# Generate the plot 
gen/output/users_analysis/average_videos_watched_distribution_*png: src/wd_Iris/data_analysis.qmd
	quarto render src/wd_Iris/data_analysis.qmd


# Clean 
clean:
ifeq ($(OS),Windows_NT)
	@if exist gen\output\users_analysis\average_videos_watched_distribution_*.png del /Q gen\output\users_analysis\average_videos_watched_distribution_*.png
else
	rm -f gen/output/users_analysis/average_videos_watched_distribution_*.png
endif

