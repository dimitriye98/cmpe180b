-- 1. Best-Selling Products
-- Creating index on SKU in SalesTransactions table for faster retrieval
-- SKIPPED AS JOINING ON PRIMARY KEYS
-- CREATE INDEX idx_sku_sales_transactions ON `SalesDB`.`SalesTransactions` (SKU);

-- Query to retrieve the top 10 best-selling products
SELECT 
    p.Name AS Product_Name,
    SUM(st.Volume) AS Total_Units_Sold
FROM 
    `SalesDB`.`SalesTransactions` st
JOIN 
    `SalesDB`.`Products` p ON st.SKU = p.SKU
GROUP BY 
    st.SKU
ORDER BY 
    Total_Units_Sold DESC
LIMIT 100;


-- 2. Customer Order History
-- Creating index on customer_id in SalesTransactionDetails for fast lookup
CREATE INDEX idx_customer_sales_transaction_details ON `SalesDB`.`SalesTransactionDetails` (Customer_ID);

-- Query to retrieve all orders for a customer, including transaction details
SELECT 
    st.Transaction_ID,
    st.SKU,
    st.Volume,
    st.Unit_Price,
    std.Transaction_Time,
    c.Name AS Customer_Name
FROM 
    `SalesDB`.`SalesTransactionDetails` std
JOIN 
    `SalesDB`.`SalesTransactions` st ON std.Transaction_ID = st.Transaction_ID
JOIN 
    `SalesDB`.`Customers` c ON std.Customer_ID = c.Customer_ID
WHERE 
    c.Customer_ID = 99;  -- Replace '99' with the specific customer ID


-- 3. Product Inventory Levels
-- Index on SKU columns
-- SKIPPED AS PRIMARY KEYS ARE AUTOMATICALLY INDEXED
-- CREATE INDEX idx_inventories_sku ON `SalesDB`.`Inventories`(SKU);
-- CREATE INDEX idx_products_sku ON `SalesDB`.`Products`(SKU);

-- Query to retrieve current stock levels and check for low inventory
SELECT 
    p.SKU,
    p.Name,
    i.Volume AS Current_Stock_Level,
    CASE 
        WHEN i.Volume < 10 THEN 'Low Stock' 
        ELSE 'Sufficient Stock' 
    END AS Stock_Status
FROM 
    `SalesDB`.`Inventories` i
JOIN 
    `SalesDB`.`Products` p ON i.SKU = p.SKU
ORDER BY Stock_Status ASC, SKU ASC;


-- 4. Average Order Value (AOV) Calculation
-- Create index on Transaction_Time in SalesTransactionDetails
-- CREATE INDEX idx_transaction_time_sales_transaction_details ON `SalesDB`.`SalesTransactionDetails` (Transaction_Time);

-- Query to calculate the Average Order Value (AOV) for the past month
SELECT 
    AVG(st.Volume * st.Unit_Price) AS Average_Order_Value
FROM 
    `SalesDB`.`SalesTransactions` st
JOIN 
    `SalesDB`.`SalesTransactionDetails` std ON st.Transaction_ID = std.Transaction_ID
WHERE 
    std.Transaction_Time >= NOW() - INTERVAL 1 MONTH;


-- 5. Product search by properties and manufacturer
-- Create columns manufacturer and category
ALTER TABLE `SalesDB`.`Products`
ADD COLUMN manufacturer VARCHAR(255) AS (Properties->>'$.manufacturer') STORED,
ADD COLUMN category VARCHAR(255) AS (Properties->> '$.category') STORED;

-- Update new columns with data
-- OMITTED AS STORED GENERATED COLUMNS ARE USED
-- UPDATE `SalesDB`.`Products`
-- SET 
--     manufacturer = JSON_UNQUOTE(JSON_EXTRACT(Properties, '$.manufacturer')),
--     category = JSON_UNQUOTE(JSON_EXTRACT(Properties, '$.category'));

-- Create Index on the Manufacturer, Category, and Name
CREATE INDEX idx_product_manufacturer_search ON `SalesDB`.`Products` (manufacturer);
CREATE INDEX idx_product_category_search ON `SalesDB`.`Products` (category);
CREATE INDEX idx_product_name_search ON `SalesDB`.`Products` (Name);
-- Search by properties and manufacturer
SELECT 
    p.SKU,
    p.Name,
    p.manufacturer,
    p.category,
    p.Properties
FROM 
    `SalesDB`.`Products` p
WHERE 
    manufacturer = 'ZenTech'
    AND CAST(JSON_UNQUOTE(JSON_EXTRACT(p.Properties, '$.cores')) AS UNSIGNED) >= 4;

