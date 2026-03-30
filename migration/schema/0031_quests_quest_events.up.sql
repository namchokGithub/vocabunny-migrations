-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_quest_events (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  day_key date NOT NULL,
  quest_id uuid NOT NULL,
  event_type quest_event_type NOT NULL,
  meta jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_tbl_quest_events_actor_id_created_at ON tbl_quest_events (actor_id, created_at);
CREATE INDEX IF NOT EXISTS idx_tbl_quest_events_day_key_quest_id ON tbl_quest_events (day_key, quest_id);
CREATE INDEX IF NOT EXISTS idx_tbl_quest_events_event_type ON tbl_quest_events (event_type);
CREATE INDEX IF NOT EXISTS idx_tbl_quest_events_deleted_at ON tbl_quest_events (deleted_at);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_quest_events_actor_id') THEN
        ALTER TABLE tbl_quest_events ADD CONSTRAINT fk_tbl_quest_events_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_quest_events_quest_id') THEN
        ALTER TABLE tbl_quest_events ADD CONSTRAINT fk_tbl_quest_events_quest_id FOREIGN KEY (quest_id) REFERENCES tbl_quest_definitions(id);
    END IF;
END $$;
