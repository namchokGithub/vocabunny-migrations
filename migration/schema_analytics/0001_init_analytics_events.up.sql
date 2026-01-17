-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_analytics_events (
  id uuid PRIMARY KEY,
  actor_id uuid,
  event_name text NOT NULL,
  properties jsonb,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_analytics_events_event_name_occurred_at ON tbl_analytics_events (event_name, occurred_at);
CREATE INDEX idx_tbl_analytics_events_actor_id_occurred_at ON tbl_analytics_events (actor_id, occurred_at);
CREATE INDEX idx_tbl_analytics_events_deleted_at ON tbl_analytics_events (deleted_at);
ALTER TABLE tbl_analytics_events ADD CONSTRAINT fk_tbl_analytics_events_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
