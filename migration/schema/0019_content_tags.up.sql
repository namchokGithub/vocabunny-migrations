-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_tags (
  id uuid PRIMARY KEY,
  name text NOT NULL UNIQUE,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_tags_deleted_at ON tbl_tags (deleted_at);