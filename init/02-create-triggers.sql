USE `SalesDB`;
-- Update Inventory after purchase
delimiter |
CREATE TRIGGER IF NOT EXISTS purchaseInsert AFTER INSERT ON PurchaseTransactions
    FOR EACH ROW
    BEGIN
        UPDATE Inventories SET Volume = Inventories.Volume + NEW.Volume
        WHERE Inventories.SKU = NEW.SKU;
    END;
|
delimiter ;

-- Update Inventory after sale
delimiter |
CREATE TRIGGER IF NOT EXISTS saleInsert AFTER INSERT ON SalesTransactions
    FOR EACH ROW
    BEGIN
        UPDATE Inventories SET Volume = Inventories.Volume - NEW.Volume
        WHERE Inventories.SKU = NEW.SKU;
    END;
|
delimiter ;

-- Update Inventory after purchase update
delimiter |
CREATE TRIGGER IF NOT EXISTS purchaseUpdate AFTER UPDATE ON PurchaseTransactions
    FOR EACH ROW
    BEGIN
        UPDATE Inventories SET Volume = Inventories.Volume - OLD.Volume + NEW.Volume
        WHERE Inventories.SKU = NEW.SKU;
    END;
|
delimiter ;

-- Update Inventory after sale update
delimiter |
CREATE TRIGGER IF NOT EXISTS saleUpdate AFTER UPDATE ON SalesTransactions
    FOR EACH ROW
    BEGIN
        UPDATE Inventories SET Volume = Inventories.Volume + OLD.Volume - NEW.Volume
        WHERE Inventories.SKU = NEW.SKU;
    END;
|
delimiter ;