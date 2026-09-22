# ==============================================================================
# File: src/impressions_analysis/data_analysis.R
# Purpose: Clean TikTok feed impressions data, standardize creator display names
#          using regular expressions, and generate output visualizations.
# ==============================================================================

# Check for required packages, and install if missing
required_packages <- c("tidyverse", "here", "glue", "scales", "purrr")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# Explicitly load all required packages, including newly introduced packages
library(tidyverse) # Includes ggplot2, dplyr, readr, stringr
library(here)      # Safe relative path resolution
library(glue)      # Tutorial technique: String interpolation
library(scales)    # Axis and text number formatting (e.g., comma labels)
library(purrr)     # Tutorial technique: Functional programming and loops (iwalk)

# Load data
impressions_path <- here("data", "raw", "impressions.csv")
if (!file.exists(impressions_path)) {
  stop("Data file not found. Please run download_data.R first.")
}

impressions_raw <- read.csv(impressions_path)

# Checking the data
head(impressions_raw)
glimpse(impressions_raw)
summary(impressions_raw)

# Cleaning the data

# 1) Recoding the source labels to make more sense with the assignment
# Recode source labels to match project terminology
impressions_clean <- impressions_raw %>%
  mutate(
    source_bucket = recode(
      source_bucket,
      known = "followed",
      preferred_new = "recommended",
      explore = "explore"
    ),
    source_bucket = factor(source_bucket, levels = c("followed", "recommended", "explore"))
  ) %>%
  distinct(impression_id, .keep_all = TRUE)

# 2) Remove duplicated impressions
impressions_clean %>%
  count(impression_id) %>%
  filter(n > 1) %>%
  arrange(desc(n))

impressions_clean <- impressions_clean %>%
  distinct(impression_id, .keep_all = TRUE)

# 3) Standardize creator names for each creator_id
impressions_clean %>%
  distinct(creator_id, creator_display_name) %>%
  arrange(creator_id, creator_display_name) %>%
  filter(creator_id %in% (
    impressions_clean %>%
      distinct(creator_id, creator_display_name) %>%
      count(creator_id) %>%
      filter(n > 1) %>%
      pull(creator_id)
  ))

creator_name_map <- impressions_clean %>%
  mutate(
    creator_display_name_clean = creator_display_name %>%
      str_replace_all("-", " ") %>%
      str_remove_all("^(The\\s+)|(\\s+Official)$|(\\s+\\d+)$") %>%
      str_squish()
  ) %>%
  count(creator_id, creator_display_name_clean, sort = TRUE) %>%
  arrange(creator_id, desc(n), creator_display_name_clean) %>%
  group_by(creator_id) %>%
  slice(1) %>%
  ungroup() %>%
  select(creator_id, creator_display_name = creator_display_name_clean)

# Merge standardized creator names back into main dataset with a clear variable name
impressions_standardized <- impressions_clean %>%
  select(-creator_display_name) %>%
  left_join(creator_name_map, by = "creator_id")

# extra checks
impressions_standardized %>%
  count(source_bucket, sort = TRUE)

impressions_standardized %>%
  summarise(n_rows = n(), n_distinct_impression_id = n_distinct(impression_id))

summary(impressions_standardized)

# visualizing the data

# Create an isolated output directory to avoid overwriting teammate artifacts
output_dir <- here("gen", "output", "impressions_analysis")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

p1 <- impressions_standardized %>%
  count(source_bucket) %>%
  ggplot(aes(x = source_bucket, y = n, fill = source_bucket)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = comma(n)), vjust = -0.5, size = 3.5, fontface = "bold") +
  scale_fill_manual(values = c(
    followed = "steelblue",
    recommended = "darkorange",
    explore = "forestgreen"
  )) +
  labs(
    x = "Source category",
    y = "Number of impressions",
    title = "Impressions by source category",
    subtitle = "Distribution across followed, recommended, and explore feed sources"
  ) +
  coord_cartesian(ylim = c(0, max(count(impressions_standardized, source_bucket)$n) * 1.12)) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")


# 2) Top 5 creators by mean score_total, with at least 100 impressions
min_impressions <- 100

top_creators <- impressions_standardized %>%
  group_by(creator_id, creator_display_name) %>%
  summarise(
    n_impressions = n(),
    mean_score = mean(score_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_impressions >= min_impressions) %>%
  slice_max(mean_score, n = 5)


p2 <- impressions_standardized %>%
  semi_join(top_creators, by = c("creator_id", "creator_display_name")) %>%
  mutate(creator_display_name = fct_reorder(creator_display_name, score_total, .fun = mean)) %>%
  ggplot(aes(x = creator_display_name, y = score_total, fill = creator_display_name)) +
  geom_boxplot(width = 0.65, alpha = 0.75, outlier.alpha = 0.5) +
  geom_jitter(width = 0.12, alpha = 0.15, size = 1) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    x = "Creator",
    y = "Score total",
    title = glue("Top 5 creators by mean total score"),
    subtitle = glue("Filtered for creators with at least {min_impressions} impressions")
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")



# 3) top 5 recommended creators
top_recommended_creators <- impressions_standardized %>%
  filter(source_bucket == "recommended") %>%
  group_by(creator_id, creator_display_name) %>%
  summarise(
    n_impressions = n(),
    mean_score = mean(score_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_impressions >= min_impressions) %>%
  slice_max(mean_score, n = 5)


p3 <- ggplot(top_recommended_creators, aes(x = reorder(creator_display_name, mean_score), y = mean_score)) +
  geom_col(fill = "darkorange", width = 0.7) +
  coord_flip() +
  labs(
    x = "Creator",
    y = "Mean score",
    title = glue("Top 5 recommended feed creators"),
    subtitle = glue("Highest average engagement scores in recommended feed")
  ) +
  theme_minimal(base_size = 12)


# --- 7. AUTOMATED PLOT SAVING LOOP ---
# Store all plot objects in a named list
plots_list <- list(
  "impressions_by_source.png" = p1,
  "top_creators_by_score.png" = p2,
  "top_recommended_creators.png" = p3
)

# Tutorial technique: Functional loop (purrr::iwalk) to automatically save figures
# .x represents the plot object, .y represents the file name string
iwalk(plots_list, ~ ggsave(filename = file.path(output_dir, .y), plot = .x, width = 8, height = 5, dpi = 300))

message("All impression figures successfully saved to gen/output/impressions_analysis/")