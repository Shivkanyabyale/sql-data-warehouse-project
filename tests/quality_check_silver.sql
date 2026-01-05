/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

-- For Cust table
-- check for nulls or duplicates in primary key
-- Expections No result 

SELECT 
cst_id, COUNT(*)
FROM bronze.crm_cst_info
GROUP BY cst_id
HAVING COUNT(*)>1;


-- Check for unwanted spaces 
-- Expected no result 

SELECT cst_lastname
FROM bronze.crm_cst_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistancy


SELECT DISTINCT cst_gndr
FROM bronze.crm_cst_info;

SELECT DISTINCT cst_material_status
FROM bronze.crm_cst_info;


-- for Prod Table 
-- check for nulls or duplicates in primary key
-- Expections No result 

SELECT 
prod_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL 

-- Check for unwanted spaces 
-- Expected no result 
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check NULLs or Negative Numbers 
-- Expected no result 

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

--Data Standardizaton & Consistancy 
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

--Check for invalid date and order 
SELECT * 
FROM bronze.crm_prd_info
where prd_end_dt < prd_start_dt

-- Check for invalide dates 
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8

--if dates are within the boundries 
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > 20500101
OR sls_order_dt < 19000101

--Invalide date orders 
SELECT 
* 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check Data Consistancy between sales ,Quantity & Price 
-- Sales= Quantity* Price
--Values must not be NULL, Zero or Negative 

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details 
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR  sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales , sls_quantity, sls_price

--Identify out of range dates 
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate > GETDATE()
