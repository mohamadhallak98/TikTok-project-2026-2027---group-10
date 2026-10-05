# scripts/query_sqlite.R

# Install required packages if they are not installed yet
required_packages <- c("here", "DBI", "RSQLite")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(here)
library(DBI)
library(RSQLite)

db_path <- here("data", "raw", "tiktok_students.sqlite")

if (!file.exists(db_path)) {
  stop("SQLite file not found at: ", db_path, 
       "\nRun the download script first.")
}

con <- dbConnect(SQLite(), dbname = db_path)

# Inspect available tables
tables <- dbGetQuery(con, "
  SELECT name, type
  FROM sqlite_master
  WHERE type IN ('table', 'view')
  ORDER BY name
")

print(tables)

# Print dimensions, column names, and first rows for each table/view to compare with csv files 
# none match with existing files
for (table_name in tables$name) {
  cat("\n\n==============================\n")
  cat("Table/view:", table_name, "\n")
  cat("==============================\n")
  
  df_head <- dbGetQuery(con, paste0("SELECT * FROM ", table_name, " LIMIT 6"))
  
  cat("\nColumns:\n")
  print(names(df_head))
  
  cat("\nFirst rows:\n")
  print(df_head)
}

# Query for user activity
user_activity <- dbGetQuery(con, "
  SELECT
    user_id,
    user_name,
    user_handle,
    impressions_n,
    watched_n,
    watch_rate,
    total_watch_seconds
  FROM user_view
  LIMIT 10
")

print(user_activity)

dbDisconnect(con)
