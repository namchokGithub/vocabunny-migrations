-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_user_devices (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  device_fingerprint text,
  device_type text,
  os_name text,
  os_version text,
  app_version text,
  last_ip inet,
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX idx_tbl_user_devices_actor_id ON tbl_user_devices (actor_id);
CREATE INDEX idx_tbl_user_devices_device_fingerprint ON tbl_user_devices (device_fingerprint);
CREATE INDEX idx_tbl_user_devices_actor_id_last_seen_at ON tbl_user_devices (actor_id, last_seen_at);
CREATE INDEX idx_tbl_user_devices_deleted_at ON tbl_user_devices (deleted_at);
ALTER TABLE tbl_user_devices ADD CONSTRAINT fk_tbl_user_devices_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
