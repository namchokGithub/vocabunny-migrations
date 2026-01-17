-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_actor_relations (
  actor_id uuid NOT NULL,
  target_actor_id uuid NOT NULL,
  relation_type actor_relation_type NOT NULL,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  PRIMARY KEY (actor_id, target_actor_id)
);
CREATE INDEX idx_tbl_actor_relations_target_actor_id ON tbl_actor_relations (target_actor_id);
CREATE INDEX idx_tbl_actor_relations_relation_type ON tbl_actor_relations (relation_type);
CREATE INDEX idx_tbl_actor_relations_deleted_at ON tbl_actor_relations (deleted_at);
ALTER TABLE tbl_actor_relations ADD CONSTRAINT fk_tbl_actor_relations_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_actor_relations ADD CONSTRAINT fk_tbl_actor_relations_target_actor_id FOREIGN KEY (target_actor_id) REFERENCES tbl_actor_identity(actor_id);
