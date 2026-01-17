-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_actor_wallets (
  actor_id uuid NOT NULL PRIMARY KEY,
  coin_balance bigint NOT NULL DEFAULT 0,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_actor_wallets_deleted_at ON tbl_actor_wallets (deleted_at);
ALTER TABLE tbl_actor_wallets ADD CONSTRAINT fk_tbl_actor_wallets_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
