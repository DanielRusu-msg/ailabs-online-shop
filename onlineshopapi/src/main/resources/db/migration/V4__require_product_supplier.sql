-- Every product must be linked to a supplier. The supplier_id column was added
-- as nullable in V3 so seed data could be backfilled (see local/V3.1); enforce
-- NOT NULL now that every product references a supplier.
ALTER TABLE products
    ALTER COLUMN supplier_id SET NOT NULL;
