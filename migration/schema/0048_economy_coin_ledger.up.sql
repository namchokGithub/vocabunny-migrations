-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_coin_ledger (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  source_type coin_source_type NOT NULL,
  source_ref_id uuid,
  coin_delta int NOT NULL,
  balance_after bigint,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_coin_ledger_actor_id_created_at ON tbl_coin_ledger (actor_id, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_coin_ledger_source_type_created_at ON tbl_coin_ledger (source_type, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_coin_ledger_deleted_at ON tbl_coin_ledger (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_coin_ledger_actor_id') THEN
        ALTER TABLE tbl_coin_ledger ADD CONSTRAINT fk_tbl_coin_ledger_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
