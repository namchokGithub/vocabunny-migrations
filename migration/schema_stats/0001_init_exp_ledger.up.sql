-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_exp_ledger (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  source exp_source NOT NULL,
  source_ref_id uuid,
  exp_delta int NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_exp_ledger_actor_id_created_at ON tbl_exp_ledger (actor_id, created_at);
CREATE INDEX idx_tbl_exp_ledger_source_created_at ON tbl_exp_ledger (source, created_at);
CREATE INDEX idx_tbl_exp_ledger_deleted_at ON tbl_exp_ledger (deleted_at);
ALTER TABLE tbl_exp_ledger ADD CONSTRAINT fk_tbl_exp_ledger_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
