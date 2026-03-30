-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_identity (
  actor_id uuid PRIMARY KEY,
  user_id uuid,
  guest_id uuid,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_identity_user_id ON tbl_actor_identity (user_id);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_identity_guest_id ON tbl_actor_identity (guest_id);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_identity_deleted_at ON tbl_actor_identity (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_identity_user_id') THEN
        ALTER TABLE tbl_actor_identity ADD CONSTRAINT fk_tbl_actor_identity_user_id FOREIGN KEY (user_id) REFERENCES tbl_users(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_identity_guest_id') THEN
        ALTER TABLE tbl_actor_identity ADD CONSTRAINT fk_tbl_actor_identity_guest_id FOREIGN KEY (guest_id) REFERENCES tbl_guests(id);
    END IF;
END $$;
