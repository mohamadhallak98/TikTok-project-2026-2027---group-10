# Ensure required package is available quietly
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
library(here)


# Define project-root-relative path targets
raw_data_dir <- here("data", "raw")
target_file  <- here("data", "raw", "sessions.csv")

# Create raw data directory if it does not exist
if (!dir.exists(raw_data_dir)) {
  dir.create(raw_data_dir, recursive = TRUE)
  message("Created directory: ", raw_data_dir)
}

# Download dataset if not already present locally
file_url <- "https://raw.githubusercontent.com/hannesdatta/course-dprep/refs/heads/main/material/project/coaching_2_data/sessions.csv"

if (!file.exists(target_file)) {
  message("Downloading sessions.csv from remote repository...")
  download.file(file_url, destfile = target_file, mode = "wb")
  message("Download complete! File saved to data/raw/sessions.csv")
} else {
  message("sessions.csv already exists in data/raw/. Skipping download.")
}