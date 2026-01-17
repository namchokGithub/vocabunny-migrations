-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_daily_quest_set_items (
  day_key date NOT NULL,
  quest_id uuid NOT NULL,
  order_no int NOT NULL DEFAULT 0,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (day_key, quest_id)
);
CREATE INDEX idx_tbl_daily_quest_set_items_day_key_order_no ON tbl_daily_quest_set_items (day_key, order_no);
CREATE INDEX idx_tbl_daily_quest_set_items_deleted_at ON tbl_daily_quest_set_items (deleted_at);
ALTER TABLE tbl_daily_quest_set_items ADD CONSTRAINT fk_tbl_daily_quest_set_items_day_key FOREIGN KEY (day_key) REFERENCES tbl_daily_quest_sets(day_key);
ALTER TABLE tbl_daily_quest_set_items ADD CONSTRAINT fk_tbl_daily_quest_set_items_quest_id FOREIGN KEY (quest_id) REFERENCES tbl_quest_definitions(id);
