# Loading required packages

if (!requireNamespace("RSQLite", quietly = TRUE)) install.packages("RSQLite")
if (!requireNamespace("DBI", quietly = TRUE)) install.packages("DBI")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")

library(RSQLite)
library(DBI)
library(tidyverse)
library(here)

# Create a connection to the SQLite database

con <-dbConnect(SQLite(),dbname= "tiktok_students.sqlite")
result <-dbGetQuery(con,"SELECT * FROM users") %>% tibble()

# Get users data with SQL query

users_regression <- dbGetQuery(con, "
  SELECT
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
  FROM users
  WHERE
    base_videos_watched_mean IS NOT NULL
    AND pref_Comedy IS NOT NULL
    AND pref_Dance IS NOT NULL
    AND pref_BeautyFashion IS NOT NULL
    AND pref_Food IS NOT NULL
    AND pref_FitnessSports IS NOT NULL
    AND pref_Gaming IS NOT NULL
    AND pref_DIYHome IS NOT NULL
    AND pref_Travel IS NOT NULL
    AND pref_Education IS NOT NULL
    AND pref_Pets IS NOT NULL
")%>%
  as_tibble()

dbDisconnect(con)

# Isolated target output folder
  output_dir <- here("gen", "output", "regression_analysis")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Simple regression: Is preference for gaming associated with the amount of videos a users watches on average?

model_simple <- lm(
  base_videos_watched_mean ~ pref_Gaming,
  data = users_regression
)

summary(model_simple)

# Multiple regression: Are content preferences associated with users' average amount of videos watched?

model_multiple <- lm(
  base_videos_watched_mean ~ pref_Gaming + pref_Comedy + pref_Dance + pref_BeautyFashion + pref_Food + pref_FitnessSports + pref_DIYHome + pref_Travel + pref_Education + pref_Pets,
  data = users_regression
)

summary(model_multiple)

# Plot 1: Simple regression

plot1 <- ggplot(users_regression, aes(x = pref_Gaming, y = base_videos_watched_mean)) +
  geom_point(alpha = 0.4, color = "pink") +
  geom_smooth(method = "lm", se = TRUE, color = "darkred")+
  labs(
    title = "Gaming preference and average videos watched",
    subtitle = "Simple linear regression",
    x = "Preference for gaming content",
    y = "Average number of videos watched"
  )

plot1

ggsave(
  filename = file.path(output_dir, "simple_regression.png"),
  plot = plot1,
  width = 7,
  height = 4.5
)

# Plot 2: Multiple regression

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

plot2

ggsave(
  filename = file.path(output_dir, "multiple_regression_coefficients.png"),
  plot = plot2,
  width = 7,
  height = 4.5
)
