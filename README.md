# The Criterion Standard: A Data-Driven Strategy for Collection Expansion

**By Derek Lein** [Portfolio](INSERT_YOUR_PORTFOLIO_URL_HERE) | [LinkedIn](https://www.linkedin.com/in/derek-lein-4171a6291/)

---

## 🎬 Project Overview
As an assistant editor with nearly a decade of experience in the film industry, and currently shifting over to the data analytics field, I recognized a strategic challenge for boutique Blu-ray distributors: how to expand their often massive, curated catalog while simultaneously maintaining their brand identity. 

This project utilizes **R** for data engineering and **Tableau** for strategic visualization to identify "Expansion Potential"—directors and genres with high audience acclaim and market popularity which are currently underrepresented in the Criterion Collection.

---

## 📊 Interactive Dashboard
[![Dashboard](images/Derek%20Lein%20Criterion%20Collection%20Analysis%20Tableau%20Dashboard.png)](https://public.tableau.com/views/CriterionCollectionAnalysis_17753340053120/TheCriterionStandardAData-DrivenStrategyforCollectionExpansion?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link:showVizHome=no)
*> Click the image above to view the interactive dashboard on Tableau Public.*

---

## 🛠️ Tech Stack & Methodology
* **R (tidyverse, ggplot2):** Data cleaning, API merging (TMDb, IMDb, Letterboxd), and Exploratory Data Analysis.
* **Tableau:** Final dashboard design, quadrant analysis, and interactive filtering.

---

## 📈 Key Strategic Questions
1. **Finding The "Blind Spot":** Which directors and genres show high audience scores, but low collection volume?
2. **Assessing "Market Demand" Gap:** Which directors and genres show high popularity scores, but low collection volume?
3. **Priority Roadmap:** Based on the "Expansion Potential" quadrant, as well as current licensing and availability, which specific titles should be prioritized for induction?

---

## 🎯 Insights & Conclusions
1. **Auteur Titans:** Both **Bong Joon-ho** and **Billy Wilder** boast some of the highest audience ratings and popularity scores in the dataset, yet currently represent a small fraction of the collection, with only 3 titles each. Given their massive market appeal, prioritizing their uncollected iconic titles offers an ideal target for catalog expansion.
2. **Hidden Gem:** While **Fritz Lang** is an icon among cinephiles, his high audience score and well above average popularity metrics, inspite of the age of most of his films, were unexpected. Given that one of his most well-known silent titles, *Dr. Mabuse the Gambler (1922)*, is currently unavailable on home media, there's a clear strategic opening to release a "Mabuse Trilogy" box set of all three films in this foundational crime epic.
3. **Genre Blindspots:** The **War** and **History** genres exhibit some of the highest audience ratings, while **Mystery** is one of the leaders in popularity metrics; yet, all three remain underrepresented in the collection. Targeting acquisitions in these three categories - ranging from blockbuster directors like Christopher Nolan and Denis Villeneuve, to international favorites like Zhang Yimou and Michael Haneke - would allow the collection to captialize on resonant themes while maintaing their brand of prestige and historical importance.

---

## 📂 Repository Structure
* `01_criterion_cleaning.R`: Script for merging disparate film databases and handling null values.
* `02_criterion_analysis_notebook.Rmd`: The full technical report.
* `03_criterion_tableau_exports.R`: Prepares long-format CSVs for Tableau optimization.

---
