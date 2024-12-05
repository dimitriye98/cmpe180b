# Key Queries for the Project
- The queries are SQL commands that should be run in either the MySQL console or other consoles provided by database managers
1. Finding the best selling products:
   - Finds the top 10 best-selling products in the store
```SQL
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
LIMIT 10;
```
2. Find the customer order history
   - Find all previous orders made by a customer
   - If the index was already created in `Readme.md`, skip the first command and use the `SELECT` command only
   - In this example, the order history for customer with ID 1026 is found.
```SQL
-- SKIP THIS IF ALREADY CREATED
-- Creating index on customer_id in SalesTransactionDetails for fast lookup
CREATE INDEX idx_customer_sales_transaction_details ON `SalesDB`.`SalesTransactionDetails` (Customer_ID);
```
```SQL
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
    c.Customer_ID = 1026;  -- Replace '1026' with the specific customer ID
```

1. Checking for low stock items
   - This will return the inventory stock level of every product
   - If a product has less than 10 items available, it will be labeled as such, and be placed at the top of the returned results
   - Otherwise, all products are sorted based on their SKU
```SQL
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
```

1. Finding the average order value
    - Find the average order value for all products sold in the past month
```SQL
-- Query to calculate the Average Order Value (AOV) for the past month
SELECT 
    AVG(st.Volume * st.Unit_Price) AS Average_Order_Value
FROM 
    `SalesDB`.`SalesTransactions` st
JOIN 
    `SalesDB`.`SalesTransactionDetails` std ON st.Transaction_ID = std.Transaction_ID
WHERE 
    std.Transaction_Time >= NOW() - INTERVAL 1 MONTH;
```

1. Searching products by properties and manufacturer
- Filters the products based on a given condition
- In this example, the products are filtered based on the manufacturer name "ZenTech" (which only produces CPUs), and for CPU Products with at least 4 Cores.
- If the generated columns and indices were already created in `Readme.md`, then skip to only running the `SELECT` command at the end.
```SQL
-- SKIP THIS IF ALREADY CREATED
-- Create stored generated columns manufacturer and category
ALTER TABLE `SalesDB`.`Products`
ADD COLUMN manufacturer VARCHAR(255) AS (Properties->>'$.manufacturer') STORED,
ADD COLUMN category VARCHAR(255) AS (Properties->> '$.category') STORED;

-- Create Index on the Manufacturer, Category, and Name
CREATE INDEX idx_product_manufacturer_search ON `SalesDB`.`Products` (manufacturer);
CREATE INDEX idx_product_category_search ON `SalesDB`.`Products` (category);
CREATE INDEX idx_product_name_search ON `SalesDB`.`Products` (Name);
```
```SQL
-- Query to search by properties and manufacturer
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
```