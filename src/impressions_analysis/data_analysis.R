# Check for required packages, and install if missing
required_packages <- c("tidyverse", "here")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

library(tidyverse)
library(here)

# Load data
impressions_path <- here("data", "raw", "impressions.csv")
if (!file.exists(impressions_path)) {
  stop("Data file not found. Please run download_data.R first.")
}

impressions <- read_csv(impressions_path)

# Checking the data
head(impressions)
glimpse(impressions)
summary(impressions)

# Cleaning the data

# 1) Recoding the source labels to make more sense with the assignment
impressions <- impressions %>%
  mutate(
    source_bucket = recode(
      source_bucket,
      known = "followed",
      preferred_new = "recommended",
      explore = "explore"
    ),
    source_bucket = factor(source_bucket, levels = c("followed", "recommended", "explore"))
  )

# 2) Remove duplicated impressions
impressions %>%
  count(impression_id) %>%
  filter(n > 1) %>%
  arrange(desc(n))

impressions_clean <- impressions %>%
  distinct(impression_id, .keep_all = TRUE)

# 3) Standardize creator names for each creator_id
impressions %>%
  distinct(creator_id, creator_display_name) %>%
  arrange(creator_id, creator_display_name) %>%
  filter(creator_id %in% (
    impressions %>%
      distinct(creator_id, creator_display_name) %>%
      count(creator_id) %>%
      filter(n > 1) %>%
      pull(creator_id)
  ))

creator_name_map <- impressions_clean %>%
  mutate(
    creator_display_name_clean = creator_display_name %>%
      str_replace_all("-", " ") %>%
      str_squish() %>%
      str_remove("^The\\s+") %>%
      str_remove("\\s+Official$") %>%
      str_remove("\\s+\\d+$") %>%
      str_squish()
  ) %>%
  count(creator_id, creator_display_name_clean, sort = TRUE) %>%
  arrange(creator_id, desc(n), creator_display_name_clean) %>%
  group_by(creator_id) %>%
  slice(1) %>%
  ungroup() %>%
  select(creator_id, creator_display_name = creator_display_name_clean)

impressions_cleaner <- impressions_clean %>%
  select(-creator_display_name) %>%
  left_join(creator_name_map, by = "creator_id")

# extra checks
impressions_cleaner %>%
  count(source_bucket, sort = TRUE)

impressions_cleaner %>%
  summarise(n_rows = n(), n_distinct_impression_id = n_distinct(impression_id))

summary(impressions_cleaner)

# visualizing the data

# 1) Distribution of impressions by source bucket
if (!dir.exists(here("output"))) {
  dir.create(here("output"), recursive = TRUE)
}
p1 <- impressions_cleaner %>%
  count(source_bucket) %>%
  ggplot(aes(x = source_bucket, y = n, fill = source_bucket)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = n), vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c(
    followed = "#4E79A7",
    recommended = "#F28E2B",
    explore = "#59A14F"
  )) +
  labs(
    x = "Source category",
    y = "Number of impressions",
    title = "Impressions by source category",
    subtitle = "Count of impressions after cleaning and recoding the sources"
  ) +
  coord_cartesian(ylim = c(0, max(count(impressions_cleaner, source_bucket)$n) * 1.12)) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

p1

ggsave(filename = here("output", "impressions_by_source.png"), plot = p1, width = 8, height = 5, dpi = 300)

# 2) Top 5 creators by mean score_total, with at least 100 impressions
min_impressions <- 100

top_creators <- impressions_cleaner %>%
  group_by(creator_id, creator_display_name) %>%
  summarise(
    n_impressions = n(),
    mean_score = mean(score_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_impressions >= min_impressions) %>%
  slice_max(mean_score, n = 5)

top_creators

p2 <- impressions_cleaner %>%
  semi_join(top_creators, by = c("creator_id", "creator_display_name")) %>%
  mutate(creator_display_name = fct_reorder(creator_display_name, score_total, .fun = mean)) %>%
  ggplot(aes(x = creator_display_name, y = score_total, fill = creator_display_name)) +
  geom_boxplot(width = 0.65, alpha = 0.75, outlier.alpha = 0.5) +
  geom_jitter(width = 0.12, alpha = 0.15, size = 1) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    x = "Creator",
    y = "Score total",
    title = paste0("Top 5 creators by mean score_total"),
    subtitle = paste0("Only creators with at least ", min_impressions, " impressions are shown")
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

p2

ggsave(filename = here("output", "top_creators_by_score.png"), plot = p2, width = 8, height = 5, dpi = 300)

# 3) top 5 recommended creators
top_recommended_creators <- impressions_cleaner %>%
  filter(source_bucket == "recommended") %>%
  group_by(creator_id, creator_display_name) %>%
  summarise(
    n_impressions = n(),
    mean_score = mean(score_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_impressions >= min_impressions) %>%
  slice_max(mean_score, n = 5)
top_recommended_creators
