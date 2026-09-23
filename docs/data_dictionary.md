# Data Dictionary

## Core Analytical Tables

### CUSTOMER_360_FINAL
One row per household.

Important fields:
- HOUSEHOLD_KEY
- TOTAL_BASKETS
- TOTAL_SHOPPING_DAYS
- SHOPPING_DAYS_PER_30_DAYS
- TOTAL_SALES_VALUE
- AVG_BASKET_VALUE
- RECENCY_DAYS
- AVG_DAYS_BETWEEN_SHOPPING_DAYS
- HAS_DEMOGRAPHICS
- HAS_CAMPAIGN_ASSIGNMENT
- HAS_COUPON_REDEMPTION

### CUSTOMER_SEGMENTS
Customer 360 data enriched with:
- R_SCORE
- F_SCORE
- M_SCORE
- RFM_CODE
- CUSTOMER_SEGMENT

### CUSTOMER_ENGAGEMENT_STATUS
Contains:
- Prior 90-day shopping behaviour
- Recent 90-day shopping behaviour
- Sales change
- Shopping-day change
- Recency vs normal shopping gap
- Engagement status

### CAMPAIGN_PERFORMANCE
One row per campaign.

Contains:
- Campaign type
- Assigned households
- Redeeming households
- Response rate
- Pre-campaign sales
- During-campaign sales
- Sales change %

### MARKET_BASKET_PAIRS
Contains:
- Category A
- Category B
- Baskets together
- Support
- Confidence A → B
- Confidence B → A
- Lift