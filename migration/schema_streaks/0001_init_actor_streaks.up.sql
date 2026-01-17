-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_actor_streaks (
  actor_id uuid NOT NULL PRIMARY KEY,
  current_streak int NOT NULL DEFAULT 0,
  longest_streak int NOT NULL DEFAULT 0,
  last_active_at timestamptz,
  streak_expires_at timestamptz,
  freeze_balance int NOT NULL DEFAULT 0,
  last_freeze_used_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_actor_streaks_streak_expires_at ON tbl_actor_streaks (streak_expires_at);
CREATE INDEX idx_tbl_actor_streaks_deleted_at ON tbl_actor_streaks (deleted_at);
ALTER TABLE tbl_actor_streaks ADD CONSTRAINT fk_tbl_actor_streaks_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
