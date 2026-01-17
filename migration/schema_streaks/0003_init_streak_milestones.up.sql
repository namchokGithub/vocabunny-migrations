-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_streak_milestones (
  id uuid PRIMARY KEY,
  days int NOT NULL UNIQUE,
  reward_type text NOT NULL,
  reward_payload jsonb NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_streak_milestones_days ON tbl_streak_milestones (days);
CREATE INDEX idx_tbl_streak_milestones_is_active ON tbl_streak_milestones (is_active);
CREATE INDEX idx_tbl_streak_milestones_deleted_at ON tbl_streak_milestones (deleted_at);
