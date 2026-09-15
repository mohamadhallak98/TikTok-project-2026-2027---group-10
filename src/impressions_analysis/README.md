# TikTok Impressions Analysis

This folder contains the analysis of TikTok feed impressions data, including:
- Data download and cleaning.
- Visualization of impressions by source and top creators.

---

#
# How to Run
1. **Execute the Workflow**:
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
