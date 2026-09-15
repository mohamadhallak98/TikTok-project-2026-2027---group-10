all: data_processed/average_watch_time_by_action.png

data_processed/average_watch_time_by_action.png: Analysis.qmd
quarto render Analysis.qmd

clean:
rm -f data_processed/average_watch_time_by_action.png