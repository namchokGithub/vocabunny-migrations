-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_role_permissions (
  role_id uuid NOT NULL,
  permission_code permission_code NOT NULL,
  scope text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (role_id, permission_code)
);
CREATE INDEX IF NOT EXISTS idx_tbl_role_permissions_permission_code ON tbl_role_permissions (permission_code);
CREATE INDEX IF NOT EXISTS idx_tbl_role_permissions_deleted_at ON tbl_role_permissions (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_role_permissions_role_id') THEN
        ALTER TABLE tbl_role_permissions ADD CONSTRAINT fk_tbl_role_permissions_role_id FOREIGN KEY (role_id) REFERENCES tbl_roles(id);
    END IF;
END $$;
