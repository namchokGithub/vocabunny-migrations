-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_guests (
  id uuid PRIMARY KEY,
  display_name text NOT NULL,
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_guests_last_seen_at ON tbl_guests (last_seen_at);
CREATE INDEX IF NOT EXISTS idx_tbl_guests_deleted_at ON tbl_guests (deleted_at);