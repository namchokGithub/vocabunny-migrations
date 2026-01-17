-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_roles (
  id uuid PRIMARY KEY,
  name role_name NOT NULL UNIQUE,
  description text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_roles_name ON tbl_roles (name);
CREATE INDEX idx_tbl_roles_deleted_at ON tbl_roles (deleted_at);
