if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("scales", quietly = TRUE)) install.packages("scales")

library(here)
library(tidyverse)
library(scales)

input_file <- here("data", "raw", "sessions.csv")

if (!file.exists(input_file)) {
  stop("Input file 'data/raw/sessions.csv' not found. Run 01_download_data.R first!")
}

sessions_raw <- read_csv(input_file)

sessions_clean <- sessions_raw %>%
  drop_na() %>%
  mutate(
    session_date = as.Date(login_at),
    watch_efficiency = ifelse(session_duration_sec > 0, (watch_seconds / session_duration_sec) * 100, 0)
  )

# Isolated target output folder
output_dir <- here("gen", "output", "session_analysis")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Plot 1: Histogram (Log-transformed duration)
p1 <- ggplot(sessions_clean, aes(x = session_duration_sec)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.85) +
  scale_x_log10() +
  theme_minimal() +
  labs(
    title = "Distribution of user session duration",
    subtitle = "Log10 transformed scale showing session lengths in seconds",
    x = "Session duration (seconds, Log10 scale)",
    y = "Number of sessions"
  )

ggsave(here("gen", "output", "session_analysis", "session_duration_distribution.png"), plot = p1, width = 7, height = 4.5)

# Plot 2: Bar chart (Top 10 users with direct numeric labels)
top_users <- sessions_clean %>%
  group_by(user_id) %>%
  summarise(total_videos = sum(videos_viewed, na.rm = TRUE), .groups = "drop") %>%
  slice_max(order_by = total_videos, n = 10)

p2 <- ggplot(top_users, aes(x = reorder(as.factor(user_id), total_videos), y = total_videos)) +
  geom_col(fill = "steelblue", width = 0.7) +
  geom_text(aes(label = comma(total_videos)), hjust = -0.15, size = 3.5, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  theme_minimal() +
  labs(
    title = "Top 10 active users by videos viewed",
    subtitle = "Comparing total video consumption across top account IDs",
    x = "User ID",
    y = "Total videos viewed"
  )

ggsave(here("gen", "output", "session_analysis", "top_users_videos.png"), plot = p2, width = 7, height = 4.5)

# Plot 3: Time series line chart (daily trends)
daily_trends <- sessions_clean %>%
  group_by(session_date) %>%
  summarise(total_sessions = n(), .groups = "drop")

p3 <- ggplot(daily_trends, aes(x = session_date, y = total_sessions)) +
  geom_line(color = "darkgreen", linewidth = 1) +
  geom_point(color = "darkgreen", size = 2) +
  theme_minimal() +
  labs(
    title = "Daily session activity trends",
    subtitle = "Tracking total daily login sessions over time",
    x = "Login date",
    y = "Total active sessions"
  )

ggsave(here("gen", "output", "session_analysis", "daily_session_trends.png"), plot = p3, width = 7, height = 4.5)

message("All figures saved to gen/output/session_analysis/")