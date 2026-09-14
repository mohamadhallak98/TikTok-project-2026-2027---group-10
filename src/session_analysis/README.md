# TikTok sessions analysis workflow

This directory contains the pipeline for downloading, processing, and visualizing the TikTok app user sessions log data (`sessions.csv`).

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