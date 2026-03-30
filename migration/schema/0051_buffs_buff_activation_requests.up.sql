-- Generated from dbml/vocabunny.dbml
CREATE TABLE IF NOT EXISTS tbl_buff_activation_requests (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  buff_type text NOT NULL,
  client_request_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tbl_buff_activation_requests_actor_id_buff_type_client_request_id ON tbl_buff_activation_requests (actor_id, buff_type, client_request_id);
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_buff_activation_requests_actor_id') THEN
        ALTER TABLE tbl_buff_activation_requests ADD CONSTRAINT fk_tbl_buff_activation_requests_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
    END IF;
END $$;
