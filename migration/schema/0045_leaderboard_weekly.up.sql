-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_leaderboard_weekly (
  week_key text NOT NULL,
  actor_id uuid NOT NULL,
  display_name text NOT NULL,
  weekly_exp int NOT NULL DEFAULT 0,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (week_key, actor_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_leaderboard_weekly_week_key_weekly_exp_updated_at ON tbl_leaderboard_weekly (week_key, weekly_exp, updated_at);
CREATE INDEX IF NOT EXISTS idx_tbl_leaderboard_weekly_deleted_at ON tbl_leaderboard_weekly (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_leaderboard_weekly_actor_id') THEN
        ALTER TABLE tbl_leaderboard_weekly ADD CONSTRAINT fk_tbl_leaderboard_weekly_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
