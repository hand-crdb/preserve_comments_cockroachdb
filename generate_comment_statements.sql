-- Produces one COMMENT ON … IS … ; statement per row, suitable for
-- copy-paste execution or piping into cockroach sql.
--
-- Identifier quoting  : quote_ident()    wraps each name component in double
--                       quotes and escapes any embedded double quotes, making
--                       the output safe for names that are reserved words,
--                       mixed-case, or contain special characters.
-- Comment text quoting: quote_literal()  wraps the text in single quotes and
--                       doubles any embedded single quotes.

SELECT
    CASE comment_type

        -- 0 ── Database ────────────────────────────────────────────────────────
        WHEN 0 THEN
              'COMMENT ON DATABASE '
            || quote_ident(object_database_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 1 ── Table / View / Sequence ─────────────────────────────────────────
        WHEN 1 THEN
              'COMMENT ON TABLE '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 2 ── Column ──────────────────────────────────────────────────────────
        -- object_name    = parent table name
        -- object_sub_name = column name
        WHEN 2 THEN
              'COMMENT ON COLUMN '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)          || '.'
            || quote_ident(object_sub_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 3 ── Index ───────────────────────────────────────────────────────────
        -- object_name     = parent table name
        -- object_sub_name = index name (separated from the table by @)
        WHEN 3 THEN
              'COMMENT ON INDEX '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)
            || '@'
            || quote_ident(object_sub_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 4 ── Schema ──────────────────────────────────────────────────────────
        WHEN 4 THEN
              'COMMENT ON SCHEMA '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 5 ── Constraint ──────────────────────────────────────────────────────
        -- object_name     = parent table name
        -- object_sub_name = constraint name (precedes ON <table>)
        WHEN 5 THEN
              'COMMENT ON CONSTRAINT '
            || quote_ident(object_sub_name)
            || ' ON '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 6 ── Stored Function ─────────────────────────────────────────────────
        -- Note: if the database contains overloaded functions (same name,
        -- different argument types) the generated statement omits the argument
        -- list and will be ambiguous.  Append the argument-type list manually
        -- when that situation applies.
        WHEN 6 THEN
              'COMMENT ON FUNCTION '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

        -- 7 ── User-Defined Type ───────────────────────────────────────────────
        WHEN 7 THEN
              'COMMENT ON TYPE '
            || quote_ident(object_database_name) || '.'
            || quote_ident(object_schema_name)   || '.'
            || quote_ident(object_name)
            || ' IS '
            || quote_literal(comment_text)
            || ';'

    END  AS comment_sql

FROM  database_object_comments

ORDER BY
    comment_type,
    object_database_name,
    pk_schema_name,    -- STORED computed column: COALESCE(object_schema_name, '')
    object_name,
    pk_sub_name        -- STORED computed column: COALESCE(object_sub_name, '')
;
