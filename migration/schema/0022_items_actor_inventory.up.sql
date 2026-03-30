-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_inventory (
  actor_id uuid NOT NULL,
  item_id uuid NOT NULL,
  qty int NOT NULL DEFAULT 0,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, item_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_inventory_item_id ON tbl_actor_inventory (item_id);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_inventory_deleted_at ON tbl_actor_inventory (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_inventory_actor_id') THEN
        ALTER TABLE tbl_actor_inventory ADD CONSTRAINT fk_tbl_actor_inventory_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_inventory_item_id') THEN
        ALTER TABLE tbl_actor_inventory ADD CONSTRAINT fk_tbl_actor_inventory_item_id FOREIGN KEY (item_id) REFERENCES tbl_items(id);
    END IF;
END $$;
