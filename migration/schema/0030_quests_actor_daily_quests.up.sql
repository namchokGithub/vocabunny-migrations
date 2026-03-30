-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_actor_daily_quests (
  actor_id uuid NOT NULL,
  day_key date NOT NULL,
  quest_id uuid NOT NULL,
  progress_value int NOT NULL DEFAULT 0,
  progress_percent numeric,
  is_completed boolean NOT NULL DEFAULT false,
  completed_at timestamptz,
  reward_claimed boolean NOT NULL DEFAULT false,
  claimed_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, day_key, quest_id)
);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_daily_quests_day_key_quest_id ON tbl_actor_daily_quests (day_key, quest_id);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_daily_quests_actor_id_day_key ON tbl_actor_daily_quests (actor_id, day_key);
CREATE INDEX IF NOT EXISTS idx_tbl_actor_daily_quests_deleted_at ON tbl_actor_daily_quests (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_daily_quests_actor_id') THEN
        ALTER TABLE tbl_actor_daily_quests ADD CONSTRAINT fk_tbl_actor_daily_quests_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_actor_daily_quests_quest_id') THEN
        ALTER TABLE tbl_actor_daily_quests ADD CONSTRAINT fk_tbl_actor_daily_quests_quest_id FOREIGN KEY (quest_id) REFERENCES tbl_quest_definitions(id);
    END IF;
END $$;
