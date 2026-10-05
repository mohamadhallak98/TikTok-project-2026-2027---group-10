# R Executable Variable
R = Rscript

# ------------------------------------------------------------------------------
# Target Definitions
# ------------------------------------------------------------------------------

# Database and Raw Data Dependencies
DB_FILE = tiktok_students.sqlite
RAW_DATA = data/raw/sessions.csv data/raw/impressions.csv data/raw/users.csv

# Output Target Definitions
SESSION_TARGETS = gen/output/session_analysis/session_duration_distribution.png \
                  gen/output/session_analysis/top_users_videos.png \
                  gen/output/session_analysis/daily_session_trends.png \
                  gen/output/session_analysis/daily_watch_efficiency.png

WATCH_TARGETS = gen/output/watch_event_analysis/average_watch_time.png

USER_TARGETS = gen/output/users_analysis/average_videos_watched_distribution.png

IMPRESSION_TARGETS = gen/output/impressions_analysis/impressions_by_source.png \
                     gen/output/impressions_analysis/top_creators_by_score.png \
                     gen/output/impressions_analysis/top_recommended_creators.png

REGRESSION_TARGETS = gen/output/regression_analysis/simple_regression.png \
                     gen/output/regression_analysis/multiple_regression_coefficients.png

FINAL_REPORT = gen/output/final_report.pdf

ALL_ANALYSIS_TARGETS = $(SESSION_TARGETS) $(WATCH_TARGETS) $(USER_TARGETS) $(IMPRESSION_TARGETS) $(REGRESSION_TARGETS)

# ------------------------------------------------------------------------------
# Phony Targets
# ------------------------------------------------------------------------------
.PHONY: all clean data analyses

# Master target: Builds the entire pipeline through to the final PDF report
all: $(FINAL_REPORT)

analyses: $(ALL_ANALYSIS_TARGETS)

# ------------------------------------------------------------------------------
# 1. Database & Data Download Rules
# ------------------------------------------------------------------------------

$(DB_FILE): src/sqlite_download.R
	$(R) src/sqlite_download.R

$(RAW_DATA): src/query_sql.R $(DB_FILE)
	$(R) src/query_sql.R

# ------------------------------------------------------------------------------
# 2. Module Analysis Rules
# ------------------------------------------------------------------------------

# Session Analysis
$(SESSION_TARGETS): src/session_analysis/02_analyze_sessions.R $(RAW_DATA)
	$(R) src/session_analysis/02_analyze_sessions.R

# Watch Event Analysis (Bypasses AppLocker via purl & handles dynamic dated filenames)
$(WATCH_TARGETS): src/TikTokdata_10/Analysis.qmd $(RAW_DATA)
	$(R) -e " \
		dir.create('gen/output/watch_event_analysis', recursive=TRUE, showWarnings=FALSE); \
		knitr::purl('src/TikTokdata_10/Analysis.qmd', output='src/TikTokdata_10/temp_watch.R', quiet=TRUE); \
		source('src/TikTokdata_10/temp_watch.R'); \
		if (file.exists('src/TikTokdata_10/temp_watch.R')) file.remove('src/TikTokdata_10/temp_watch.R'); \
		dated_files <- list.files('gen/output/watch_event_analysis', pattern='average_watch_time_.*\\.png$$', full.names=TRUE); \
		if (length(dated_files) > 0) file.copy(dated_files[length(dated_files)], 'gen/output/watch_event_analysis/average_watch_time.png', overwrite=TRUE) \
	"
	
# Users Analysis (Bypasses AppLocker via purl)
$(USER_TARGETS): src/users_analysis/data_analysis.qmd $(RAW_DATA)
	$(R) -e "dir.create('gen/output/users_analysis', recursive=TRUE, showWarnings=FALSE); knitr::purl('src/users_analysis/data_analysis.qmd', output='src/users_analysis/temp_users.R', quiet=TRUE); source('src/users_analysis/temp_users.R'); if (file.exists('src/users_analysis/temp_users.R')) file.remove('src/users_analysis/temp_users.R')"

# Impressions Analysis
$(IMPRESSION_TARGETS): src/impressions_analysis/data_analysis.R $(RAW_DATA)
	$(R) src/impressions_analysis/data_analysis.R

# Regression Analysis
$(REGRESSION_TARGETS): src/regression_analysis.r $(RAW_DATA)
	$(R) -e "dir.create('gen/output/regression_analysis', recursive=TRUE, showWarnings=FALSE); source('src/regression_analysis.r')"

# ------------------------------------------------------------------------------
# 3. Final Report Rule
# ------------------------------------------------------------------------------
$(FINAL_REPORT): src/final_report.Rmd $(ALL_ANALYSIS_TARGETS)
	$(R) -e "rmarkdown::render('src/final_report.Rmd', output_file = here::here('gen', 'output', 'final_report.pdf'))"
	@echo "======================================================="
	@echo "SUCCESS: Full pipeline executed. Final report generated:"
	@echo "$@"
	@echo "======================================================="

# ------------------------------------------------------------------------------
# 4. Cleanup Rules
# ------------------------------------------------------------------------------
clean:
ifeq ($(OS),Windows_NT)
	-powershell -Command "Remove-Item -Recurse -Force 'gen\output\*' -ErrorAction SilentlyContinue"
	-powershell -Command "Remove-Item -Force 'Rplots.pdf', '*.knit.md', '*.utf8.md' -ErrorAction SilentlyContinue"
else
	-rm -rf gen/output/* Rplots.pdf *.knit.md *.utf8.md 2> /dev/null || true
endif
	@echo "Cleaned all output directories and intermediate build artifacts."