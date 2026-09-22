# R Executable Variable
R = Rscript
 
# Target definitions for Session Analysis
SESSION_TARGETS = gen/output/session_analysis/session_duration_distribution.png \
                  gen/output/session_analysis/top_users_videos.png \
                  gen/output/session_analysis/daily_session_trends.png \
                  gen/output/session_analysis/daily_watch_efficiency.png
 
# Target definitions for Watch Event Analysis
WATCH_TARGETS = gen/output/watch_event_analysis/average_watch_time_by_action.png
 
.PHONY: all clean
 
# Master target: Builds BOTH analysis pipelines
all: $(WATCH_TARGETS) $(SESSION_TARGETS)
 
# --- Rules for Watch Event Analysis ---
gen/output/watch_event_analysis/average_watch_time_by_action.png: src/TikTokdata_10/Analysis.qmd
	quarto render src/TikTokdata_10/Analysis.qmd --to html
	@echo "Plot generated: $@"
 
# --- Rules for Session Analysis ---
data/raw/sessions.csv: src/session_analysis/01_download_data.R
	$(R) src/session_analysis/01_download_data.R
 
$(SESSION_TARGETS): src/session_analysis/02_analyze_sessions.R data/raw/sessions.csv
	$(R) src/session_analysis/02_analyze_sessions.R
 
# --- Cross-Platform Clean Rule ---
clean:
ifeq ($(OS),Windows_NT)
	powershell -Command "Remove-Item -Recurse -Force 'gen\output\watch_event_analysis', 'gen\output\session_analysis'" 2> nul || true
else
	rm -rf gen/output/watch_event_analysis/ gen/output/session_analysis/ 2> /dev/null || true
endif
	@echo "Cleaned up all generated files."

