# The Criterion Standard: A Data-Driven Strategy for Collection Expansion

**By Derek Lein** [Portfolio](INSERT_YOUR_PORTFOLIO_URL_HERE) | [LinkedIn](https://www.linkedin.com/in/derek-lein-4171a6291/)

---

## 🎬 Project Overview
As an assistant editor with nearly a decade of experience in the film industry, and currently shifting over to the data analytics field, I recognized a strategic challenge for boutique Blu-ray distributors: how to expand their often massive, curated catalog while simultaneously maintaining their brand identity. 

This project utilizes **R** for data engineering and **Tableau** for strategic visualization to identify "Expansion Potential"—directors and genres with high audience acclaim and market popularity which are currently underrepresented in the Criterion Collection.

## 📊 Interactive Dashboard
[[Criterion Dashboard Screenshot]()](https://public.tableau.com/views/CriterionCollectionAnalysis_17753340053120/TheCriterionStandardAData-DrivenStrategyforCollectionExpansion?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link))
*> Click the image above to view the interactive dashboard on Tableau Public.*

---

## 🛠️ Tech Stack & Methodology
* **R (tidyverse, ggplot2):** Data cleaning, API merging (TMDb, IMDb, Letterboxd), and Exploratory Data Analysis.
* **Tableau:** Final dashboard design, quadrant analysis, and interactive filtering.

## 📈 Key Strategic Questions
1. **Finding The "Blind Spot":** Which directors and genres show high audience scores, but low collection volume?
2. **Assessing "Market Demand" Gap:** Which directors and genres show high popularity scores, but low collection volume?
3. **Priority Roadmap:** Based on the "Expansion Potential" quadrant, as well as current licensing and availability, which specific titles should be prioritized for induction?

---

## 📂 Repository Structure
* `01_criterion_cleaning.R`: Script for merging disparate film databases and handling null values.
* `02_criterion_analysis_notebook.Rmd`: The full technical report.
* `03_criterion_tableau_exports.R`: Prepares long-format CSVs for Tableau optimization.

---
