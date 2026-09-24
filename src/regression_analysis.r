# Regression analysis

if (!requireNamespace("RSQLite", quietly = TRUE)) install.packages("RSQLite")
if (!requireNamespace("DBI", quietly = TRUE)) install.packages("DBI")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")

library(RSQLite)
library(DBI)
library(tidyverse)

# Create a connection to the SQLite database

con <-dbConnect(SQLite(),dbname= "tiktok_students.sqlite")
result <-dbGetQuery(con,"SELECT * FROM users") %>% tibble()
dbDisconnect(con)

# Get users data with SQL query

users_regression <- dbGetQuery(con, "
  SELECT
    base_videos_watched_mean,
    pref_Comedy,
    pref_Dance,
    pref_BeautyFashion,
    pref_Food,
    pref_FitnessSports
    pref_Gaming
    pref_DIYHome
    pref_Travel
    pref_Education
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
") %>%

# Simple regression: Do people with a higher preference for gaming watch more videos on average?

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

