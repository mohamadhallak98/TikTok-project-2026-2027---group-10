# Define R executable (use "Rscript" for Positron/RStudio)
R = Rscript

# Define output files
DATA_OUTPUT = data/raw/impressions.csv
PLOT_OUTPUT = output/impressions_by_source.png \
              output/top_creators_by_impressions.png

# Default target (runs all steps)
all: $(PLOT_OUTPUT)

# Download data if it doesn't exist
$(DATA_OUTPUT):
	$(R) src/impressions_analysis/download_data.R

# Generate plots if they don't exist
$(PLOT_OUTPUT): $(DATA_OUTPUT) src/impressions_analysis/data_analysis.R
	$(R) src/impressions_analysis/data_analysis.R

# Clean up (optional)
clean:
	rm -f $(DATA_OUTPUT) $(PLOT_OUTPUT)
