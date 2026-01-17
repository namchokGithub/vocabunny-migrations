-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_actor_showcase (
  actor_id uuid PRIMARY KEY,
  showcase_trophy_month_key date,
  showcase_trophy_tier_id uuid,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_actor_showcase_showcase_trophy_tier_id ON tbl_actor_showcase (showcase_trophy_tier_id);
CREATE INDEX idx_tbl_actor_showcase_deleted_at ON tbl_actor_showcase (deleted_at);
ALTER TABLE tbl_actor_showcase ADD CONSTRAINT fk_tbl_actor_showcase_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_actor_showcase ADD CONSTRAINT fk_tbl_actor_showcase_showcase_trophy_tier_id FOREIGN KEY (showcase_trophy_tier_id) REFERENCES tbl_trophy_tiers(id);
