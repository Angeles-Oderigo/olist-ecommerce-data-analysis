# Olist E-Commerce Analytics: Logistics & Operational Bottlenecks

## 📌 Project Overview
This project is an end-to-end data analysis of the Olist marketplace dataset. The main objective was to analyze the operational performance and logistics of the platform, transforming raw, inconsistent data into a structured format to uncover delivery bottlenecks and their impact on customer satisfaction.

## 🛠️ Tools & Technologies
* **SQL (MySQL):** Data extraction, intensive cleaning, and database normalization.
* **Power BI & DAX:** Data modeling (Star Schema), cohort analysis, and interactive dashboard creation.

## 🗄️ Data Cleaning & Modeling
The raw dataset contained significant inconsistencies. Key data preparation steps included:
* **Debugging orphaned records:** Used SQL to dynamically identify and resolve orphaned sales records, ensuring financial data accuracy.
* **Data Modeling:** Constructed a clean Star Schema in Power BI to connect orders, products, customers, and geographical data efficiently.

## 📊 Key Business Insights
* **Logistical Bottlenecks:** Analyzed delivery timeframes using DAX cohorts, identifying specific regions and stages where delays occur.
* **Customer Satisfaction:** Correlated delivery delays with negative customer reviews, proving the direct impact of logistics on platform retention.

## 📸 Dashboard Preview
<img width="1312" height="727" alt="sales_analysis" src="https://github.com/user-attachments/assets/b09902bf-a830-4842-9be2-fdd0d1684b12" />
<img width="1313" height="733" alt="logistics_performance" src="https://github.com/user-attachments/assets/18777b9b-cf78-454e-af76-72313ee859f9" />
<img width="1315" height="734" alt="customer_satisfaction" src="https://github.com/user-attachments/assets/e094fbc1-c190-456b-a270-785db2ee3798" />
<img width="1321" height="737" alt="sales_map" src="https://github.com/user-attachments/assets/223d9aa5-e379-4837-b998-4a1f42f96790" />


## 📂 Repository Structure
* `data_cleaning.sql` (and other .sql files): SQL scripts used for data validation, joins, and cleaning.
* `power_bi_dashboards.pdf`: Full export of the interactive Power BI dashboards showcasing all pages and visual insights.
* `Dashboard_Images` (.jpg): High-resolution screenshots of the key Power BI views (Sales Analysis, Logistics Performance, Customer Satisfaction, and Sales Map).
