-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_streak_rewards_claimed (
  actor_id uuid NOT NULL,
  milestone_id uuid NOT NULL,
  claimed_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, milestone_id)
);
CREATE INDEX idx_tbl_streak_rewards_claimed_milestone_id ON tbl_streak_rewards_claimed (milestone_id);
CREATE INDEX idx_tbl_streak_rewards_claimed_deleted_at ON tbl_streak_rewards_claimed (deleted_at);
ALTER TABLE tbl_streak_rewards_claimed ADD CONSTRAINT fk_tbl_streak_rewards_claimed_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_streak_rewards_claimed ADD CONSTRAINT fk_tbl_streak_rewards_claimed_milestone_id FOREIGN KEY (milestone_id) REFERENCES tbl_streak_milestones(id);
