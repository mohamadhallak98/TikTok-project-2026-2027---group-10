# R Executable Variable
R = Rscript

# Target definitions for Session Analysis
SESSION_TARGETS = gen/output/session_analysis/session_duration_distribution.png \
                  gen/output/session_analysis/top_users_videos.png \
                  gen/output/session_analysis/daily_session_trends.png \
                  gen/output/session_analysis/daily_watch_efficiency.png

# Target definitions for Watch Event Analysis
WATCH_TARGETS = gen/output/watch_event_analysis/average_watch_time_by_action.png

# Target definitions for Users Analysis
USER_TARGETS = gen/output/users_analysis/average_videos_watched_distribution.png

# Target definitions for Impressions Analysis
IMPRESSION_DIR = gen/output/impressions_analysis
IMPRESSION_DATA = data/raw/impressions.csv
IMPRESSION_TARGETS = $(IMPRESSION_DIR)/impressions_by_source.png \
                     $(IMPRESSION_DIR)/top_creators_by_score.png \
                     $(IMPRESSION_DIR)/top_recommended_creators.png

.PHONY: all clean

# Master target: Builds ALL FOUR analysis pipelines
all: $(WATCH_TARGETS) $(SESSION_TARGETS) $(USER_TARGETS) $(IMPRESSION_TARGETS)

# --- Rules for Watch Event Analysis ---
gen/output/watch_event_analysis/average_watch_time_by_action.png: src/TikTokdata_10/Analysis.qmd
	quarto render src/TikTokdata_10/Analysis.qmd --to html
	@echo "Plot generated: $@"

# --- Rules for Session Analysis ---
data/raw/sessions.csv: src/session_analysis/01_download_data.R
	$(R) src/session_analysis/01_download_data.R

$(SESSION_TARGETS): src/session_analysis/02_analyze_sessions.R data/raw/sessions.csv
	$(R) src/session_analysis/02_analyze_sessions.R

# --- Rules for Users Analysis ---
gen/output/users_analysis/average_videos_watched_distribution.png: src/users_analysis/data_analysis.qmd
	quarto render src/users_analysis/data_analysis.qmd

# --- Rules for Impressions Analysis ---
$(IMPRESSION_DATA): src/impressions_analysis/download_data.R
	$(R) src/impressions_analysis/download_data.R

$(IMPRESSION_TARGETS): $(IMPRESSION_DATA) src/impressions_analysis/data_analysis.R
	$(R) src/impressions_analysis/data_analysis.R

# --- Cross-Platform Clean Rule ---
clean:
ifeq ($(OS),Windows_NT)
	-powershell -Command "Remove-Item -Recurse -Force 'gen\output\watch_event_analysis', 'gen\output\session_analysis', 'gen\output\users_analysis', 'gen\output\impressions_analysis', 'Rplots.pdf' -ErrorAction SilentlyContinue"
else
	-rm -rf gen/output/watch_event_analysis/ gen/output/session_analysis/ gen/output/users_analysis/ gen/output/impressions_analysis/ Rplots.pdf 2> /dev/null || true
endif
	@echo "Cleaned up all generated files and temporary Rplots.pdf."