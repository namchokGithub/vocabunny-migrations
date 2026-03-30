-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_shop_orders (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  status shop_order_status NOT NULL DEFAULT 'COMPLETED',
  total_coins int NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_shop_orders_actor_id_created_at ON tbl_shop_orders (actor_id, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_shop_orders_status ON tbl_shop_orders (status);
CREATE INDEX IF NOT EXISTS idx_tbl_shop_orders_deleted_at ON tbl_shop_orders (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_shop_orders_actor_id') THEN
        ALTER TABLE tbl_shop_orders ADD CONSTRAINT fk_tbl_shop_orders_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
