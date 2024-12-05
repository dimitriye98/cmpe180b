-- CRUD CHECKS

-- CREATE / INSERT

-- Good insertion; expect success
insert into Vendors (Vendor_ID, Name, Address)
values (60, "Good Vendor", "Test Address");

-- Bad insertion: missing ID; expect failure
insert into Vendors (Name, Address)
values ("Bad Vendor", "Test Addr");

-- Bad insertion: duplicate ID; expect failure
insert into Vendors (Vendor_ID, Name, Address)
values (60, "Duplicate Vendor", "Test Address");

-- READ

-- Read all products; expect all products
select * from Products;

-- Read valid product SKU; expect 1 product with SKU 1
select *
from Products
where SKU = 1;

-- Read invalid product SKU; expect 0 result.
select *
from Products
where SKU = -1;

-- UPDATE

-- Valid Update; expect success
update PurchaseTransactions
set Volume = Volume + 10
where Transaction_ID = 10 AND SKU = 1;

-- Invalid Update: unit_price cannot be null; expect fail
update PurchaseTransactions
set Unit_Price = NULL
where Transaction_ID = 10 AND SKU = 1;

-- DELETE

-- Valid delete; expect success
delete from PurchaseTransactions
where Transaction_ID = 10 AND SKU = 1;

-- Invalid delete; expect no change
delete from PurchaseTransactions
where Transaction_ID = -10 AND SKU = -1;


-- COMPLEX QUERIES

-- Sorting; expect products returned sorted based on name
select *
from Products
order by Name asc;

-- Filtering
select *
from Products
where Name like "%Classic%";


-- TRANSACTIONS

-- Transaction breaking unique constraint
-- Expect the changes to be rolled back; no change reflected in the database
START TRANSACTION;
INSERT INTO Customers (Customer_ID, Name, Address)
VALUES (60000, "Good Customer", "Test Address");
-- Error inserting duplicate address
INSERT INTO Customers (Customer_ID, Name, Address)
VALUES (60000, "Duplicate Customer", "Test Address");
-- Rolling back transaction
ROLLBACK;

COMMIT;

-- Concurrency check: 2 Transactions on the same product
-- Expect T2 to be blocked until T1 commits or rolls back.

--TRANSACTION T1
BEGIN;
-- Lock the row so that no other transactions can make changes
SELECT * FROM Inventories WHERE SKU = 1 FOR UPDATE;
INSERT INTO SalesTransactions (Transaction_ID, SKU, Volume, Unit_price)
VALUES (5000, 1, 10, 50.00);


-- TRANSACTION T2
BEGIN;
-- Attempting to lock the same row in the transaction
-- Should be blocked until T1 commits or rolls back
SELECT * FROM Inventories WHERE SKU = 1 FOR UPDATE;
INSERT INTO PurchaseTransactions(Transaction_ID, SKU, Volume, Unit_price)
VALUES (5001, 1, 15, 50.00);

--TRANSACTION T3
BEGIN;
-- Lock the row so that no other transactions can make changes
-- Should be able to continue without issue
SELECT * FROM Inventories WHERE SKU = 2 FOR UPDATE;
INSERT INTO SalesTransactions(Transaction_ID, SKU, Volume, Unit_price)
VALUES (5002, 2, 10, 50.00);