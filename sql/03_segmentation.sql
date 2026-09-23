-- RFM scoring
-- Scores customers on recency, shopping frequency and total sales value
-- using quartile-based thresholds derived from the Customer 360 table.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_RFM_SCORED AS

SELECT
    c.*,

    CASE
        WHEN RECENCY_DAYS <= 1 THEN 4
        WHEN RECENCY_DAYS <= 6 THEN 3
        WHEN RECENCY_DAYS <= 20 THEN 2
        ELSE 1
    END AS R_SCORE,

    CASE
        WHEN SHOPPING_DAYS_PER_30_DAYS < 1.4346 THEN 1
        WHEN SHOPPING_DAYS_PER_30_DAYS < 2.95359 THEN 2
        WHEN SHOPPING_DAYS_PER_30_DAYS < 5.23206 THEN 3
        ELSE 4
    END AS F_SCORE,

    CASE
        WHEN TOTAL_SALES_VALUE < 970.74 THEN 1
        WHEN TOTAL_SALES_VALUE < 2157.75 THEN 2
        WHEN TOTAL_SALES_VALUE < 4413.32 THEN 3
        ELSE 4
    END AS M_SCORE,

    CONCAT(
        CASE
            WHEN RECENCY_DAYS <= 1 THEN 4
            WHEN RECENCY_DAYS <= 6 THEN 3
            WHEN RECENCY_DAYS <= 20 THEN 2
            ELSE 1
        END,
        CASE
            WHEN SHOPPING_DAYS_PER_30_DAYS < 1.4346 THEN 1
            WHEN SHOPPING_DAYS_PER_30_DAYS < 2.95359 THEN 2
            WHEN SHOPPING_DAYS_PER_30_DAYS < 5.23206 THEN 3
            ELSE 4
        END,
        CASE
            WHEN TOTAL_SALES_VALUE < 970.74 THEN 1
            WHEN TOTAL_SALES_VALUE < 2157.75 THEN 2
            WHEN TOTAL_SALES_VALUE < 4413.32 THEN 3
            ELSE 4
        END
    ) AS RFM_CODE

FROM CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_360_FINAL c;


-- Customer segment assignment
-- Groups customers into six mutually exclusive behavioural segments
-- using the RFM scores created above.


CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_RFM_SCORED AS

SELECT
    c.*,

    CASE
        WHEN RECENCY_DAYS <= 1 THEN 4
        WHEN RECENCY_DAYS <= 6 THEN 3
        WHEN RECENCY_DAYS <= 20 THEN 2
        ELSE 1
    END AS R_SCORE,

    CASE
        WHEN SHOPPING_DAYS_PER_30_DAYS < 1.4346 THEN 1
        WHEN SHOPPING_DAYS_PER_30_DAYS < 2.95359 THEN 2
        WHEN SHOPPING_DAYS_PER_30_DAYS < 5.23206 THEN 3
        ELSE 4
    END AS F_SCORE,

    CASE
        WHEN TOTAL_SALES_VALUE < 970.74 THEN 1
        WHEN TOTAL_SALES_VALUE < 2157.75 THEN 2
        WHEN TOTAL_SALES_VALUE < 4413.32 THEN 3
        ELSE 4
    END AS M_SCORE,

    CONCAT(
        CASE
            WHEN RECENCY_DAYS <= 1 THEN 4
            WHEN RECENCY_DAYS <= 6 THEN 3
            WHEN RECENCY_DAYS <= 20 THEN 2
            ELSE 1
        END,
        CASE
            WHEN SHOPPING_DAYS_PER_30_DAYS < 1.4346 THEN 1
            WHEN SHOPPING_DAYS_PER_30_DAYS < 2.95359 THEN 2
            WHEN SHOPPING_DAYS_PER_30_DAYS < 5.23206 THEN 3
            ELSE 4
        END,
        CASE
            WHEN TOTAL_SALES_VALUE < 970.74 THEN 1
            WHEN TOTAL_SALES_VALUE < 2157.75 THEN 2
            WHEN TOTAL_SALES_VALUE < 4413.32 THEN 3
            ELSE 4
        END
    ) AS RFM_CODE

FROM CUSTOMER_ANALYTICS.ANALYTICS.CUSTOMER_360_FINAL c;


