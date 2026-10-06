# TikTok data analysis project (group 10)

## Project goal
This project analyzes and visualizes TikTok video engagement metrics to evaluate creator performance and viewer reach trends using R and Quarto.


## Project Structure

```text
TikTok-project-2026-2027---group-10/
├── data/
│   ├── raw/                  # Downloaded raw dataset (ignored by Git, managed via script)
│   │   ├── .gitkeep          # Tracks directory structure on GitHub
│   └── processed/            # Storage location for clean dataset outputs
│       └── .gitkeep
├── docs/                     # Project documentation placeholder
│   └── .gitkeep
├── gen                       # Generated files
│   └── output
│   │   ├── impressions_analysis
│   │   ├── watch_event_analysis
│   │   ├── session_analysis
│   │   ├── users_analysis
│   │   ├── final_report.pdf
├── src/                      # Source code (Quarto execution scripts)
│   ├── TikTokdata_10
│   │   ├── Analysis_files
│   │   ├── Analysis.qmd
│   │   ├── README.md
│   └── impressions_analysis
│   │   ├── README.md
│   │   ├── data_analysis.R
│   │   ├── download_data.R
│   └── sessions_analysis
│   │   ├── 01_download_data.R
│   │   ├── 02_analyze_sessions.R
│   │   ├──README.md
│   └── users_analysis
│   │   ├── data_analysis_files/libs
│   │   ├── README.md
│   │   ├── data_analysis.qmd
│   └── final_report.Rmd
│   └── query_sql.R
│   └── regression_analysis.r
│   └── sqlite_download.R
├── .gitignore                # Restricts large/raw data files while tracking folder structure
├── AI.md                     # Comprehensive AI usage & transparency log
├── Makefile                  # Automation
├── README.md                 # Project onboard, execution, and architectural guide
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
install.packages(c("here", "dplyr", "tidyr", "ggplot2", "knitr", "readr"))
```

## Reproducing the analysis:
All scripts are written with dynamic relative pathing (basename(getwd())). They can be executed directly from the project root or from inside the src/ directory without path errors.

* Clone this repository to your local workspace:
```PowerShell
 git clone https://github.com/mohamadhallak98/TikTok-project-2026-2027---group-10.git
```
* Navigate into the project root directory:
```bash
cd TikTok-project-2026-2027---group-10
```
* Execute the workflow scripts inside `src/` in the following order:

  - Step 1 (data acquisition): Run `src/sqlite_download.R` if the SQLite database is not yet available in `data/raw/`.

    ```r
    source("src/sqlite_download.R")
    ```
    This downloads the raw SQLite database to:
    
    ```text
    data/raw/tiktok_students.sqlite
    ```

  - Step 2 (database inspection): Run `src/query_sql.R` to inspect the available tables and preview the database contents.

    ```r
    source("src/query_sql.R")
    ```

    This script connects to the SQLite database, lists the available tables/views, prints column names, and shows the first rows. It does not create CSV files.

  - Step 3 (data analysis): Run the individual analysis scripts to generate the required plots.

    ```r
    source("src/impressions_analysis/data_analysis.R")
    source("src/sessions_analysis/02_analyze_sessions.R")
    source("src/regression_analysis.r")
    ```

    Depending on the local file structure, also run the users and watch event analysis scripts if needed.

    The analysis scripts use input files from:

    ```text
    data/raw/
    ```

    Main expected input files include:

    ```text
    users.csv
    sessions.csv
    impressions.csv
    ```

    The generated figures are saved in:

    ```text
    gen/output/
    ```

  - Step 4 (final report): Render the integrated final report.

    ```r
    rmarkdown::render("src/final_report.Rmd")
    ```

    This generates the final PDF report, including:
    - data inspection of users, sessions, and impressions;
    - feed impression analysis;
    - session duration analysis;
    - watch event analysis;
    - user behaviour distribution;
    - simple and multiple linear regression analysis;
    - conclusions and methodological limitations.

    Output:

    ```text
    gen/output/final_report.pdf
    ```

    If rendering from the terminal causes issues because of Windows security or PowerShell restrictions, run the `rmarkdown::render()` command directly inside the R Console in RStudio or Positron.

* Commit and push with Git: In your Positron terminal, execute the commands needed for adding, committing, and pushing your changes.

#
# Pipeline architecture (setup-input-transformation-output)

The project follows the SITO principle across the download, inspection, analysis, and reporting scripts.
* **Setup:**  
  The scripts load the required R packages such as `here`, `dplyr`, `tidyr`, `ggplot2`, `readr`, `DBI`, `RSQLite`, `knitr`, and `rmarkdown`. The `here` package is used to make file paths work consistently from the project root.
* **Input:**  
  The raw SQLite database can be downloaded with `src/sqlite_download.R` and stored in `data/raw/tiktok_students.sqlite`. The final report mainly reads prepared CSV files from `data/raw/`, including `users.csv`, `sessions.csv`, and `impressions.csv`.
* **Transformation:**  
  The analysis scripts inspect the data structure, summarize feed impressions, analyze session duration distributions, compare watch time across user actions, evaluate user-level video consumption, and prepare variables for regression analysis. Missing values are handled with `drop_na()` where needed before modeling.
* **Output:**  
  The separate analysis scripts generate plots in `gen/output/`, including impression source plots, session duration distributions, average watch time plots, user behavior distributions, and regression coefficient visualizations. The final integrated report is rendered from `src/final_report.Rmd` and saved as a PDF report.

## Group members + contribution
The issues were assigned to the different team members on GitHub.
* Mohamad Al Hallak: Code validation, issues management, cross-platform path debugging (Windows), plotting data, making of final document, checking groupmembers, making of make file and resolving git workflow conflicts.
* Danny Verkade: Resolving R package warnings/errors, analyzing alternative code implementations,  plotting data, making of final document, checking groupmembers, making of make file and broad concept exploration.
* Iris de Bruijn: Command syntax lookup, script structure understanding, cleaning data, checking of groupmembers work, plotting data, applying of lineair regression, making of final document and error resolution.
* Jette Hulsen: Concept clarification, understanding script logic, cleaning data, checking of groupmembers work, plotting data, applying of lineair regression, making of final document and troubleshooting script issues.

## AI tools: 
AI tools were utilized for code validation, Windows-specific path debugging, and conceptual learning. Full model listings, workflows, and human review protocols are documented in [AI.md](./AI.md).
