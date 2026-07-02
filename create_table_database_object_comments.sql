CREATE TABLE database_object_comments
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
