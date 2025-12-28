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
