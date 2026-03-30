-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_item_consumptions (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  item_id uuid NOT NULL,
  quantity int NOT NULL DEFAULT 1,
  reason item_consumption_reason,
  ref_attempt_id uuid,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_item_consumptions_actor_id_created_at ON tbl_item_consumptions (actor_id, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_item_consumptions_item_id_created_at ON tbl_item_consumptions (item_id, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_item_consumptions_deleted_at ON tbl_item_consumptions (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_item_consumptions_item_id') THEN
        ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_item_id FOREIGN KEY (item_id) REFERENCES tbl_items(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_item_consumptions_actor_id') THEN
        ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_item_consumptions_ref_attempt_id') THEN
        ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_ref_attempt_id FOREIGN KEY (ref_attempt_id) REFERENCES tbl_question_set_attempts(id);
    END IF;
END $$;
