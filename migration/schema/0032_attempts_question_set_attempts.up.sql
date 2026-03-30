-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_question_set_attempts (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  question_set_id uuid NOT NULL,
  question_set_version int NOT NULL,
  started_at timestamptz NOT NULL DEFAULT now(),
  finished_at timestamptz,
  status attempt_status NOT NULL DEFAULT 'FINISHED',
  total_questions int NOT NULL,
  correct_count int NOT NULL DEFAULT 0,
  accuracy numeric NOT NULL DEFAULT 0,
  earned_exp int NOT NULL DEFAULT 0,
  bonus_exp int NOT NULL DEFAULT 0,
  client_submission_id uuid NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tbl_question_set_attempts_actor_id_client_submission_id ON tbl_question_set_attempts (actor_id, client_submission_id);
CREATE INDEX IF NOT EXISTS idx_tbl_question_set_attempts_actor_id_finished_at ON tbl_question_set_attempts (actor_id, finished_at);
CREATE INDEX IF NOT EXISTS idx_tbl_question_set_attempts_question_set_id_finished_at ON tbl_question_set_attempts (question_set_id, finished_at);
CREATE INDEX IF NOT EXISTS idx_tbl_question_set_attempts_status ON tbl_question_set_attempts (status);
CREATE INDEX IF NOT EXISTS idx_tbl_question_set_attempts_deleted_at ON tbl_question_set_attempts (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_set_attempts_actor_id') THEN
        ALTER TABLE tbl_question_set_attempts ADD CONSTRAINT fk_tbl_question_set_attempts_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_set_attempts_question_set_id') THEN
        ALTER TABLE tbl_question_set_attempts ADD CONSTRAINT fk_tbl_question_set_attempts_question_set_id FOREIGN KEY (question_set_id) REFERENCES tbl_question_sets(id);
    END IF;
END $$;
