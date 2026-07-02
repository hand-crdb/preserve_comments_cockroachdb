INSERT INTO database_object_comments (
    comment_type, comment_type_name,
    object_database_name, object_schema_name, object_name, object_sub_name,
    table_name, column_name, index_name, schema_name,
    constraint_name, function_name, user_defined_type_name,
    comment_text
)
-- paste the full UNION ALL query here
-- ==========================================================================
-- CockroachDB: All object comments in the current database
-- ==========================================================================
-- system.comments.type values:
--   0 = Database         4 = Schema
--   1 = Table/View/Seq   5 = Constraint
--   2 = Column           6 = Function
--   3 = Index            7 = User-Defined Type
--
-- For type 5 (Constraint) the sub_id holds a CockroachDB-internal constraint
-- ID that cannot be mapped back to a name via system.comments alone, because
-- pg_constraint uses synthetic (hash-based) OIDs.  That branch therefore
-- sources its rows from pg_catalog.pg_description joined with
-- pg_catalog.pg_constraint, which CockroachDB keeps in sync with
-- system.comments via the crdb_internal.kv_catalog_comments backing table.
-- ==========================================================================

  -- ── 0  Database ──────────────────────────────────────────────────────────
  SELECT
      c.type                      AS comment_type,
      'Database'                  AS comment_type_name,
      d.name                      AS object_database_name,
      NULL::STRING                AS object_schema_name,
      d.name                      AS object_name,
      NULL::STRING                AS object_sub_name,
      NULL::STRING                AS table_name,
      NULL::STRING                AS column_name,
      NULL::STRING                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  crdb_internal.databases   AS d  ON d.id = c.object_id
  WHERE c.type = 0
    AND d.name = current_database()

UNION ALL

  -- ── 1  Table / View / Sequence ────────────────────────────────────────────
  SELECT
      c.type                      AS comment_type,
      'Table/View/Sequence'       AS comment_type_name,
      t.database_name             AS object_database_name,
      t.schema_name               AS object_schema_name,
      t.name                      AS object_name,
      NULL::STRING                AS object_sub_name,
      t.name                      AS table_name,
      NULL::STRING                AS column_name,
      NULL::STRING                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  crdb_internal.tables      AS t  ON t.table_id = c.object_id
  WHERE c.type = 1
    AND t.database_name = current_database()
    AND t.drop_time IS NULL

UNION ALL

  -- ── 2  Column ─────────────────────────────────────────────────────────────
  -- object_id = parent table descriptor ID; sub_id = pg_attribute attnum
  SELECT
      c.type                      AS comment_type,
      'Column'                    AS comment_type_name,
      t.database_name             AS object_database_name,
      t.schema_name               AS object_schema_name,
      t.name                      AS object_name,      -- table that owns the column
      a.attname                   AS object_sub_name,  -- the column name
      NULL::STRING                AS table_name,       -- NULL: comment type is Column, not Table
      a.attname                   AS column_name,
      NULL::STRING                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  crdb_internal.tables      AS t   ON  t.table_id         = c.object_id
  JOIN  pg_catalog.pg_attribute   AS a   ON  a.attrelid::INT8   = c.object_id
                                         AND a.attnum::INT8     = c.sub_id
  WHERE c.type = 2
    AND t.database_name = current_database()
    AND t.drop_time IS NULL
    AND a.attnum > 0
    AND NOT a.attisdropped

UNION ALL

  -- ── 3  Index ──────────────────────────────────────────────────────────────
  -- object_id = parent table descriptor ID; sub_id = index ID
  -- crdb_internal.table_indexes uses "descriptor_id" for the table column
  SELECT
      c.type                      AS comment_type,
      'Index'                     AS comment_type_name,
      t.database_name             AS object_database_name,
      t.schema_name               AS object_schema_name,
      t.name                      AS object_name,      -- table that owns the index
      i.index_name                AS object_sub_name,  -- the index name
      NULL::STRING                AS table_name,       -- NULL: comment type is Index, not Table
      NULL::STRING                AS column_name,
      i.index_name                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments               AS c
  JOIN  crdb_internal.tables          AS t  ON  t.table_id        = c.object_id
  JOIN  crdb_internal.table_indexes   AS i  ON  i.descriptor_id   = c.object_id
                                           AND  i.index_id::INT8  = c.sub_id
  WHERE c.type = 3
    AND t.database_name = current_database()
    AND t.drop_time IS NULL

