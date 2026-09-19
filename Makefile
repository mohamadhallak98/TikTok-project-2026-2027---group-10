# Define R executable
R = Rscript

# Define output path and target files
OUTPUT_DIR = gen/output/impressions_analysis
DATA_OUTPUT = data/raw/impressions.csv
PLOT_OUTPUT = $(OUTPUT_DIR)/impressions_by_source.png \
              $(OUTPUT_DIR)/top_creators_by_score.png \
              $(OUTPUT_DIR)/top_recommended_creators.png

# Default target (runs all steps)
all: $(PLOT_OUTPUT)

# Download data if it doesn't exist
$(DATA_OUTPUT): src/impressions_analysis/download_data.R
	$(R) src/impressions_analysis/download_data.R

# Generate plots if raw data or analysis script changes
$(PLOT_OUTPUT): $(DATA_OUTPUT) src/impressions_analysis/data_analysis.R
	$(R) src/impressions_analysis/data_analysis.R

# Clean rule (cross-platform OS check)
clean:
ifeq ($(OS),Windows_NT)
	@if exist gen\output\impressions_analysis\*.png del /q gen\output\impressions_analysis\*.png
else
	rm -rf gen/output/impressions_analysis/*.png
endif