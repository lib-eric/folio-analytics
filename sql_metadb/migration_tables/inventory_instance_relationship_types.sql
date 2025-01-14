DROP TABLE IF EXISTS inventory_instance_relationship_types;

CREATE TABLE inventory_instance_relationship_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance_relationship_type;

ALTER TABLE inventory_instance_relationship_types ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_instance_relationship_types (name);

VACUUM ANALYZE inventory_instance_relationship_types;
