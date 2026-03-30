-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_question_sets (
  id uuid PRIMARY KEY,
  unit_id uuid NOT NULL,
  slug text NOT NULL,
  title text NOT NULL,
  description text,
  order_no int NOT NULL DEFAULT 0,
  estimated_seconds int,
  is_published boolean NOT NULL DEFAULT false,
  version int NOT NULL DEFAULT 1,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tbl_question_sets_unit_id_slug_version ON tbl_question_sets (unit_id, slug, version);
CREATE INDEX IF NOT EXISTS idx_tbl_question_sets_unit_id_is_published_order_no ON tbl_question_sets (unit_id, is_published, order_no);
CREATE INDEX IF NOT EXISTS idx_tbl_question_sets_unit_id_slug ON tbl_question_sets (unit_id, slug);
CREATE INDEX IF NOT EXISTS idx_tbl_question_sets_deleted_at ON tbl_question_sets (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_question_sets_unit_id') THEN
        ALTER TABLE tbl_question_sets ADD CONSTRAINT fk_tbl_question_sets_unit_id FOREIGN KEY (unit_id) REFERENCES tbl_units(id);
    END IF;
END $$;
