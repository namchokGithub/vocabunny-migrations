-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_role_permissions (
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
CREATE INDEX idx_tbl_role_permissions_permission_code ON tbl_role_permissions (permission_code);
CREATE INDEX idx_tbl_role_permissions_deleted_at ON tbl_role_permissions (deleted_at);
ALTER TABLE tbl_role_permissions ADD CONSTRAINT fk_tbl_role_permissions_role_id FOREIGN KEY (role_id) REFERENCES tbl_roles(id);
