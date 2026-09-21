all: gen/output/users_analysis/average_videos_watched_distribution.png


# Generate the plot 
gen/output/users_analysis/average_videos_watched_distribution.png: src/users_analysis/data_analysis.qmd
	quarto render src/users_analysis/data_analysis.qmd


# Clean 
clean:
ifeq ($(OS),Windows_NT)
	@if exist "gen\output\users_analysis" rmdir /S /Q "gen\output\users_analysis"
else
	rm -rf gen/output/users_analysis
endif
	@echo "Cleaned up generated files."