# Define the Rscript executable variable
R = Rscript

# Target definitions
TARGETS = gen/output/session_analysis/session_duration_distribution.png \
          gen/output/session_analysis/top_users_videos.png \
          gen/output/session_analysis/daily_session_trends.png \
          gen/output/session_analysis/daily_watch_efficiency.png

# Master target
all: $(TARGETS)

# Rule 1: Download dataset
data/raw/sessions.csv: src/session_analysis/01_download_data.R
	$(R) src/session_analysis/01_download_data.R

# Rule 2: Execute analysis & produce figures
$(TARGETS): src/session_analysis/02_analyze_sessions.R data/raw/sessions.csv
	$(R) src/session_analysis/02_analyze_sessions.R

# Clean rule (cross-platform OS check)
clean:
ifeq ($(OS),Windows_NT)
	@if exist gen\output\session_analysis\*.png del /q gen\output\session_analysis\*.png
else
	rm -rf gen/output/session_analysis/*.png
endif