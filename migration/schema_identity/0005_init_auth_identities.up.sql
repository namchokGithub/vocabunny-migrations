-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_auth_identities (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  provider text NOT NULL,
  provider_user_id text,
  password_hash text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX idx_tbl_auth_identities_provider_provider_user_id ON tbl_auth_identities (provider, provider_user_id);
CREATE UNIQUE INDEX idx_tbl_auth_identities_user_id_provider ON tbl_auth_identities (user_id, provider);
CREATE INDEX idx_tbl_auth_identities_deleted_at ON tbl_auth_identities (deleted_at);
ALTER TABLE tbl_auth_identities ADD CONSTRAINT fk_tbl_auth_identities_user_id FOREIGN KEY (user_id) REFERENCES tbl_users(id);
