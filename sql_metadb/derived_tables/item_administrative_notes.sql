-- This derived table extracts administrative notes from the item record.
DROP TABLE IF EXISTS item_administrative_notes;

CREATE TABLE item_administrative_notes AS
SELECT
    it.id AS item_id,
    it.hrid AS item_hrid,
    it.holdings_record_id AS holdings_record_id,
    admin_notes.jsonb #>> '{}' AS administrative_note,
    admin_notes.ordinality AS administrative_note_ordinality
FROM
    folio_inventory.item AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'administrativeNotes')) WITH ORDINALITY AS admin_notes (jsonb)
    LEFT JOIN folio_inventory.item__t AS it ON i.id = it.id;

CREATE INDEX ON item_administrative_notes (item_id);

CREATE INDEX ON item_administrative_notes (item_hrid);

CREATE INDEX ON item_administrative_notes (holdings_record_id);

CREATE INDEX ON item_administrative_notes (administrative_note);

CREATE INDEX ON item_administrative_notes (administrative_note_ordinality);

VACUUM ANALYZE item_administrative_notes;