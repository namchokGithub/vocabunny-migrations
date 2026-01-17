-- Generated from dbml/vocabunny.dbml
CREATE TABLE tbl_shop_purchase_requests (
  id uuid PRIMARY KEY,
  actor_id uuid NOT NULL,
  client_request_id uuid NOT NULL,
  order_id uuid,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE UNIQUE INDEX idx_tbl_shop_purchase_requests_actor_id_client_request_id ON tbl_shop_purchase_requests (actor_id, client_request_id);
ALTER TABLE tbl_shop_purchase_requests ADD CONSTRAINT fk_tbl_shop_purchase_requests_actor_id FOREIGN KEY (actor_id) REFERENCES tbl_actor_identity(actor_id);
ALTER TABLE tbl_shop_purchase_requests ADD CONSTRAINT fk_tbl_shop_purchase_requests_order_id FOREIGN KEY (order_id) REFERENCES tbl_shop_orders(id);
