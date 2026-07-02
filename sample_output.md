# Sample Output

```
$ ./demo_preserve_comments.sh 

DEMO START

🚀 [1/3] Start a local 3-node CockroachDB cluster...

🛠️  Start the first node

Next command:
------------

cockroach start \
  --insecure \
  --store=node1,ballast-size=0 \
  --listen-addr=localhost:26257 \
  --http-addr=localhost:8080 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background

⏸️   Press [Enter] to execute this step...

---Running
*
* WARNING: ALL SECURITY CONTROLS HAVE BEEN DISABLED!
* 
* This mode is intended for non-production testing only.
* 
* In this mode:
* - Your cluster is open to any client that can access localhost.
* - Intruders with access to your machine or network can observe client-server traffic.
* - Intruders can log in without password and read or write any data in the cluster.
* - Intruders can consume all your server's resources and cause unavailability.
*
*
* INFO: To start a secure server without mandating TLS for clients,
* consider --accept-sql-without-tls instead. For other options, see:
* 
* - https://go.crdb.dev/issue-v/53404/v25.4
* - https://www.cockroachlabs.com/docs/v25.4/secure-a-cluster.html
*
*
* WARNING: Running a server without --sql-addr, with a combined RPC/SQL listener, is deprecated.
* This feature will be removed in a later version of CockroachDB.
*
*
* INFO: initial startup completed.
* Node will now attempt to join a running cluster, or wait for `cockroach init`.
* Client connections will be accepted after this completes successfully.
* Check the log file(s) for progress. 
*
---Done

✅   Press [Enter] to continue to the next step...

🚀 [2/3] Start a local 3-node CockroachDB cluster...

🛠️  Start the second node

Next command:
------------

cockroach start \
  --insecure \
  --store=node2,ballast-size=0 \
  --listen-addr=localhost:26258 \
  --http-addr=localhost:8081 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background

⏸️   Press [Enter] to execute this step...

---Running
*
* WARNING: ALL SECURITY CONTROLS HAVE BEEN DISABLED!
* 
* This mode is intended for non-production testing only.
* 
* In this mode:
* - Your cluster is open to any client that can access localhost.
* - Intruders with access to your machine or network can observe client-server traffic.
* - Intruders can log in without password and read or write any data in the cluster.
* - Intruders can consume all your server's resources and cause unavailability.
*
*
* INFO: To start a secure server without mandating TLS for clients,
* consider --accept-sql-without-tls instead. For other options, see:
* 
* - https://go.crdb.dev/issue-v/53404/v25.4
* - https://www.cockroachlabs.com/docs/v25.4/secure-a-cluster.html
*
*
* WARNING: Running a server without --sql-addr, with a combined RPC/SQL listener, is deprecated.
* This feature will be removed in a later version of CockroachDB.
*
*
* INFO: initial startup completed.
* Node will now attempt to join a running cluster, or wait for `cockroach init`.
* Client connections will be accepted after this completes successfully.
* Check the log file(s) for progress. 
*
---Done

✅   Press [Enter] to continue to the next step...

🚀 [3/3] Start a local 3-node CockroachDB cluster...

🛠️  Start the third node

Next command:
------------

cockroach start \
  --insecure \
  --store=node3,ballast-size=0 \
  --listen-addr=localhost:26259 \
  --http-addr=localhost:8082 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background

⏸️   Press [Enter] to execute this step...

---Running
*
* WARNING: ALL SECURITY CONTROLS HAVE BEEN DISABLED!
* 
* This mode is intended for non-production testing only.
* 
* In this mode:
* - Your cluster is open to any client that can access localhost.
* - Intruders with access to your machine or network can observe client-server traffic.
* - Intruders can log in without password and read or write any data in the cluster.
* - Intruders can consume all your server's resources and cause unavailability.
*
*
* INFO: To start a secure server without mandating TLS for clients,
* consider --accept-sql-without-tls instead. For other options, see:
* 
* - https://go.crdb.dev/issue-v/53404/v25.4
* - https://www.cockroachlabs.com/docs/v25.4/secure-a-cluster.html
*
*
* WARNING: Running a server without --sql-addr, with a combined RPC/SQL listener, is deprecated.
* This feature will be removed in a later version of CockroachDB.
*
*
* INFO: initial startup completed.
* Node will now attempt to join a running cluster, or wait for `cockroach init`.
* Client connections will be accepted after this completes successfully.
* Check the log file(s) for progress. 
*
---Done

✅   Press [Enter] to continue to the next step...

🚀 [4/3] Start a local 3-node CockroachDB cluster...

🛠️  Initialize the cluster

Next command:
------------

cockroach init --insecure --host=localhost:26257

⏸️   Press [Enter] to execute this step...

---Running
Cluster successfully initialized
---Done

✅   Press [Enter] to continue to the next step...

🚀 [5/3] Start a local 3-node CockroachDB cluster...

🛠️  Show the comments on all database objects

Next command:
------------

cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 46ms

  type | object_id | sub_id | comment
-------+-----------+--------+----------
(0 rows)

Time: 107ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [6/3] Set up the demo schema with comments on database objects...

🛠️  Load the schema

Next command:
------------

cockroach sql --insecure --echo-sql -f comment_test_setup.sql

⏸️   Press [Enter] to execute this step...

---Running
> CREATE DATABASE IF NOT EXISTS comment_test;
CREATE DATABASE

Time: 120ms

> COMMENT ON DATABASE comment_test
    IS '(database) Scratch database used to demonstrate all eight CockroachDB comment types.';
COMMENT ON DATABASE

Time: 72ms

> USE comment_test;
SET

Time: 47ms

> CREATE SCHEMA IF NOT EXISTS inventory;
CREATE SCHEMA

Time: 96ms

> COMMENT ON SCHEMA inventory
    IS '(schema) Contains all tables, types, functions, and supporting objects for warehouse inventory management.';
COMMENT ON SCHEMA

Time: 21ms

> CREATE TYPE IF NOT EXISTS inventory.condition AS ENUM (
    'new',
    'used',
    'refurbished',
    'damaged'
);
CREATE TYPE

Time: 78ms

> COMMENT ON TYPE inventory.condition
    IS '(type) Physical condition of a product unit when it is received into the warehouse.';
COMMENT ON TYPE

Time: 66ms

> CREATE TABLE IF NOT EXISTS inventory.products (
    product_id  INT8                NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    sku         STRING(50)          NOT NULL,
    name        STRING(200)         NOT NULL,
    unit_price  DECIMAL(12,2)       NOT NULL,
    condition   inventory.condition NOT NULL DEFAULT 'new',
    is_active   BOOL                NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ         NOT NULL DEFAULT now(),

    CONSTRAINT products_pkey       PRIMARY KEY (product_id),
    CONSTRAINT products_sku_uniq   UNIQUE      (sku),
    CONSTRAINT chk_positive_price  CHECK       (unit_price > 0)
);
NOTICE: using sequential values in a primary key does not perform as well as using random UUIDs. See https://www.cockroachlabs.com/docs/v25.4/serial.html
CREATE TABLE

Time: 440ms

> COMMENT ON TABLE inventory.products
    IS '(table) Master catalogue of every product stocked in the warehouse; one row per distinct SKU.';
COMMENT ON TABLE

Time: 16ms

> COMMENT ON COLUMN inventory.products.sku
    IS '(column) Supplier-assigned stock-keeping unit code.  Must be globally unique across all suppliers.';
COMMENT ON COLUMN

Time: 67ms

> COMMENT ON CONSTRAINT chk_positive_price ON inventory.products
    IS '(constraint) Every stocked item must carry a positive list price; complimentary items are handled through a separate promotions workflow, not a zero price.';
COMMENT ON CONSTRAINT

Time: 37ms

> CREATE INDEX IF NOT EXISTS idx_products_name
    ON inventory.products (name);
CREATE INDEX

Time: 2.118s

> COMMENT ON INDEX inventory.products@idx_products_name
    IS '(index) Supports fast product-name searches and ORDER BY name queries across the full catalogue.';
COMMENT ON INDEX

Time: 28ms

> CREATE VIEW IF NOT EXISTS inventory.active_products AS
    SELECT  product_id,
            sku,
            name,
            unit_price,
            condition
    FROM    inventory.products
    WHERE   is_active = TRUE;
CREATE VIEW

Time: 493ms

> CREATE SEQUENCE IF NOT EXISTS inventory.reorder_request_seq
    START WITH 1
    INCREMENT BY 1;
CREATE SEQUENCE

Time: 134ms

> CREATE OR REPLACE FUNCTION inventory.discounted_price(list_price DECIMAL, discount_pct DECIMAL)
    RETURNS     DECIMAL
    LANGUAGE    SQL
    IMMUTABLE
AS $$
    SELECT ROUND(list_price * (1 - discount_pct / 100.0), 2)
$$;
CREATE FUNCTION

Time: 391ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [7/3] Set up the demo schema with comments on database objects...

🛠️  Show the comments on all database objects

Next command:
------------

cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 1ms

  type | object_id | sub_id |                                                                           comment
-------+-----------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------------------
     0 |       104 |      0 | (database) Scratch database used to demonstrate all eight CockroachDB comment types.
     1 |       109 |      0 | (table) Master catalogue of every product stocked in the warehouse; one row per distinct SKU.
     2 |       109 |      2 | (column) Supplier-assigned stock-keeping unit code.  Must be globally unique across all suppliers.
     3 |       109 |      3 | (index) Supports fast product-name searches and ORDER BY name queries across the full catalogue.
     4 |       106 |      0 | (schema) Contains all tables, types, functions, and supporting objects for warehouse inventory management.
     5 |       109 |      3 | (constraint) Every stocked item must carry a positive list price; complimentary items are handled through a separate promotions workflow, not a zero price.
     7 |       107 |      0 | (type) Physical condition of a product unit when it is received into the warehouse.
(7 rows)

Time: 4ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [8/3] Save the comments to a CSV file...

🛠️  Save the comments

Next command:
------------

cockroach sql -d comment_test --insecure --echo-sql -f show_comments_all_objects.sql --format csv | \
   tail -n +2 > comments.csv

⏸️   Press [Enter] to execute this step...

---Running
> SET allow_unsafe_internals = true;
> SELECT
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
---Done

✅   Press [Enter] to continue to the next step...

🚀 [9/3] Save the comments to a CSV file...

🛠️  Look at the saved comments

Next command:
------------

  cat comments.csv

⏸️   Press [Enter] to execute this step...

---Running
comment_type,comment_type_name,object_database_name,object_schema_name,object_name,object_sub_name,table_name,column_name,index_name,schema_name,constraint_name,function_name,user_defined_type_name,comment_text
0,Database,comment_test,NULL,comment_test,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,(database) Scratch database used to demonstrate all eight CockroachDB comment types.
1,Table/View/Sequence,comment_test,inventory,products,NULL,products,NULL,NULL,NULL,NULL,NULL,NULL,(table) Master catalogue of every product stocked in the warehouse; one row per distinct SKU.
2,Column,comment_test,inventory,products,sku,NULL,sku,NULL,NULL,NULL,NULL,NULL,(column) Supplier-assigned stock-keeping unit code.  Must be globally unique across all suppliers.
3,Index,comment_test,inventory,products,idx_products_name,NULL,NULL,idx_products_name,NULL,NULL,NULL,NULL,(index) Supports fast product-name searches and ORDER BY name queries across the full catalogue.
4,Schema,comment_test,inventory,inventory,NULL,NULL,NULL,NULL,inventory,NULL,NULL,NULL,"(schema) Contains all tables, types, functions, and supporting objects for warehouse inventory management."
5,Constraint,comment_test,inventory,products,chk_positive_price,NULL,NULL,NULL,NULL,chk_positive_price,NULL,NULL,"(constraint) Every stocked item must carry a positive list price; complimentary items are handled through a separate promotions workflow, not a zero price."
---Done

✅   Press [Enter] to continue to the next step...

🚀 [10/3] Create the golden master backup...

🛠️  Backup to a local directory

Next command:
------------

cockroach sql --insecure -e "BACKUP DATABASE comment_test INTO 'nodelocal://1/comments_test_backup'"

⏸️   Press [Enter] to execute this step...

---Running
        job_id        |  status   | fraction_completed | rows
----------------------+-----------+--------------------+-------
  1189339636647002113 | succeeded |                  1 |    2
(1 row)

Time: 1.178s

---Done

✅   Press [Enter] to continue to the next step...

🚀 [11/3] Drop the golden master database...


Next command:
------------

cockroach sql --insecure -e "
    SET sql_safe_updates = false; 
    DROP DATABASE comment_test"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 1ms

DROP DATABASE

Time: 692ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [12/3] Restore the golden master backup to a new database...

🛠️  Restore from local file

Next command:
------------

cockroach sql --insecure -e "RESTORE DATABASE comment_test FROM LATEST IN 'nodelocal://1/comments_test_backup' WITH new_db_name = 'newdb'"

⏸️   Press [Enter] to execute this step...

---Running
        job_id        |  status   | fraction_completed | rows
----------------------+-----------+--------------------+-------
  1189339680208093185 | succeeded |                  1 |    2
(1 row)

Time: 1.321s

---Done

✅   Press [Enter] to continue to the next step...

🚀 [13/3] Restore the golden master backup to a new database...

🛠️  Show the comments on all database objects

Next command:
------------

cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 2ms

  type | object_id | sub_id | comment
-------+-----------+--------+----------
(0 rows)

Time: 9ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [14/3] Make the saved comments available for IMPORT...

🛠️  Copy CSV file to where it can be imported as a local file

Next command:
------------

cp -i comments.csv node1/extern

⏸️   Press [Enter] to execute this step...

---Running
---Done

✅   Press [Enter] to continue to the next step...

🚀 [15/3] Import the saved comments to a working table...

🛠️  Create the working table

Next command:
------------

cockroach sql --insecure -d newdb --echo-sql -f create_table_database_object_comments.sql

⏸️   Press [Enter] to execute this step...

---Running
> CREATE TABLE database_object_comments
(
    -- ── Comment type ──────────────────────────────────────────────────────────
    -- Integer code matching system.comments.type; see comment_type_name for the
    -- human-readable label.
    --   0 = Database          4 = Schema
    --   1 = Table/View/Seq    5 = Constraint
    --   2 = Column            6 = Function
    --   3 = Index             7 = User-Defined Type
    comment_type            INT8    NOT NULL,
    comment_type_name       STRING  NOT NULL,

    -- ── Object location ───────────────────────────────────────────────────────
    -- object_database_name : always non-NULL.
    -- object_schema_name   : NULL only for type 0 (Database); non-NULL for all
    --                        other types.
    -- object_name          : name of the primary object that object_id refers to.
    --                        For types 2, 3, and 5 this is the parent TABLE name,
    --                        not the column / index / constraint name.
    -- object_sub_name      : name of the sub-object that sub_id refers to.
    --                        NULL for types 0, 1, 4, 6, 7 (no sub-object).
    --                        For type 2: the column name.
    --                        For type 3: the index name.
    --                        For type 5: the constraint name.
    object_database_name    STRING  NOT NULL,
    object_schema_name      STRING  NULL,
    object_name             STRING  NOT NULL,
    object_sub_name         STRING  NULL,

    -- ── Type-specific convenience columns ────────────────────────────────────
    -- Exactly one of these is non-NULL per row, determined by comment_type.
    -- All others are NULL.
    table_name              STRING  NULL,   -- non-NULL for type 1 only
    column_name             STRING  NULL,   -- non-NULL for type 2 only
    index_name              STRING  NULL,   -- non-NULL for type 3 only
    schema_name             STRING  NULL,   -- non-NULL for type 4 only
    constraint_name         STRING  NULL,   -- non-NULL for type 5 only
    function_name           STRING  NULL,   -- non-NULL for type 6 only
    user_defined_type_name  STRING  NULL,   -- non-NULL for type 7 only

    -- ── Comment text ──────────────────────────────────────────────────────────
    -- Never NULL: CockroachDB removes a row from system.comments when a comment
    -- is cleared with COMMENT ON … IS NULL, so any surviving row has real text.
    comment_text            STRING  NOT NULL,

    -- ── Primary-key helper columns ────────────────────────────────────────────
    -- PRIMARY KEY columns must be NOT NULL, but object_schema_name is NULL for
    -- database comments and object_sub_name is NULL for five of the eight types.
    -- These STORED computed columns substitute '' for NULL so the PK constraint
    -- is satisfied without altering the meaning of the data columns.
    -- NOT VISIBLE keeps them out of SELECT * output.
    pk_schema_name  STRING  NOT NULL  NOT VISIBLE
                    AS (COALESCE(object_schema_name, ''))  STORED,
    pk_sub_name     STRING  NOT NULL  NOT VISIBLE
                    AS (COALESCE(object_sub_name,    ''))  STORED,

    -- ── Data integrity ────────────────────────────────────────────────────────
    CONSTRAINT chk_comment_type
        CHECK (comment_type BETWEEN 0 AND 7),

    -- ── Primary key ───────────────────────────────────────────────────────────
    -- Uniquely identifies each comment.  Column order mirrors the ORDER BY of
    -- the source query.  pk_schema_name and pk_sub_name stand in for the
    -- nullable object_schema_name and object_sub_name columns.
    CONSTRAINT database_object_comments_pkey
        PRIMARY KEY (
            comment_type,
            object_database_name,
            pk_schema_name,
            object_name,
            pk_sub_name
        ),

    -- ── Secondary index ───────────────────────────────────────────────────────
    -- Supports object-first lookups such as "find every comment attached to
    -- table X" regardless of comment type.
    INDEX idx_by_object (
        object_database_name,
        pk_schema_name,
        object_name,
        comment_type
    )
);
CREATE TABLE

Time: 61ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [16/3] Import the saved comments to a working table...

🛠️  IMPORT from a local file

Next command:
------------

cockroach sql --insecure -d newdb -e "IMPORT INTO database_object_comments CSV DATA ('nodelocal://1/comments.csv') WITH skip = '1'"

⏸️   Press [Enter] to execute this step...

---Running
        job_id        |  status   | fraction_completed | rows | index_entries | bytes
----------------------+-----------+--------------------+------+---------------+--------
  1189339861660762113 | succeeded |                  1 |    6 |             6 |  1941
(1 row)

Time: 1.130s

---Done

✅   Press [Enter] to continue to the next step...

🚀 [17/3] Import the saved comments to a working table...

🛠️  Update the working table to match the name of the new database

Next command:
------------

cockroach sql --insecure -d newdb -e "
    SET sql_safe_updates = false; 
    UPDATE database_object_comments 
     SET object_database_name = 'newdb'; 
    UPDATE database_object_comments 
     SET object_name = 'newdb' 
     WHERE comment_type_name='Database';"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 1ms

UPDATE 6

Time: 21ms

UPDATE 1

Time: 52ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [18/3] Restore the comments to the database objects...

🛠️  Generate statements to set the comments, and execute them for the database objects

Next command:
------------

cockroach sql --insecure -d newdb --echo-sql -f "generate_comment_statements.sql" | \
    tail -n +2 | \
    while read stmt; do; echo "executing: $stmt"; cockroach sql --insecure -d newdb -e "$stmt"; done

⏸️   Press [Enter] to execute this step...

---Running
> SELECT
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
executing: COMMENT ON DATABASE newdb IS '(database) Scratch database used to demonstrate all eight CockroachDB comment types.';
COMMENT ON DATABASE

Time: 26ms

executing: COMMENT ON TABLE newdb.inventory.products IS '(table) Master catalogue of every product stocked in the warehouse; one row per distinct SKU.';
COMMENT ON TABLE

Time: 21ms

executing: COMMENT ON COLUMN newdb.inventory.products.sku IS '(column) Supplier-assigned stock-keeping unit code.  Must be globally unique across all suppliers.';
COMMENT ON COLUMN

Time: 28ms

executing: COMMENT ON INDEX newdb.inventory.products@idx_products_name IS '(index) Supports fast product-name searches and ORDER BY name queries across the full catalogue.';
COMMENT ON INDEX

Time: 22ms

executing: COMMENT ON SCHEMA newdb.inventory IS '(schema) Contains all tables, types, functions, and supporting objects for warehouse inventory management.';
COMMENT ON SCHEMA

Time: 23ms

executing: COMMENT ON CONSTRAINT chk_positive_price ON newdb.inventory.products IS '(constraint) Every stocked item must carry a positive list price; complimentary items are handled through a separate promotions workflow, not a zero price.';
COMMENT ON CONSTRAINT

Time: 26ms

---Done

✅   Press [Enter] to continue to the next step...

🚀 [19/3] Restore the comments to the database objects...

🛠️  Show the comments on all database objects

Next command:
------------

cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"

⏸️   Press [Enter] to execute this step...

---Running
SET

Time: 6ms

  type | object_id | sub_id |                                                                           comment
-------+-----------+--------+--------------------------------------------------------------------------------------------------------------------------------------------------------------
     0 |       114 |      0 | (database) Scratch database used to demonstrate all eight CockroachDB comment types.
     1 |       119 |      0 | (table) Master catalogue of every product stocked in the warehouse; one row per distinct SKU.
     2 |       119 |      2 | (column) Supplier-assigned stock-keeping unit code.  Must be globally unique across all suppliers.
     3 |       119 |      3 | (index) Supports fast product-name searches and ORDER BY name queries across the full catalogue.
     4 |       116 |      0 | (schema) Contains all tables, types, functions, and supporting objects for warehouse inventory management.
     5 |       119 |      3 | (constraint) Every stocked item must carry a positive list price; complimentary items are handled through a separate promotions workflow, not a zero price.
(6 rows)

Time: 3ms

---Done

✅   Press [Enter] to continue to the next step...


DEMO FINISHED

$ 
```
