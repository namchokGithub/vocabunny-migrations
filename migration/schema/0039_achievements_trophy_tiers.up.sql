-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_trophy_tiers (
  id uuid PRIMARY KEY,
  code trophy_tier_code NOT NULL UNIQUE,
  name text NOT NULL,
  icon text,
  is_active boolean NOT NULL DEFAULT true,
  req_daily_quests_days int NOT NULL DEFAULT 0,
  req_quiz_attempts int NOT NULL DEFAULT 0,
  req_min_streak int NOT NULL DEFAULT 0,
  req_full_month_streak boolean NOT NULL DEFAULT false,
  req_avg_accuracy numeric,
  reward_coins int NOT NULL DEFAULT 0,
  reward_exp int NOT NULL DEFAULT 0,
  reward_badge_code text,
  reward_avatar_frame_code text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_trophy_tiers_code ON tbl_trophy_tiers (code);
CREATE INDEX IF NOT EXISTS idx_tbl_trophy_tiers_is_active ON tbl_trophy_tiers (is_active);
CREATE INDEX IF NOT EXISTS idx_tbl_trophy_tiers_deleted_at ON tbl_trophy_tiers (deleted_at);