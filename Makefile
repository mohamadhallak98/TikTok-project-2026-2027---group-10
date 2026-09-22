# Makefile for TikTok Data Analysis Project (Cross-Platform)
.PHONY: all clean

# Default target: Generate the plot
all: gen/output/watch_event_analysis/average_watch_time_by_action.png

# Generate the plot by rendering the Quarto file
gen/output/watch_event_analysis/average_watch_time_by_action.png: src/TikTokdata_10/Analysis.qmd
	quarto render src/TikTokdata_10/Analysis.qmd --to html
	@echo "Plot generated: $@"

# Clean up generated files (cross-platform)
clean:
ifeq ($(OS),Windows_NT)
	
# Windows: Use PowerShell (works in Git Bash, CMD, and WSL)
	powershell -Command "Remove-Item -Recurse -Force 'gen\output\watch_event_analysis'" 2> nul || true
else
	
# Unix/macOS: Use rm -rf
	rm -rf gen/output/watch_event_analysis/ 2> /dev/null || true
endif
	@echo "Cleaned up generated files."