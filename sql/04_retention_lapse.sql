-- Retention and lapse classification
-- Compares prior 90-day vs recent 90-day shopping behaviour,
-- calculates decline metrics and identifies Potential Lapse households.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_ENGAGEMENT_STATUS AS

WITH RECENT_BEHAVIOUR AS (

    SELECT
        HOUSEHOLD_KEY,

        COUNT(DISTINCT CASE
            WHEN DAY BETWEEN 532 AND 621 THEN DAY
        END) AS PRIOR_90D_SHOPPING_DAYS,

        COUNT(DISTINCT CASE
            WHEN DAY BETWEEN 622 AND 711 THEN DAY
        END) AS RECENT_90D_SHOPPING_DAYS,

        SUM(CASE
            WHEN DAY BETWEEN 532 AND 621
            THEN SALES_VALUE ELSE 0
        END) AS PRIOR_90D_SALES,

        SUM(CASE
            WHEN DAY BETWEEN 622 AND 711
            THEN SALES_VALUE ELSE 0
        END) AS RECENT_90D_SALES

    FROM CUSTOMER_ANALYTICS.STAGING.STG_TRANSACTIONS
    GROUP BY HOUSEHOLD_KEY
),

CHANGE_METRICS AS (

    SELECT
        *,

        RECENT_90D_SHOPPING_DAYS
        - PRIOR_90D_SHOPPING_DAYS
            AS SHOPPING_DAY_CHANGE,

        PRIOR_90D_SHOPPING_DAYS
        - RECENT_90D_SHOPPING_DAYS
            AS SHOPPING_DAYS_LOST,

        CASE
            WHEN PRIOR_90D_SHOPPING_DAYS > 0
            THEN
                (RECENT_90D_SHOPPING_DAYS
                 - PRIOR_90D_SHOPPING_DAYS)
                * 100.0
                / PRIOR_90D_SHOPPING_DAYS
        END AS SHOPPING_DAY_CHANGE_PCT,

        RECENT_90D_SALES
        - PRIOR_90D_SALES
            AS SALES_CHANGE,

        CASE
            WHEN PRIOR_90D_SALES > 0
            THEN
                (RECENT_90D_SALES - PRIOR_90D_SALES)
                * 100.0
                / PRIOR_90D_SALES
        END AS SALES_CHANGE_PCT

    FROM RECENT_BEHAVIOUR
)

SELECT
    c.*,

    d.PRIOR_90D_SHOPPING_DAYS,
    d.RECENT_90D_SHOPPING_DAYS,
    d.SHOPPING_DAY_CHANGE,
    d.SHOPPING_DAYS_LOST,
    d.SHOPPING_DAY_CHANGE_PCT,

    d.PRIOR_90D_SALES,
    d.RECENT_90D_SALES,
    d.SALES_CHANGE,
    d.SALES_CHANGE_PCT,

    CASE
        WHEN c.AVG_DAYS_BETWEEN_SHOPPING_DAYS IS NOT NULL
        THEN c.RECENCY_DAYS
             / NULLIF(c.AVG_DAYS_BETWEEN_SHOPPING_DAYS, 0)
    END AS RECENCY_VS_NORMAL,

    CASE

        WHEN d.PRIOR_90D_SHOPPING_DAYS = 0
            THEN 'No Prior Baseline'

        WHEN d.SHOPPING_DAY_CHANGE_PCT <= -50
         AND d.SHOPPING_DAYS_LOST >= 3
         AND d.SALES_CHANGE_PCT <= -25
         AND c.RECENCY_DAYS >=
             c.AVG_DAYS_BETWEEN_SHOPPING_DAYS * 2
            THEN 'Potential Lapse'

        WHEN d.SHOPPING_DAY_CHANGE_PCT <= -50
         AND d.SHOPPING_DAYS_LOST >= 3
         AND d.SALES_CHANGE_PCT <= -25
            THEN 'Strong Decline'

        WHEN d.SHOPPING_DAY_CHANGE_PCT < 0
         AND d.SALES_CHANGE_PCT < 0
            THEN 'Some Decline'

        ELSE 'Stable / Improving'

    END AS ENGAGEMENT_STATUS

FROM CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_SEGMENTS c

JOIN CHANGE_METRICS d
    ON c.HOUSEHOLD_KEY = d.HOUSEHOLD_KEY;