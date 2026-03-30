-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_question_attempts (
  id uuid PRIMARY KEY,
  attempt_id uuid NOT NULL,
  question_id uuid NOT NULL,
  selected_choice_id uuid,
  is_correct boolean NOT NULL,
  answered_at timestamptz NOT NULL DEFAULT now(),
  time_spent_ms int,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_question_attempts_attempt_id ON tbl_question_attempts (attempt_id);
CREATE INDEX IF NOT EXISTS idx_tbl_question_attempts_question_id_answered_at ON tbl_question_attempts (question_id, answered_at);
CREATE INDEX IF NOT EXISTS idx_tbl_question_attempts_deleted_at ON tbl_question_attempts (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_attempts_attempt_id') THEN
        ALTER TABLE tbl_question_attempts ADD CONSTRAINT fk_tbl_question_attempts_attempt_id FOREIGN KEY (attempt_id) REFERENCES tbl_question_set_attempts(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_attempts_question_id') THEN
        ALTER TABLE tbl_question_attempts ADD CONSTRAINT fk_tbl_question_attempts_question_id FOREIGN KEY (question_id) REFERENCES tbl_questions(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_attempts_selected_choice_id') THEN
        ALTER TABLE tbl_question_attempts ADD CONSTRAINT fk_tbl_question_attempts_selected_choice_id FOREIGN KEY (selected_choice_id) REFERENCES tbl_question_choices(id);
    END IF;
END $$;
