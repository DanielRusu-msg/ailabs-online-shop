INSERT INTO suppliers (id, name, contact_email, phone)
VALUES ('b0550001-0000-0000-0000-000000000001', 'TechGlobal Distribution', 'sales@techglobal.example', '+40 264 111 222'),
       ('b0550002-0000-0000-0000-000000000002', 'UrbanWear Supply Co.', 'orders@urbanwear.example', '+40 21 333 444'),
       ('b0550003-0000-0000-0000-000000000003', 'HomeFields Trading', 'contact@homefields.example', '+40 256 555 666');

-- Backfill the seeded products with a supplier before V4 enforces NOT NULL.
UPDATE products SET supplier_id = 'b0550001-0000-0000-0000-000000000001'
WHERE id IN ('fade0001-0000-0000-0000-000000000001',
             'fade0002-0000-0000-0000-000000000002',
             'fade0003-0000-0000-0000-000000000003',
             'fade0009-0000-0000-0000-000000000009',
             'fade000a-0000-0000-0000-00000000000a');

UPDATE products SET supplier_id = 'b0550002-0000-0000-0000-000000000002'
WHERE id IN ('fade0004-0000-0000-0000-000000000004',
             'fade0005-0000-0000-0000-000000000005',
             'fade0008-0000-0000-0000-000000000008');

UPDATE products SET supplier_id = 'b0550003-0000-0000-0000-000000000003'
WHERE id IN ('fade0006-0000-0000-0000-000000000006',
             'fade0007-0000-0000-0000-000000000007');
