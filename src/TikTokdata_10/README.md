------------------------------------------------------------------------

editor_options: markdown: wrap: 72 ---

# TikTok data analysis project (#10)

## Project goal

This project cleans the giving TikTok Watch Events data, so ggplot analyzes can and will be formed.

## Code Improvements

- **Functional Programming**: Used `purrr::map_dbl()` for group-wise aggregations (see `Analysis.qmd`).
- **String Interpolation**: Dynamic plot filenames with `glue()`.
- **Data Cleaning**: Removed duplicate `impression_id` column (identical to `watch_event_id`), as suggested in the PR.

## Requirements

To run this project locally, ensure you have the following installed: \* **R** (v4.2.0 or higher) \* **Quarto CLI** \* **Positron** (or RStudio) \* **R Packages**: ggplot2, dplyr, here, stringr, glue, purrr

# How to Run

1.  **Execute the Workflow**: Open a terminal in the **project root** and run:

``` bash
 make
```

2.  **To test a fresh build** (cleans old outputs first):

``` bash
make clean && make
```

## Expected output

At the end of this project a ggplot will be made and visualized in an image.
