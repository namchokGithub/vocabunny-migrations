-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_quest_definitions (
  id uuid PRIMARY KEY,
  code text NOT NULL UNIQUE,
  title text NOT NULL,
  description text,
  quest_type quest_type NOT NULL,
  target_value int,
  target_percent numeric,
  params jsonb,
  reward_coins int NOT NULL DEFAULT 0,
  reward_exp int NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_quest_definitions_code ON tbl_quest_definitions (code);
CREATE INDEX idx_tbl_quest_definitions_quest_type ON tbl_quest_definitions (quest_type);
CREATE INDEX idx_tbl_quest_definitions_is_active ON tbl_quest_definitions (is_active);
CREATE INDEX idx_tbl_quest_definitions_deleted_at ON tbl_quest_definitions (deleted_at);
