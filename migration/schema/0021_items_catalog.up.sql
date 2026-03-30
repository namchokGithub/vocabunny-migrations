-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_items (
  id uuid PRIMARY KEY,
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  rarity int NOT NULL,
  meta jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_items_key ON tbl_items (key);
CREATE INDEX IF NOT EXISTS idx_tbl_items_rarity ON tbl_items (rarity);
CREATE INDEX IF NOT EXISTS idx_tbl_items_deleted_at ON tbl_items (deleted_at);CREATE TABLE IF NOT EXISTS tbl_item_catalog (
  id uuid PRIMARY KEY,
  sku text NOT NULL UNIQUE,
  name text NOT NULL,
  description text,
  item_type item_type NOT NULL,
  price_coins int NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  meta jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_item_catalog_sku ON tbl_item_catalog (sku);
CREATE INDEX IF NOT EXISTS idx_tbl_item_catalog_is_active ON tbl_item_catalog (is_active);
CREATE INDEX IF NOT EXISTS idx_tbl_item_catalog_item_type ON tbl_item_catalog (item_type);
CREATE INDEX IF NOT EXISTS idx_tbl_item_catalog_deleted_at ON tbl_item_catalog (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_items_created_by') THEN
        ALTER TABLE tbl_items ADD CONSTRAINT fk_tbl_items_created_by FOREIGN KEY (created_by) REFERENCES tbl_users(id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_items_updated_by') THEN
        ALTER TABLE tbl_items ADD CONSTRAINT fk_tbl_items_updated_by FOREIGN KEY (updated_by) REFERENCES tbl_users(id);
    END IF;
END $$;
