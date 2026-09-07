# TikTok data analysis project (group 10)

## Project goal
This project analyzes TikTok video engagement metrics to evaluate creator performance and viewer reach trends using R and Quarto.


## Project Structure

```text
TikTok-project-2026-2027---group-10/
├── data/
│   ├── raw/                  # Downloaded raw dataset (ignored by Git, managed via script)
│   │   ├── .gitkeep          # Tracks directory structure on GitHub
│   │   └── video_view.csv    # Automatically fetched raw TikTok dataset
│   └── processed/            # Storage location for clean dataset outputs
│       └── .gitkeep
├── docs/                     # Project documentation placeholder
│   └── .gitkeep
├── src/                      # Source code (Quarto execution scripts)
│   ├── File_download.qmd     # Automated pipeline: setup, directory check & file fetch
│   └── summary.qmd           # Exploratory summary report and metrics calculation
├── .gitignore                # Restricts large/raw data files while tracking folder structure
├── AI.md                     # Comprehensive AI usage & transparency log
└── README.md                 # Project onboard, execution, and architectural guide
```

## Environment setup & dependencies
To run this project locally, ensure you have the following installed:
* **R** (v4.2.0 or higher)
* **Quarto CLI**
* **Positron** (or RStudio)

> **Note on Data Privacy:** Data files stored in `data/` are excluded from version control via `.gitignore` to keep the repository lightweight and prevent pushing large datasets.

## Required R Packages
Install the necessary package dependencies by executing this in your R Console:
```r
install.packages(c("tidyverse", "dplyr"))
```

## Reproducing the analysis:
All scripts are written with dynamic relative pathing (basename(getwd())). They can be executed directly from the project root or from inside the src/ directory without path errors.

* Clone this repository to your local workspace:
```PowerShell
 git clone [https://github.com/mohamadhallak98/TikTok-project-2026-2027---group-10.git](https://github.com/mohamadhallak98/TikTok-project-2026-2027---group-10.git)
```
* Navigate into the project root directory:
```bash
cd TikTok-project-2026-2027---group-10
```
* Execute the workflow scripts inside src/ in the following order:
    * Step 1 (data acquisition): Render or run src/File_download.qmd to fetch the raw TikTok dataset.
    ```bash
    quarto render src/File_download.qmd
    ```
    Input: GitHub raw URL endpoint.
    Output: Saves video_view.csv directly into data/raw/.
    Behavior: Checks if the file already exists locally to avoid redundant downloads.
    * Step 2 (data analysis & reporting): Execute src/summary.qmd or render via terminal: process data and generate the output summary report.
    ```bash
    quarto render src/summary.qmd
    ```
    Input: data/raw/video_view.csv.
    Output: Generates src/summary.html containing:
        Missing value diagnostics (colSums(is.na())).
        Aggregate summary metrics (total creators, avg impressions, watch rate, watch share).
        Video performance ranking and length distribution histograms.
* Commit and push with Git: In your Positron terminal, execute the commands you need for adding, committing and pushing.

## Pipeline architecture (setup-input-transformation-output)
Both pipeline scripts follow strict SITO principles:
    * Setup: Dynamic environment path detection (src/ vs. project root) and package initialization (tidyverse, dplyr).
    * Input: Safe data retrieval via HTTP (mode = "wb" for Windows compatibility) or importing from data/raw/.
    * Transformation: Data cleaning, conditional subsetting (watch_rate > 0.8), variable additions (watched_pct), and NA-safe statistical aggregation (na.rm = TRUE).
    * Output: Clean console/Quarto report generation and local raw file retention.

## Group members + contribution
* Mohamad Al Hallak: Code validation, issues management, cross-platform path debugging (Windows), and resolving git workflow conflicts.
* Danny Verkade: Resolving R package warnings/errors, analyzing alternative code implementations, and broad concept exploration.
* Iris de Bruijn: Command syntax lookup, script structure understanding, and error resolution.
* Jette Hulsen: Concept clarification, understanding script logic, and troubleshooting script issues.

## AI tools: 
AI tools were utilized for code validation, Windows-specific path debugging, and conceptual learning. Full model listings, workflows, and human review protocols are documented in ([AI.md](./AI.md)).