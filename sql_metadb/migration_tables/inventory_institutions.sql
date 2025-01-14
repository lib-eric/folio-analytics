DROP TABLE IF EXISTS inventory_institutions;

CREATE TABLE inventory_institutions AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.locinstitution;

ALTER TABLE inventory_institutions ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_institutions (code);

CREATE INDEX ON inventory_institutions (name);

VACUUM ANALYZE inventory_institutions;
