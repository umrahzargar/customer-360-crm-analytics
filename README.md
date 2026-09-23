# Customer 360 — Retention, Segmentation & CRM Analytics

An end-to-end customer analytics project using **Snowflake, SQL and Power BI** to understand customer value, shopping behaviour, engagement decline, campaign response and actionable CRM opportunities.

Built using the **dunnhumby – The Complete Journey** retail dataset.

---

## 📊 Dashboard Preview

<img width="2325" height="1340" alt="01 Overview" src="https://github.com/user-attachments/assets/1c039c77-7a47-42c5-abb6-380077d0c1e3" />


[Customer_360_CRM_Analytics.pdf](https://github.com/user-attachments/files/32572012/Customer_360_CRM_Analytics.pdf)


---

## 🎯 Project Objective

The objective was to build a **Customer 360 analytical view** and answer practical CRM questions:

- Which customer groups generate the most value?
- How do different customer segments shop?
- Which customers are showing meaningful engagement decline?
- How does campaign response vary across customer groups?
- Which customers should be prioritised for re-engagement?
- What personalisation and cross-sell opportunities can be identified?

---

## 🛠 Tech Stack

| Tool | Purpose |
|---|---|
| **Snowflake** | Data storage, transformation and analytical modelling |
| **SQL** | Staging, joins, feature engineering and business logic |
| **Power BI** | Semantic model, DAX measures and dashboard development |
| **Power Query** | Lightweight reporting-layer transformations |

---

## 🔄 Analytics Pipeline

```text
Raw CSV Files
      ↓
Snowflake RAW
      ↓
Snowflake STAGING
      ↓
Validation & Transformation
      ↓
Snowflake ANALYTICS
      ↓
Power BI Semantic Model
      ↓
Interactive CRM Dashboard
```

Heavy joins, transformations and aggregations were performed in **Snowflake**, while Power BI was primarily used for measures, interaction and business-facing reporting.

---

## 🗂 Data Architecture

### RAW

Original source files were loaded without analytical transformation.

### STAGING

The staging layer:

- standardised reporting fields;
- prepared transaction and product data;
- enriched campaign assignments;
- connected coupons with campaign and product information;
- validated coupon redemption timing;
- preserved meaningful source records rather than applying arbitrary deletion.

### ANALYTICS

Business-ready analytical tables were created for:

- Customer 360
- RFM scoring
- Customer segmentation
- Retention and lapse analysis
- Campaign performance
- Segment × campaign response
- Market basket analysis

---

## 👤 Customer 360

A household-level Customer 360 table was created with **one row per household**.

Key features included:

- Total baskets
- Total shopping days
- Shopping days per 30 days
- Total historical sales
- Average basket value
- Recency
- Average gap between shopping days
- Demographic availability
- Campaign assignments
- Coupon redemption activity

**Average Basket Value**

```text
Total Sales Value / Total Baskets
```

Shopping days were used alongside basket counts because customers could generate multiple baskets on the same day.

---

## 👥 Customer Segmentation

Customers were scored using an **RFM-style behavioural framework**:

- **R — Recency**
- **F — Shopping frequency**
- **M — Historical sales value**

Six mutually exclusive segments were created:

1. High-Value Active
2. High-Value Inactive
3. Frequent Lower-Value
4. Occasional Higher-Value
5. Recent Lower-Engagement
6. Low-Engagement Inactive

### Key Finding

> **32.2% of households generated 62.1% of total sales value.**

---

## ⚠️ Retention & Lapse Analysis

Customer behaviour was compared across two equal **90-day periods**.

A household was classified as **Potential Lapse** when all of the following conditions were met:

- Shopping days declined by at least **50%**
- At least **3 shopping days were lost**
- Sales declined by at least **25%**
- Current recency was at least **2× the household's normal shopping gap**

### Key Findings

- **140 households** identified as Potential Lapse
- **5.6%** of the customer base
- High-Value Inactive had the highest lapse rate at **22.4%**
- **57 High-Value Inactive households** were Potential Lapse
- These households represented approximately **£246.6K in historical sales**

The term **Potential Lapse** is used rather than confirmed churn because the dataset only represents an observed time window.

---

## 📣 Campaign & Coupon Analysis

Campaign analysis covered:

- **30 campaigns**
- **7,208 household-campaign assignments**
- **1,584 campaign-assigned households**
- **434 coupon-redeeming households**
- **889 responding household-campaign assignments**

### Observed Response by Campaign Type

| Campaign Type | Response Rate |
|---|---:|
| Type A | **16.0%** |
| Type B | **7.9%** |
| Type C | **7.7%** |

Campaign response was also analysed by customer segment and engagement status.

Pre-campaign and during-campaign sales were compared using equal-length windows.

> **Important:** Campaign comparisons are descriptive rather than causal because campaign assignment was not established as a randomised experiment.

---

## 🎯 CRM Opportunity

A focused re-engagement audience was defined as:

```text
High-Value Inactive
        +
Potential Lapse
        +
Prior Coupon Responder
```

This identified:

- **14 priority households**
- **£74.5K historical sales represented**
- **£5,318.64 average historical sales per household**
- **57.7 days average recency**

This audience represents historically valuable customers showing meaningful engagement deterioration who have previously responded to coupon activity.

---

## 🛒 Market Basket Analysis

Basket-level co-purchase analysis was used to identify potential cross-sell opportunities.

### Metrics

- **Support** — how frequently two categories appeared together
- **Confidence** — probability of purchasing B when A was purchased
- **Lift** — association strength relative to chance

Only category pairs appearing in at least **500 baskets** were retained.

| Category Pair | Support | Confidence | Lift |
|---|---:|---:|---:|
| Pasta + Pasta Sauce | 2.54% | 45.8% | 9.88 |
| Cheese + Deli Meats | 2.82% | 63.0% | 9.30 |
| Cat Food + Cat Litter | 0.51% | — | 16.88 |

> High lift alone is not enough — useful CRM opportunities need both **association strength and meaningful scale**.

---

# 📈 Power BI Dashboard

## 01 — Executive Overview

<img width="2325" height="1340" alt="01 Overview" src="https://github.com/user-attachments/assets/d5ede63f-da31-4986-bd0a-8b8716bea0b8" />


High-level view of customer value, engagement health and CRM reach.

---

## 02 — Customer Segmentation

<img width="2325" height="1340" alt="02 Segmentation" src="https://github.com/user-attachments/assets/a8ff167e-9d26-48d5-bd26-6b3dd880f49b" />


Interactive analysis of segment size, sales contribution, shopping behaviour, category preferences and demographics.

---

## 03 — Retention & Lapse

<img width="2325" height="1340" alt="03 Retention   Lapse" src="https://github.com/user-attachments/assets/d21a2714-94bf-403e-a079-efc363839f59" />


Identifies meaningful deterioration in customer behaviour and highlights high-value households for re-engagement.

---

## 04 — Campaign Performance & Coupon Response

<img width="2325" height="1340" alt="04 Campaigns" src="https://github.com/user-attachments/assets/3f6718fa-38e4-4545-83a9-e2e70750ab6d" />


Analyses campaign response by type, engagement status and customer segment, alongside descriptive pre/post sales comparisons.

---

## 05 — CRM Opportunities & Recommendations

<img width="2325" height="1340" alt="05 Opportunities" src="https://github.com/user-attachments/assets/b92f11b3-200b-46cc-ac46-14f8bf2b24b2" />


Translates the analysis into practical CRM actions:

1. Re-engage high-value lapse customers
2. Personalise promotions using purchase history
3. Test cross-sell opportunities
4. Measure incremental impact using control/holdout groups

---

## 📁 Repository Structure

```text
customer-360-crm-analytics/
│
├── README.md
│
├── dashboard/
│   ├── customer-360-crm-analytics.pdf
│   ├── dashboard-overview.png
│   ├── 01-overview.png
│   ├── 02-segmentation.png
│   ├── 03-retention-lapse.png
│   ├── 04-campaigns.png
│   └── 05-opportunities.png
│
├── docs/
│   ├── methodology.md
│   └── data_dictionary.md
│
├── powerbi/
│   ├── Customer_360_CRM_Analytics.pbix
│   ├── Customer_360_CRM_Analytics.pbip
│   ├── Customer_360_CRM_Analytics.Report/
│   └── Customer_360_CRM_Analytics.SemanticModel/
│
└── sql/
    ├── 01_staging.sql
    ├── 02_customer_360.sql
    ├── 03_segmentation.sql
    ├── 04_retention_lapse.sql
    ├── 05_campaign_analysis.sql
    └── 06_market_basket_analysis.sql
```

---

## 💻 SQL Workflow

| File | Purpose |
|---|---|
| `01_staging.sql` | Prepare transactions, products, demographics, campaigns and coupons |
| `02_customer_360.sql` | Build the household-level Customer 360 |
| `03_segmentation.sql` | RFM scoring and customer segmentation |
| `04_retention_lapse.sql` | Behaviour deterioration and lapse classification |
| `05_campaign_analysis.sql` | Campaign response and segment-level campaign analysis |
| `06_market_basket_analysis.sql` | Support, confidence and lift for category pairs |

---

## ✅ Key Analytical Decisions

**Shopping frequency**  
Shopping days were used alongside basket count because multiple baskets could occur on the same day.

**Acquisition**  
First observed purchase was not treated as acquisition because it does not necessarily represent the customer's first-ever relationship with the retailer.

**Churn**  
The analysis uses **Potential Lapse** rather than claiming confirmed churn.

**Demographics**  
Demographic coverage was incomplete and varied substantially by segment, so demographic findings are treated as exploratory.

**Campaign performance**  
Pre/post campaign comparisons are descriptive rather than causal.

**Historical sales**  
Historical customer sales are described as **historical sales represented**, rather than revenue at risk.

---

## 🔍 Data Quality & Validation

Checks included:

- Null values
- Duplicate records
- Unmatched product IDs
- Unmatched campaign IDs
- Campaign date ranges
- Redemption timing
- Household counts
- Transaction totals
- Campaign assignment counts
- Coupon redemption counts

Important totals were reconciled before being used in Power BI.

---

## 💡 Business Recommendations

The analysis suggests testing:

- personalised re-engagement for high-value lapse customers;
- category-based offer personalisation;
- cross-sell bundles informed by basket analysis;
- controlled CRM experiments using holdout groups.

Suggested evaluation metrics include:

- Reactivation rate
- Shopping frequency
- Basket value
- Coupon redemption
- Incremental sales

---

## 🚀 Future Improvements

A production version could include:

- Automated Snowflake → Power BI refresh
- Customer lifetime value modelling
- Propensity-to-lapse modelling
- Campaign uplift modelling
- Randomised CRM experiments
- Automated CRM audience generation
- Incrementality measurement

---

## 📚 Dataset

This project uses the **dunnhumby – The Complete Journey** dataset.

Raw source data is **not redistributed in this repository**.

---

## 👤 Author

**Umrah**  
MSc Data Science — University of Nottingham
