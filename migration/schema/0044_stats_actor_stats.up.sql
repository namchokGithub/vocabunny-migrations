-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_stats (
  actor_id uuid PRIMARY KEY,
  total_exp bigint NOT NULL DEFAULT 0,
  level int NOT NULL DEFAULT 1,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_stats_deleted_at ON tbl_actor_stats (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_stats_actor_id') THEN
        ALTER TABLE tbl_actor_stats ADD CONSTRAINT fk_tbl_actor_stats_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
