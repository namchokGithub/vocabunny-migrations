-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_question_tags (
  question_id uuid NOT NULL,
  tag_id uuid NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (question_id, tag_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_question_tags_tag_id ON tbl_question_tags (tag_id);
CREATE INDEX IF NOT EXISTS idx_tbl_question_tags_deleted_at ON tbl_question_tags (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_tags_question_id') THEN
        ALTER TABLE tbl_question_tags ADD CONSTRAINT fk_tbl_question_tags_question_id FOREIGN KEY (question_id) REFERENCES tbl_questions(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_tags_tag_id') THEN
        ALTER TABLE tbl_question_tags ADD CONSTRAINT fk_tbl_question_tags_tag_id FOREIGN KEY (tag_id) REFERENCES tbl_tags(id);
    END IF;
END $$;
