-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_users (
  id uuid PRIMARY KEY,
  email text UNIQUE,
  username text UNIQUE,
  display_name text NOT NULL,
  avatar_id uuid,
  status user_status NOT NULL DEFAULT 'ACTIVE',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_users_email ON tbl_users (email);
CREATE INDEX idx_tbl_users_username ON tbl_users (username);
CREATE INDEX idx_tbl_users_status ON tbl_users (status);
CREATE INDEX idx_tbl_users_deleted_at ON tbl_users (deleted_at);
