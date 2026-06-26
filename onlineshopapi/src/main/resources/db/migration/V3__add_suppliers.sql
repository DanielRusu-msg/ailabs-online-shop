CREATE TABLE suppliers
(
    id            UUID         PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone         VARCHAR(50)
);

-- Add the supplier link as nullable first so existing rows can be backfilled
-- (the local seed data is populated before this migration runs). A follow-up
-- migration (V4) enforces NOT NULL once every product references a supplier.
ALTER TABLE products
    ADD COLUMN supplier_id UUID REFERENCES suppliers (id);
