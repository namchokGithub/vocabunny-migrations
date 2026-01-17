-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_gacha_rolls (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  roll_type gacha_roll_type NOT NULL,
  cost_coins int NOT NULL DEFAULT 0,
  result_items jsonb NOT NULL,
  rolled_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_gacha_rolls_actor_id_rolled_at ON tbl_gacha_rolls (actor_id, rolled_at);
CREATE INDEX idx_tbl_gacha_rolls_roll_type_rolled_at ON tbl_gacha_rolls (roll_type, rolled_at);
CREATE INDEX idx_tbl_gacha_rolls_deleted_at ON tbl_gacha_rolls (deleted_at);
ALTER TABLE tbl_gacha_rolls ADD CONSTRAINT fk_tbl_gacha_rolls_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
