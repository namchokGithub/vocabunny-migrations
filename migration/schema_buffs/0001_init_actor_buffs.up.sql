-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_actor_buffs (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  buff_type buff_type NOT NULL,
  source_item_id uuid,
  multiplier numeric NOT NULL DEFAULT 1.0,
  started_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  meta jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_actor_buffs_actor_id_is_active ON tbl_actor_buffs (actor_id, is_active);
CREATE INDEX idx_tbl_actor_buffs_actor_id_expires_at ON tbl_actor_buffs (actor_id, expires_at);
CREATE INDEX idx_tbl_actor_buffs_buff_type_is_active ON tbl_actor_buffs (buff_type, is_active);
CREATE INDEX idx_tbl_actor_buffs_deleted_at ON tbl_actor_buffs (deleted_at);
ALTER TABLE tbl_actor_buffs ADD CONSTRAINT fk_tbl_actor_buffs_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_actor_buffs ADD CONSTRAINT fk_tbl_actor_buffs_source_item_id FOREIGN KEY (source_item_id) REFERENCES tbl_item_catalog(id);
