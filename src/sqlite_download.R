# Download SQLite file from the provided URL
library(here)
url <- "https://filesender.surf.nl/download.php??token=29803da2-2322-4844-aebf-7e0b95129957&files_ids=38390042"
destination_file <- "tiktok_students.sqlite"
# or whatever you want to name it

options(timeout = 600)  
# Allow for longer timeout time, since file size is large (prevents error)

# Download the file
download.file(url, here("data", "raw", destination_file), mode = "wb")

cat("File downloaded successfully to:", destination_file, "\n")

