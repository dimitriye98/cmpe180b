# Database Testing
## CRUD CHECKS
### CREATE / INSERT

- Good insertion
- expect success
```SQL
insert into Vendors (Vendor_ID, Name, Address)
values (60, "Good Vendor", "Test Address");
```

- Bad insertion: missing ID
- expect failure
```SQL
insert into Vendors (Name, Address)
values ("Bad Vendor", "Test Addr");
```

- Bad insertion: duplicate ID
- expect failure
```SQL
insert into Vendors (Vendor_ID, Name, Address)
values (60, "Duplicate Vendor", "Test Address");
```

### READ
- Read all products
- expect all products
```SQL
select * from Products;
```

- Read valid product SKU
- expect 1 product with SKU = 1
```SQL
select *
from Products
where SKU = 1;
```

- Read invalid product SKU
- expect 0 result.
```SQL
select *
from Products
where SKU = -1;
```

### UPDATE
- Valid Update
- expect success 
```SQL
update PurchaseTransactions
set Volume = Volume + 10
where Transaction_ID = 10 AND SKU = 1;
```

- Invalid Update: unit_price cannot be null
- expect fail
```SQL
update PurchaseTransactions
set Unit_Price = NULL
where Transaction_ID = 10 AND SKU = 1;
```

### DELETE

- Valid delete
- expect success
```SQL
delete from PurchaseTransactions
where Transaction_ID = 10 AND SKU = 1;
```

- Invalid delete
- expect no change
```SQL
delete from PurchaseTransactions
where Transaction_ID = -10 AND SKU = -1;
```

## COMPLEX QUERIES

### Sorting
- Test case: sort the product based on name
- Expected: products returned sorted based on name
``` SQL
select *
from Products
order by Name asc;
```

### Filtering
- Test case: find all products with "Classic" in its name
- Expected: products with "Classic" in its name
``` SQL
select *
from Products
where Name like "%Classic%";
```


## TRANSACTIONS
- Test case: inserting customers with the same ID twice, and then rolling back the entire transaction
- Expected: No change reflected in the database
```SQL
START TRANSACTION;
INSERT INTO Customers (Customer_ID, Name, Address)
VALUES (60000, "Good Customer", "Test Address");
-- Error inserting duplicate address
INSERT INTO Customers (Customer_ID, Name, Address)
VALUES (60000, "Duplicate Customer", "Test Address");
-- Rolling back transaction
ROLLBACK;
```