-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_progress (
  actor_id uuid NOT NULL,
  unit_id uuid NOT NULL,
  completed_question_sets int NOT NULL DEFAULT 0,
  best_accuracy numeric NOT NULL DEFAULT 0,
  last_played_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, unit_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_progress_actor_id_last_played_at ON tbl_actor_progress (actor_id, last_played_at);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_progress_deleted_at ON tbl_actor_progress (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_progress_actor_id') THEN
        ALTER TABLE tbl_actor_progress ADD CONSTRAINT fk_tbl_actor_progress_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_progress_unit_id') THEN
        ALTER TABLE tbl_actor_progress ADD CONSTRAINT fk_tbl_actor_progress_unit_id FOREIGN KEY (unit_id) REFERENCES tbl_units(id);
    END IF;
END $$;
