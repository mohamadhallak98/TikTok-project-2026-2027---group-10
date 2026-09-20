# Makefile for TikTok Data Analysis Project (Cross-Platform)
.PHONY: all clean

# Default target: Generate the plot
all: data/processed/average_watch_time_by_action.png

# Generate the plot by rendering the Quarto file
data/processed/average_watch_time_by_action.png: src/TikTokdata_10/Analysis.qmd
	quarto render src/TikTokdata_10/Analysis.qmd --to html
	@echo "Plot generated: $@"

# Clean up generated files (Windows + Unix)
clean:
	@if exist data\processed\average_watch_time_by_action.png ( del /Q data\processed\average_watch_time_by_action.png ) else ( rm -f data/processed/average_watch_time_by_action.png )
	@echo "Cleaned up generated files."
