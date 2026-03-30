-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_shop_order_items (
  order_id uuid NOT NULL,
  item_id uuid NOT NULL,
  quantity int NOT NULL DEFAULT 1,
  unit_price_coins int NOT NULL,
  line_total_coins int NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (order_id, item_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_shop_order_items_item_id ON tbl_shop_order_items (item_id);
CREATE INDEX IF NOT EXISTS idx_tbl_shop_order_items_deleted_at ON tbl_shop_order_items (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_shop_order_items_order_id') THEN
        ALTER TABLE tbl_shop_order_items ADD CONSTRAINT fk_tbl_shop_order_items_order_id FOREIGN KEY (order_id) REFERENCES tbl_shop_orders(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_shop_order_items_item_id') THEN
        ALTER TABLE tbl_shop_order_items ADD CONSTRAINT fk_tbl_shop_order_items_item_id FOREIGN KEY (item_id) REFERENCES tbl_item_catalog(id);
    END IF;
END $$;
