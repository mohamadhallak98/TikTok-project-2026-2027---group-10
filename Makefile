# Makefile for TikTok Data Analysis Project (Cross-Platform)
.PHONY: all clean

# Default target: Generate the plot
all: data/processed/average_watch_time_by_action.png

# Generate the plot by rendering the Quarto file
data/processed/average_watch_time_by_action.png: src/TikTokdata_10/Analysis.qmd
	quarto render src/TikTokdata_10/Analysis.qmd --to html
	@echo "Plot generated: $@"

# Clean up generated files (should work on both MacBook, Windows, and more)
clean:
	@rm -f data/processed/average_watch_time_*.png 2> /dev/null || \
	 del /Q data\processed\average_watch_time_*.png 2> nul || \
	 true
	@echo "Cleaned up generated files."
