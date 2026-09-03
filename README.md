# TikTok data analysis project (group 10)

## Project goal
This project analyzes TikTok video engagement metrics to evaluate creator performance and viewer reach trends using R and Quarto.

## Project Structure
```text
TikTok-project-2026-2027---group-10/
├── data/
│   ├── raw/          # Raw, unmodified data downloads
│   └── processed/    # Cleaned and generated data outputs
├── docs/             # Project documentation and guides
├── src/              # All Quarto scripts (File_download.qmd, summary.qmd)
└── README.md         # Project overview and execution guide

## Environment setup & dependencies
To run this project locally, ensure you have the following installed:
* **R** (v4.2.0 or higher)
* **Quarto CLI**
* **Positron** (or RStudio)

## Required R Packages
Install the necessary package dependencies by executing this in your R Console:
```r
install.packages(c("tidyverse", "dplyr"))
```

## Reproducing the analysis:
* Clone this repository to your local workspace:
```bash
 git clone [github.com/mohammadhallak98](https://github.com/mohamadhallak98/TikTok-project-2026-2027---group-10)
```
* Navigate into the project root directory:
```bash
cd TikTok-project-2026-2027---group-10
```
* Execute the workflow scripts inside src/ in the following order:
    * Step 1 (data acquisition): Render or run src/file_download.qmd to fetch the raw TikTok dataset.
    * Step 2 (data analysis & reporting): Render src/summary.qmd to process data and generate the output summary report.
    ```bash
    quarto render src/summary.qmd
    ```
* Expected output: src/summary.html: The generated HTML report containing processed tables and visual metrics.
* Commit and push with Git: In your Positron terminal, execute the commands you need for adding, committing and pushing.

## Group members + contribution
* Mohamad Al Hallak: Initial repository setup, issue management, and project README documentation.
* Danny Verkade: Script development for automated data downloading (src/file_download.qmd).
* Iris de Bruijn: Code review, testing environment setups, and documentation.
* Jette Hulsen: Data transformation and Quarto summary report generation (src/summary.qmd).

