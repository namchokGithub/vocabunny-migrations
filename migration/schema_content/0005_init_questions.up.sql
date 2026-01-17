-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_questions (
  id uuid PRIMARY KEY,
  question_set_id uuid NOT NULL,
  type text NOT NULL,
  question_text text NOT NULL,
  blank_position int,
  explanation text,
  image_url text,
  difficulty int NOT NULL DEFAULT 1,
  order_no int NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_questions_question_set_id_order_no ON tbl_questions (question_set_id, order_no);
CREATE INDEX idx_tbl_questions_question_set_id_is_active ON tbl_questions (question_set_id, is_active);
CREATE INDEX idx_tbl_questions_type ON tbl_questions (type);
CREATE INDEX idx_tbl_questions_deleted_at ON tbl_questions (deleted_at);
ALTER TABLE tbl_questions ADD CONSTRAINT fk_tbl_questions_question_set_id FOREIGN KEY (question_set_id) REFERENCES tbl_question_sets(id);
