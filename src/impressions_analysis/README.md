# TikTok impressions analysis

This directory contains the automated data processing and visualization pipeline for analyzing TikTok feed impression engagement (`impressions.csv`), including:
- Data download and cleaning.
- Visualization of impressions by source and top creators.

---
## Features & tutorial implementations (week 4)

- **Regular expressions (`stringr`):** Implements single-pass string pattern matching (`str_remove_all`) to clean messy creator names (removing prefixes like `"The "`, suffixes like `" Official"`, and numerical IDs).
- **String interpolation (`glue`):** Dynamic titles and sub-captions built using `glue::glue()` to reference parameters (e.g., minimum impression count thresholds) cleanly.
- **Functional iteration (`purrr::iwalk`):** Replaces repetitive manual plot exporting code with a functional list loop to programmatically iterate over ggplot objects and export outputs.
- **Data standardization:** Recodes source buckets to project terminology (`followed`, `recommended`, `explore`) and resolves inconsistent creator display names across IDs.

## Output architecture

To avoid file path collisions across team modules, all output figures are saved to an isolated subfolder:
`gen/output/impressions_analysis/`

## Generated visuals:
1. `impressions_by_source.png`: Distribution bar chart of total impressions per feed type.
2. `top_creators_by_score.png`: Boxplot distribution of score totals for top 5 qualifying creators.
3. `top_recommended_creators.png`: Horizontal bar chart ranking engagement across recommended feed placements.

## How to run
1. **Execute the workflow**:
   - Open a terminal in the **project root** and run:
     ```bash
     make
     ```
   - This will:
     1. Download the raw data (if missing).
     2. Generate visualizations (if missing).

2. **To test a fresh build**:
   ```bash
   make clean && make
  ```