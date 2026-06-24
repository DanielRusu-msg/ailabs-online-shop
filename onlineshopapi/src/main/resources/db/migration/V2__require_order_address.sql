-- Orders must carry a delivery address. Backfill any legacy rows that were
-- created before the address was collected, then enforce NOT NULL so the
-- read path (OrderMapper.toDto) can map the address unconditionally.
UPDATE orders
SET country        = COALESCE(country, 'Unknown'),
    city           = COALESCE(city, 'Unknown'),
    county         = COALESCE(county, 'Unknown'),
    street_address = COALESCE(street_address, 'Unknown')
WHERE country IS NULL
   OR city IS NULL
   OR county IS NULL
   OR street_address IS NULL;

ALTER TABLE orders
    ALTER COLUMN country SET NOT NULL,
    ALTER COLUMN city SET NOT NULL,
    ALTER COLUMN county SET NOT NULL,
    ALTER COLUMN street_address SET NOT NULL;
