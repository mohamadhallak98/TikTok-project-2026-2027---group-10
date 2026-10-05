# ==============================================================================
# File: src/regression_analysis.R
# Purpose: Run simple and multiple linear regressions on user content preferences 
#          and save coefficient plots to gen/output/regression_analysis/.
# ==============================================================================

# Load required packages
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(tidyverse)
library(here)
library(readr)

# Read users CSV dataset using path resolution
users_path <- here("data", "raw", "users.csv")

if (!file.exists(users_path)) {
  stop("CSV file not found at: ", users_path, "\nPlease check that users.csv exists in data/raw/")
}

users_raw <- read_csv(users_path)

# Filter and select complete observations for regression variables
users_regression <- users_raw %>%
  select(
    base_videos_watched_mean,
    pref_Comedy,
    pref_Dance,
    pref_BeautyFashion,
    pref_Food,
    pref_FitnessSports,
    pref_Gaming,
    pref_DIYHome,
    pref_Travel,
    pref_Education,
    pref_Pets
  ) %>%
  drop_na()

# Setup target output directory
output_dir <- here("gen", "output", "regression_analysis")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Simple regression: Gaming preference vs average videos watched
model_simple <- lm(
  base_videos_watched_mean ~ pref_Gaming,
  data = users_regression
)

summary(model_simple)

# Multiple regression: Content preferences vs average videos watched
model_multiple <- lm(
  base_videos_watched_mean ~ pref_Gaming + pref_Comedy + pref_Dance + 
    pref_BeautyFashion + pref_Food + pref_FitnessSports + pref_DIYHome + 
    pref_Travel + pref_Education + pref_Pets,
  data = users_regression
)

summary(model_multiple)

# Plot 1: Simple Regression Visual
plot1 <- ggplot(users_regression, aes(x = pref_Gaming, y = base_videos_watched_mean)) +
  geom_point(alpha = 0.4, color = "pink") +
  geom_smooth(method = "lm", se = TRUE, color = "darkred") +
  labs(
    title = "Gaming preference and average videos watched",
    subtitle = "Simple linear regression",
    x = "Preference for gaming content",
    y = "Average number of videos watched"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(output_dir, "simple_regression.png"),
  plot = plot1,
  width = 7,
  height = 4.5
)

# Plot 2: Multiple Regression Coefficients
coef_df <- tibble(
  term = names(coef(model_multiple)),
  estimate = coef(model_multiple),
  conf.low = confint(model_multiple)[, 1],
  conf.high = confint(model_multiple)[, 2],
  p.value = summary(model_multiple)$coefficients[, 4]
) %>%
  filter(term != "(Intercept)")

plot2 <- ggplot(coef_df, aes(x = estimate, y = term)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey50") +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    width = 0.2,
    orientation = "y",
    color = "darkred"
  ) +
  geom_point(size = 3, color = "pink") +
  labs(
    title = "Content preferences and average videos watched",
    subtitle = "Multiple linear regression coefficients with 95% confidence intervals",
    x = "Estimated effect on average videos watched",
    y = "Content preference"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(output_dir, "multiple_regression_coefficients.png"),
  plot = plot2,
  width = 7,
  height = 4.5
)

message("Regression analysis complete! Plots saved to gen/output/regression_analysis/")