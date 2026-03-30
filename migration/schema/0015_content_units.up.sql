-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_units (
  id uuid PRIMARY KEY,
  lesson_id uuid NOT NULL,
  slug text NOT NULL,
  title text NOT NULL,
  description text,
  order_no int NOT NULL DEFAULT 0,
  is_published boolean NOT NULL DEFAULT false,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tbl_units_lesson_id_slug ON tbl_units (lesson_id, slug);
CREATE INDEX IF NOT EXISTS idx_tbl_units_lesson_id_is_published_order_no ON tbl_units (lesson_id, is_published, order_no);
CREATE INDEX IF NOT EXISTS idx_tbl_units_deleted_at ON tbl_units (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_units_lesson_id') THEN
        ALTER TABLE tbl_units ADD CONSTRAINT fk_tbl_units_lesson_id FOREIGN KEY (lesson_id) REFERENCES tbl_lessons(id);
    END IF;
END $$;
