-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_lessons (
  id uuid PRIMARY KEY,
  section_id uuid NOT NULL,
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
CREATE UNIQUE INDEX idx_tbl_lessons_section_id_slug ON tbl_lessons (section_id, slug);
CREATE INDEX idx_tbl_lessons_section_id_is_published_order_no ON tbl_lessons (section_id, is_published, order_no);
ALTER TABLE tbl_lessons ADD CONSTRAINT fk_tbl_lessons_section_id FOREIGN KEY (section_id) REFERENCES tbl_sections(id);
