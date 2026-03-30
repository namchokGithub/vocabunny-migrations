-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_monthly_progress (
  actor_id uuid NOT NULL,
  month_key date NOT NULL,
  daily_quests_completed_days int NOT NULL DEFAULT 0,
  quiz_attempts_count int NOT NULL DEFAULT 0,
  best_streak_in_month int NOT NULL DEFAULT 0,
  full_month_streak_achieved boolean NOT NULL DEFAULT false,
  avg_accuracy numeric,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, month_key)
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_monthly_progress_month_key ON tbl_actor_monthly_progress (month_key);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_monthly_progress_deleted_at ON tbl_actor_monthly_progress (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_monthly_progress_actor_id') THEN
        ALTER TABLE tbl_actor_monthly_progress ADD CONSTRAINT fk_tbl_actor_monthly_progress_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
