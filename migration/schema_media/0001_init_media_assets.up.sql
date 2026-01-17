-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_media_assets (
  id uuid PRIMARY KEY,
  owner_actor_id uuid,
  owner_user_id uuid,
  asset_type media_asset_type NOT NULL,
  purpose media_purpose_type NOT NULL,
  storage_mode storage_mode NOT NULL DEFAULT 'EXTERNAL',
  storage_provider storage_provider,
  bucket text,
  object_key text,
  binary_data bytea,
  url text,
  content_type text,
  mime_type text NOT NULL,
  file_size_bytes bigint,
  is_public boolean NOT NULL DEFAULT false,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX idx_tbl_media_assets_storage_mode ON tbl_media_assets (storage_mode);
CREATE INDEX idx_tbl_media_assets_storage_provider_bucket_object_key ON tbl_media_assets (storage_provider, bucket, object_key);
CREATE INDEX idx_tbl_media_assets_owner_actor_id_purpose ON tbl_media_assets (owner_actor_id, purpose);
CREATE INDEX idx_tbl_media_assets_deleted_at ON tbl_media_assets (deleted_at);
