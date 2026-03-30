-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_user_roles (
  user_id uuid NOT NULL,
  role_id uuid NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (user_id, role_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_user_roles_role_id ON tbl_user_roles (role_id);
CREATE INDEX IF NOT EXISTS idx_tbl_user_roles_deleted_at ON tbl_user_roles (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_user_roles_user_id') THEN
        ALTER TABLE tbl_user_roles ADD CONSTRAINT fk_tbl_user_roles_user_id FOREIGN KEY (user_id) REFERENCES tbl_users(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_user_roles_role_id') THEN
        ALTER TABLE tbl_user_roles ADD CONSTRAINT fk_tbl_user_roles_role_id FOREIGN KEY (role_id) REFERENCES tbl_roles(id);
    END IF;
END $$;