UNION ALL

  -- ── 4  Schema ─────────────────────────────────────────────────────────────
  -- pg_namespace is database-scoped; naturally restricts to current database
  SELECT
      c.type                      AS comment_type,
      'Schema'                    AS comment_type_name,
      current_database()          AS object_database_name,
      n.nspname                   AS object_schema_name,
      n.nspname                   AS object_name,
      NULL::STRING                AS object_sub_name,
      NULL::STRING                AS table_name,
      NULL::STRING                AS column_name,
      NULL::STRING                AS index_name,
      n.nspname                   AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  pg_catalog.pg_namespace   AS n  ON n.oid::INT8 = c.object_id
  WHERE c.type = 4

UNION ALL

  -- ── 5  Constraint ─────────────────────────────────────────────────────────
  -- pg_constraint uses a synthetic hash-based OID that cannot be reverse-mapped
  -- from system.comments.sub_id in SQL.  Use pg_description (which CockroachDB
  -- populates from system.comments via kv_catalog_comments) joined with
  -- pg_constraint to obtain the constraint name and its owning table.
  -- pg_description is database-scoped; the crdb_internal.tables join supplies
  -- the database-name / schema-name context and the current-database filter.
  SELECT
      5::INT8                          AS comment_type,
      'Constraint'                     AS comment_type_name,
      t.database_name                  AS object_database_name,
      t.schema_name                    AS object_schema_name,
      t.name                           AS object_name,     -- table that owns the constraint
      con.conname                      AS object_sub_name, -- the constraint name
      NULL::STRING                     AS table_name,      -- NULL: comment type is Constraint, not Table
      NULL::STRING                     AS column_name,
      NULL::STRING                     AS index_name,
      NULL::STRING                     AS schema_name,
      con.conname                      AS constraint_name,
      NULL::STRING                     AS function_name,
      NULL::STRING                     AS user_defined_type_name,
      pgd.description                  AS comment_text
  FROM  pg_catalog.pg_description      AS pgd
  JOIN  pg_catalog.pg_constraint       AS con  ON  con.oid = pgd.objoid
  JOIN  crdb_internal.tables           AS t    ON  t.table_id = con.conrelid::INT8
  WHERE pgd.classoid = 'pg_constraint'::REGCLASS
    AND t.database_name = current_database()
    AND t.drop_time IS NULL

UNION ALL

  -- ── 6  Stored Function ────────────────────────────────────────────────────
  -- pg_proc is database-scoped; naturally restricts to current database
  SELECT
      c.type                      AS comment_type,
      'Function'                  AS comment_type_name,
      current_database()          AS object_database_name,
      n.nspname                   AS object_schema_name,
      p.proname                   AS object_name,
      NULL::STRING                AS object_sub_name,
      NULL::STRING                AS table_name,
      NULL::STRING                AS column_name,
      NULL::STRING                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      p.proname                   AS function_name,
      NULL::STRING                AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  pg_catalog.pg_proc        AS p  ON p.oid::INT8 = c.object_id
  JOIN  pg_catalog.pg_namespace   AS n  ON n.oid = p.pronamespace
  WHERE c.type = 6

UNION ALL

  -- ── 7  User-Defined Type ──────────────────────────────────────────────────
  -- pg_type is database-scoped; naturally restricts to current database
  SELECT
      c.type                      AS comment_type,
      'User-Defined Type'         AS comment_type_name,
      current_database()          AS object_database_name,
      n.nspname                   AS object_schema_name,
      tp.typname                  AS object_name,
      NULL::STRING                AS object_sub_name,
      NULL::STRING                AS table_name,
      NULL::STRING                AS column_name,
      NULL::STRING                AS index_name,
      NULL::STRING                AS schema_name,
      NULL::STRING                AS constraint_name,
      NULL::STRING                AS function_name,
      tp.typname                  AS user_defined_type_name,
      c.comment                   AS comment_text
  FROM  system.comments           AS c
  JOIN  pg_catalog.pg_type        AS tp ON tp.oid::INT8 = c.object_id
  JOIN  pg_catalog.pg_namespace   AS n  ON n.oid = tp.typnamespace
  WHERE c.type = 7

ORDER BY
    comment_type,
    object_database_name,
    object_schema_name,
    object_name,
    object_sub_name
;
