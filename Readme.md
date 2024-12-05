# SalesDB
## Introduction
- This Project aims to create a MySQL database that can be used to track purchase & sales data for a web-based store
  - The database supports products with a diverse range of categories & properties
  - Currently, the databse is populated with electronics and clothings
- The database allows for analytical tasks such as finding the best-selling products, tracking customer order history, and more.
- Developed for SJSU CMPE 180B semester project.
- Note: all commands should be run in a shell from the root directory of the project except for SQL statements, which should be done in the MySQL console
## Project Setup
### Initial setup:
- Install docker on the machine
- Initialize the docker image with:
```
docker build --progress=plain -t salesdb .
docker network create -d bridge salesdb
docker run -p 3307:3306 -d --name salesdb -e MYSQL_ROOT_PASSWORD=root --network salesdb -v DIRECTORY_TO_STORE_DB_FILES:/var/lib/mysql salesdb
```
- Note: this maps the mysql database to port 3307 on the local host to avoid clashing with local mysql installations

### Connect to DB with:
```
docker run -it --rm --network salesdb mysql mysql -h salesdb -u root -p
```

### Add triggers
- NOTE: Triggers are automatically loaded into the database when docker image is built
- To manually insert the triggers:
  - Load `/init/02-create-triggers.sql` into the database
```
docker exec -i salesdb mysql -uroot -proot < ./init/02-create-triggers.sql
```

### Populate the database:
- NOTE: The database is automatically populated when docker image is built
- To manually populate the database:
  - Load each table individually into the database
```
docker exec -i salesdb mysql -uroot -proot < ./init/01-populate-products.sql
docker exec -i salesdb mysql -uroot -proot < ./init/01-populate-customers.sql
docker exec -i salesdb mysql -uroot -proot < ./init/01-populate-vendors.sql
docker exec -i salesdb mysql -uroot -proot < ./init/02-populate-inventories.sql
docker exec -i salesdb mysql -uroot -proot < ./init/02-populate-selling-prices.sql
docker exec -i salesdb mysql -uroot -proot < ./init/03-populate-purchase-transaction.sql
docker exec -i salesdb mysql -uroot -proot < ./init/03-populate-sale-transaction.sql
docker exec -i salesdb mysql -uroot -proot < ./init/04-populate-purchase-transaction-detail.sql
docker exec -i salesdb mysql -uroot -proot < ./init/04-populate-sale-transaction-detail.sql
```

## Database Optimization
### Adding Indexes and Generated Columns
- Most operations use PRIMARY index, which is automatically done by InnoDB
- Indexes are created for 2 key queries:
  - Finding customer order history:
    - Index is placed on Customer_ID of SalesTransactionDetails table
  - Filtering Products based on manufacturer, category, and name
    - Generated Columns are created for manufacturer and category
    - Indices are placed on manufacturer, category, and name of Products table
```SQL
-- FOR CUSTOMER ORDER HISTORY
-- Creating index on customer_id in SalesTransactionDetails for fast lookup
CREATE INDEX idx_customer_sales_transaction_details ON `SalesDB`.`SalesTransactionDetails` (Customer_ID);

-- FOR PRODUCT FILTERING
-- Create stored generated columns manufacturer and category
ALTER TABLE `SalesDB`.`Products`
ADD COLUMN manufacturer VARCHAR(255) AS (Properties->>'$.manufacturer') STORED,
ADD COLUMN category VARCHAR(255) AS (Properties->> '$.category') STORED;

-- Create Index on the Manufacturer, Category, and Name
CREATE INDEX idx_product_manufacturer_search ON `SalesDB`.`Products` (manufacturer);
CREATE INDEX idx_product_category_search ON `SalesDB`.`Products` (category);
CREATE INDEX idx_product_name_search ON `SalesDB`.`Products` (Name);
```

### Optimization results
```
TODO
```

## Executing Queries
- See `queries.md` for details

## Test Cases
- See `database_test.md` for details

## Isolation & Concurrency control
- The database uses MySQL InnoDB's default isolation level of REPEATABLE READ
  - This isolation level prevents dirty read and non-repeatable reads
- For changes made to purchase and sales transaction logs, lock the affected rows in the Inventories table to prevent lost updates to the inventory stock
```SQL
-- SQL COMMAND, run in a SQL console in a transaction before changing purchases/sales transaction tables
SELECT * FROM Inventories WHERE SKU = 1 FOR UPDATE;
```
- MySQL automatically handles blocks and deadlocks by rolling back transactions to resolve them

## Backup & Recovery
- Performed with mysqldump command
- To back up directly from the docker image:
  - This will create a `dump.sql` file in the current directory
```
docker exec -i salesdb mysqldump -uroot -proot --databases SalesDB --skip-comments > ./dump.sql
```
- It is recommended that the databse is backed up at least twice a week in production
  - Depending on store traffic, may need to increase the frequency to once a day or more
- Preferred way of recovery: rebuild the docker image
  1. Remove the files in /init folder and replace with `dump.sql`
  2. Remove the created volumes and images in docker
  3. Call the 3 steps in initial setup to rebuild and docker image and recreate the container

- Alternative way of recovery: importing the dumpfile through docker CLI
  - Make sure that `dump.sql` is in the current directory
  - May lead to errors suck as `socket.error: [Errno 32] Broken pipe` and `ValueError: file descriptor cannot be a negative integer (-1)`
```
docker exec -i salesdb mysql -uroot -proot < dump.sql
```
