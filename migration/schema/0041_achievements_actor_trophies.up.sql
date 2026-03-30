-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_trophies (
  actor_id uuid NOT NULL,
  month_key date NOT NULL,
  trophy_tier_id uuid NOT NULL,
  awarded_at timestamptz NOT NULL DEFAULT now(),
  reward_claimed boolean NOT NULL DEFAULT false,
  claimed_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, month_key, trophy_tier_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_trophies_actor_id_awarded_at ON tbl_actor_trophies (actor_id, awarded_at);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_trophies_deleted_at ON tbl_actor_trophies (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_trophies_actor_id') THEN
        ALTER TABLE tbl_actor_trophies ADD CONSTRAINT fk_tbl_actor_trophies_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_trophies_trophy_tier_id') THEN
        ALTER TABLE tbl_actor_trophies ADD CONSTRAINT fk_tbl_actor_trophies_trophy_tier_id FOREIGN KEY (trophy_tier_id) REFERENCES tbl_trophy_tiers(id);
    END IF;
END $$;
