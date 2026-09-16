all: data_processed/average_watch_time_by_action.png

data_processed/average_watch_time_by_action.png: Analysis.qmd
	quarto render Analysis.qmd

clean:
	if exist data_processed\average_watch_time_by_action.png del /Q data_processed\average_watch_time_by_action.png