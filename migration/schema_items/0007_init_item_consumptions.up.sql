-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_item_consumptions (
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
CREATE INDEX idx_tbl_item_consumptions_actor_id_created_at ON tbl_item_consumptions (actor_id, created_at);
CREATE INDEX idx_tbl_item_consumptions_item_id_created_at ON tbl_item_consumptions (item_id, created_at);
CREATE INDEX idx_tbl_item_consumptions_deleted_at ON tbl_item_consumptions (deleted_at);
ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_item_id FOREIGN KEY (item_id) REFERENCES tbl_items(id);
ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_item_consumptions ADD CONSTRAINT fk_tbl_item_consumptions_ref_attempt_id FOREIGN KEY (ref_attempt_id) REFERENCES tbl_question_set_attempts(id);
