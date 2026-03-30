-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_coin_transactions (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  idempotency_key text NOT NULL,
  source_type coin_source_type,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tbl_coin_transactions_actor_id_idempotency_key ON tbl_coin_transactions (actor_id, idempotency_key);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_coin_transactions_actor_id') THEN
        ALTER TABLE tbl_coin_transactions ADD CONSTRAINT fk_tbl_coin_transactions_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
