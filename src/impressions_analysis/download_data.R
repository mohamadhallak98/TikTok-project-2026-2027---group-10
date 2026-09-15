# Load required libraries
library(readr)
library(here)

# Define the URL for the data
url <- "https://raw.githubusercontent.com/hannesdatta/course-dprep/refs/heads/main/material/project/coaching_2_data/impressions.csv"

# Define the path where the data will be saved (relative to the project root)
data_path <- here("data", "raw", "impressions.csv")

# Create the data/raw folder if it doesn't exist
if (!dir.exists(here("data", "raw"))) {
  dir.create(here("data", "raw"), recursive = TRUE)
}

# Download the data
download.file(url, data_path)


