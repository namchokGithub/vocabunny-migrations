-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_streak_events (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  event_type text NOT NULL,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  ref_attempt_id uuid,
  meta jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_streak_events_actor_id_occurred_at ON tbl_streak_events (actor_id, occurred_at);
CREATE INDEX IF NOT EXISTS idx_tbl_streak_events_event_type_occurred_at ON tbl_streak_events (event_type, occurred_at);
CREATE INDEX IF NOT EXISTS idx_tbl_streak_events_deleted_at ON tbl_streak_events (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_streak_events_actor_id') THEN
        ALTER TABLE tbl_streak_events ADD CONSTRAINT fk_tbl_streak_events_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_streak_events_ref_attempt_id') THEN
        ALTER TABLE tbl_streak_events ADD CONSTRAINT fk_tbl_streak_events_ref_attempt_id FOREIGN KEY (ref_attempt_id) REFERENCES tbl_question_set_attempts(id);
    END IF;
END $$;
