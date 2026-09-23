-- 1. Transaction staging
-- Preserves transaction-level fields used throughout the analysis.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_TRANSACTIONS AS
SELECT
    HOUSEHOLD_KEY,
    BASKET_ID,
    DAY,
    PRODUCT_ID,
    QUANTITY,
    SALES_VALUE,
    STORE_ID,
    RETAIL_DISC,
    TRANS_TIME,
    WEEK_NO,
    COUPON_DISC,
    COUPON_MATCH_DISC
FROM CUSTOMER_ANALYTICS.RAW.TRANSACTION_DATA;

-- 2. Product staging
-- Preserves raw product attributes and creates reporting-friendly
-- category fields while retaining missing-category information.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_PRODUCTS AS
SELECT
    PRODUCT_ID,
    MANUFACTURER,
    DEPARTMENT,
    BRAND,
    COMMODITY_DESC,
    SUB_COMMODITY_DESC,
    CURR_SIZE_OF_PRODUCT,

    COALESCE(
        NULLIF(TRIM(DEPARTMENT), ''),
        'UNKNOWN'
    ) AS DEPARTMENT_REPORTING,

    COALESCE(
        NULLIF(TRIM(COMMODITY_DESC), ''),
        'UNKNOWN'
    ) AS COMMODITY_REPORTING,

    COALESCE(
        NULLIF(TRIM(SUB_COMMODITY_DESC), ''),
        'UNKNOWN'
    ) AS SUB_COMMODITY_REPORTING,

    IFF(
        DEPARTMENT IS NULL
        OR TRIM(DEPARTMENT) = ''
        OR COMMODITY_DESC IS NULL
        OR TRIM(COMMODITY_DESC) = '',
        TRUE,
        FALSE
    ) AS IS_CATEGORY_MISSING

FROM CUSTOMER_ANALYTICS.RAW.PRODUCT;

-- 3. Household demographic staging
-- Cleans demographic fields and creates an ordered income band.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_HOUSEHOLDS AS
SELECT
    HOUSEHOLD_KEY,
    AGE_DESC,

    CASE
        WHEN MARITAL_STATUS_CODE = 'A' THEN 'Married'
        WHEN MARITAL_STATUS_CODE = 'B' THEN 'Single'
        ELSE 'Unknown'
    END AS MARITAL_STATUS,

    INCOME_DESC,

    CASE INCOME_DESC
        WHEN 'Under 15K' THEN 1
        WHEN '15-24K' THEN 2
        WHEN '25-34K' THEN 3
        WHEN '35-49K' THEN 4
        WHEN '50-74K' THEN 5
        WHEN '75-99K' THEN 6
        WHEN '100-124K' THEN 7
        WHEN '125-149K' THEN 8
        WHEN '150-174K' THEN 9
        WHEN '175-199K' THEN 10
        WHEN '200-249K' THEN 11
        WHEN '250K+' THEN 12
    END AS INCOME_BAND_ORDER,

    HOMEOWNER_DESC,
    HH_COMP_DESC,
    HOUSEHOLD_SIZE_DESC,
    KID_CATEGORY_DESC

FROM CUSTOMER_ANALYTICS.RAW.HH_DEMOGRAPHIC;

-- 4. Campaign staging
-- Standardises campaign type and calculates campaign duration.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_CAMPAIGNS AS
SELECT
    CAMPAIGN,
    DESCRIPTION AS CAMPAIGN_TYPE,
    START_DAY,
    END_DAY,
    END_DAY - START_DAY + 1 AS CAMPAIGN_DURATION_DAYS
FROM CUSTOMER_ANALYTICS.RAW.CAMPAIGN_DESC;


-- 5. Campaign-household assignment staging
-- Enriches household campaign assignments with campaign metadata.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_CAMPAIGN_HOUSEHOLDS AS

SELECT
    ct.HOUSEHOLD_KEY,
    ct.CAMPAIGN,
    c.CAMPAIGN_TYPE,
    c.START_DAY,
    c.END_DAY,
    c.CAMPAIGN_DURATION_DAYS

FROM CUSTOMER_ANALYTICS.RAW.CAMPAIGN_TABLE ct

LEFT JOIN CUSTOMER_ANALYTICS.STAGING.STG_CAMPAIGNS c
    ON ct.CAMPAIGN = c.CAMPAIGN;

-- 6. Coupon staging
-- Links coupons with campaign and product information.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_COUPONS AS

SELECT
    c.COUPON_UPC,
    c.PRODUCT_ID,
    c.CAMPAIGN,

    camp.CAMPAIGN_TYPE,
    camp.START_DAY,
    camp.END_DAY,

    p.DEPARTMENT,
    p.COMMODITY_DESC,
    p.SUB_COMMODITY_DESC,
    p.BRAND,

    IFF(
        p.PRODUCT_ID IS NULL,
        TRUE,
        FALSE
    ) AS IS_PRODUCT_UNMATCHED

FROM CUSTOMER_ANALYTICS.RAW.COUPON c

LEFT JOIN CUSTOMER_ANALYTICS.STAGING.STG_CAMPAIGNS camp
    ON c.CAMPAIGN = camp.CAMPAIGN

LEFT JOIN CUSTOMER_ANALYTICS.STAGING.STG_PRODUCTS p
    ON c.PRODUCT_ID = p.PRODUCT_ID;

-- 7. Coupon redemption staging
-- Enriches coupon redemptions with campaign timing information
-- and identifies whether redemption occurred during the campaign.

CREATE OR REPLACE TABLE CUSTOMER_ANALYTICS.STAGING.STG_COUPON_REDEMPTIONS AS

SELECT
    r.HOUSEHOLD_KEY,
    r.DAY AS REDEMPTION_DAY,
    r.COUPON_UPC,
    r.CAMPAIGN,

    c.CAMPAIGN_TYPE,
    c.START_DAY,
    c.END_DAY,
    c.CAMPAIGN_DURATION_DAYS,

    IFF(
        r.DAY BETWEEN c.START_DAY AND c.END_DAY,
        TRUE,
        FALSE
    ) AS REDEEMED_DURING_CAMPAIGN

FROM CUSTOMER_ANALYTICS.RAW.COUPON_REDEMPT r

LEFT JOIN CUSTOMER_ANALYTICS.STAGING.STG_CAMPAIGNS c
    ON r.CAMPAIGN = c.CAMPAIGN;