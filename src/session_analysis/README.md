# TikTok sessions analysis workflow

This directory contains the pipeline for downloading, processing, and visualizing the TikTok app user sessions log data (`sessions.csv`).

## Requirements
- R 
- Make
- R Packages: here, tidyverse, scales

## Pipeline architecture
- `01_download_data.R`: Downloads raw session log data directly to `data/raw/` using robust path resolution.
- `02_analyze_sessions.R`: Performs data cleaning and builds three distinct `ggplot2` visualizations saved to `gen/output/session_analysis/`.
- `Makefile`: Automates execution of the entire pipeline.

## Instructions to run
To execute the full data pipeline from the project root, simply run:

```bash
make
```
To clear generated outputs and test a fresh build, run:

```bash
make clean
```
## Expected output
After running the analysis, the following files are generated:

- `session_duration_distribution.png`: histogram showing the distribution of user session durations on a log10 scale.
- `top_users_videos.png`: bar chart showing the top 10 users based on the total number of videos viewed.
- `daily_session_trends.png`: line chart showing the number of sessions per day.
- `daily_watch_efficiency.png`: line chart showing the average daily watch efficiency, calculated as the percentage of session duration spent watching videos.