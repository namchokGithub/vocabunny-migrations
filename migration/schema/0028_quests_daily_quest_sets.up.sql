-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_daily_quest_sets (
  day_key date PRIMARY KEY,
  strategy daily_quest_strategy NOT NULL DEFAULT 'RANDOM',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_daily_quest_sets_strategy ON tbl_daily_quest_sets (strategy);
CREATE INDEX IF NOT EXISTS idx_tbl_daily_quest_sets_deleted_at ON tbl_daily_quest_sets (deleted_at);