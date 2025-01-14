DROP TABLE IF EXISTS course_reserves;

CREATE TABLE course_reserves AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'courseListingId')::varchar(36) AS course_listing_id,
    jsonb_extract_path_text(jsonb, 'itemId')::varchar(36) AS item_id,
    jsonb_extract_path_text(jsonb, 'temporaryLoanTypeId')::varchar(36) AS temporary_loan_type_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_reserves;

ALTER TABLE course_reserves ADD PRIMARY KEY (id);

CREATE INDEX ON course_reserves (course_listing_id);

CREATE INDEX ON course_reserves (item_id);

CREATE INDEX ON course_reserves (temporary_loan_type_id);

VACUUM ANALYZE course_reserves;
