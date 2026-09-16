# Tiktok project - Inspect and analyze Tiktok users dataset

## Goal
The goal of this project is to inspect and visualize the tiktok users dataset. The focus is on user engagement by looking at the average number of videos watched per user.

## Data
This analysis uses the `users.csv` dataset. This dataset contains user IDs, preference scores for content categories and variables that measure how the users behave on the platform. The main variable that was used for this analysis is 'base_videos_watched_mean' which is the average number of videos watched per user.

## Requirements
- R 
- Quarto
- Make
- R Packages: ggplot2, here

## Data inspection and cleaning
The data was inspected using:

- head()
- names()
- str()
- summary()

This showed 200 rows contained missing values and these were deleted using na.omit().

## Reproducing the analysis
* Clone this repository to your local workspace:
```PowerShell
 git clone https://github.com/mohamadhallak98/TikTok-project-2026-2027---group-10.git
```
* Navigate into the project root directory:
```bash
cd TikTok-project-2026-2027---group-10
```
* Run the analysis using the makefile:
```
make -C src/wd_Iris
```
- 

## Expected output
After running the analysis, the following file is generated:

src/wd_Iris/figures/average_videos_watched_distribution.png

This file contains a histogram showing the distribution of average amount of videos watched per user. 