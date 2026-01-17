-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_question_choices (
  id uuid PRIMARY KEY,
  question_id uuid NOT NULL,
  choice_text text NOT NULL,
  choice_order int NOT NULL DEFAULT 0,
  is_correct boolean NOT NULL DEFAULT false,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_question_choices_question_id_choice_order ON tbl_question_choices (question_id, choice_order);
CREATE INDEX idx_tbl_question_choices_question_id ON tbl_question_choices (question_id);
CREATE INDEX idx_tbl_question_choices_deleted_at ON tbl_question_choices (deleted_at);
ALTER TABLE tbl_question_choices ADD CONSTRAINT fk_tbl_question_choices_question_id FOREIGN KEY (question_id) REFERENCES tbl_questions(id);
