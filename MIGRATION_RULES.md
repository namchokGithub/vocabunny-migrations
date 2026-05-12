# MIGRATION_RULES.md — VocabBunny Migration Standards

Rules derived from production readiness review of migrations 0001–0054.
These rules are mandatory. Violations will cause production incidents.

See `risk.md` for the full findings that produced these rules.

---

## 1. Naming

```
NNNN_domain_description.up.sql
NNNN_domain_description.down.sql
```

- `NNNN` — 4-digit zero-padded, global sequential (schema) or local sequential (data)
- Both files required. No `.up.sql` without `.down.sql`.
- Domain prefix from: `shared`, `identity`, `actor`, `content`, `media`, `items`, `quests`, `attempts`, `streaks`, `achievements`, `stats`, `leaderboard`, `social`, `economy`, `buffs`, `analytics`
- Never edit an applied migration. Add a new one.

---

## 2. Table Structure (all new tables)

Every table must include these columns, in this order, at the end:

```sql
created_by  uuid,
updated_by  uuid,
created_at  timestamptz NOT NULL DEFAULT now(),
updated_at  timestamptz NOT NULL DEFAULT now(),
deleted_at  timestamptz
```

- All primary keys: `uuid PRIMARY KEY` (caller supplies the UUID — no `gen_random_uuid()` default)
- Prefix: `tbl_`
- Soft-delete mandatory: `deleted_at timestamptz` (nullable, NULL = active)

---

## 3. UNIQUE Constraints on Soft-Delete Tables — Partial Indexes Only

**Never use inline `UNIQUE` column constraints or non-partial unique indexes on any table that has `deleted_at`.**

Inline `UNIQUE` and non-partial unique indexes include soft-deleted rows. A soft-deleted record blocks re-insertion of the same value permanently.

**Wrong:**
```sql
email text UNIQUE
-- or
CREATE UNIQUE INDEX idx_tbl_users_email ON tbl_users (email);
```

**Correct:**
```sql
email text,
-- ...
CREATE UNIQUE INDEX idx_tbl_users_email_active ON tbl_users (email) WHERE deleted_at IS NULL;
```

Apply this to every unique field: slugs, codes, keys, SKUs, names, provider IDs, etc.

---

## 4. Required Indexes

Every table must have:

```sql
CREATE INDEX IF NOT EXISTS idx_tbl_<name>_deleted_at ON tbl_<name> (deleted_at);
```

No exception. Queries filtering `WHERE deleted_at IS NULL` on tables without this index do full scans.

Additional indexes required by pattern:

| Pattern | Required index |
|---------|---------------|
| FK column | `INDEX ON tbl_child (fk_col)` |
| Ordered list by actor | `INDEX ON tbl_x (actor_id, created_at)` or `(actor_id, order_no)` |
| Status/type filter | `INDEX ON tbl_x (status)` or `(type)` |
| Leaderboard / rank | Use `DESC` explicitly: `INDEX ON tbl_x (week_key, score DESC)` |
| Active-only filter | Partial index: `WHERE deleted_at IS NULL` or `WHERE is_active = true` |

---

## 5. Foreign Keys

Use the idempotent guard pattern for all FK constraints:

```sql
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_tbl_<child>_<col>') THEN
        ALTER TABLE tbl_<child>
          ADD CONSTRAINT fk_tbl_<child>_<col>
          FOREIGN KEY (<col>) REFERENCES tbl_<parent>(id);
    END IF;
END $$;
```

Constraint naming: `fk_tbl_<child_table>_<column_name>`

---

## 6. Enum Types

All discriminator/type/status/event columns must use PostgreSQL enum types, not `text`.

- Define enums in `0002_shared_enums.up.sql` via the idempotent `DO $$ BEGIN IF NOT EXISTS ... END $$` pattern.
- Drop enums in `0002_shared_enums.down.sql` with `CASCADE`.
- Never use `text` for a column whose valid values are a closed set.

**Current enums (0002):** `user_status`, `role_name`, `permission_code`, `storage_mode`, `media_asset_type`, `media_purpose_type`, `storage_provider`, `attempt_status`, `quest_type`, `daily_quest_strategy`, `quest_event_type`, `trophy_tier_code`, `exp_source`, `actor_relation_type`, `coin_source_type`, `item_type`, `gacha_roll_type`, `shop_order_status`, `item_consumption_reason`, `buff_type`

**Known inconsistencies to fix (add enums, then fix columns in new migrations):**
- `tbl_questions.type` → needs `question_type` enum
- `tbl_streak_events.event_type` → needs `streak_event_type` enum
- `tbl_buff_activation_requests.buff_type` → use existing `buff_type` enum

---

## 7. CHECK Constraints for Financial / Counter Columns

Any column representing a quantity, balance, or count that cannot logically go negative must have a CHECK constraint.

```sql
-- Wallet balance
coin_balance bigint NOT NULL DEFAULT 0 CHECK (coin_balance >= 0),

-- Inventory quantity
qty int NOT NULL DEFAULT 0 CHECK (qty >= 0),

-- Multiplier
multiplier numeric NOT NULL DEFAULT 1.0 CHECK (multiplier > 0),
```

This is a DB-level safety net against application-layer race conditions. Do not rely on app logic alone.

---

## 8. Ledger Tables (append-only, high volume)

Tables that are purely append-only and grow without bound (`exp_ledger`, `coin_ledger`, `analytics_events`, event logs):

1. **`balance_after` / running totals must be `NOT NULL`** — nullable running totals break point-in-time reconstruction.
2. **Plan partitioning before first data lands.** Use declarative range partitioning on the time column:

```sql
CREATE TABLE tbl_coin_ledger (...) PARTITION BY RANGE (created_at);
CREATE TABLE tbl_coin_ledger_2025 PARTITION OF tbl_coin_ledger
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```

Retrofitting partitioning after data exists requires a full table rebuild with zero-downtime complexity. Do it upfront.

---

## 9. ADD COLUMN on Live Tables

Adding a column to an existing table with live traffic:

| Condition | Safety |
|-----------|--------|
| `ADD COLUMN ... DEFAULT constant` on PG 11+ | Safe — no table rewrite, brief catalog lock only |
| `ADD COLUMN ... DEFAULT constant` on PG ≤ 10 | **Unsafe** — full table rewrite + `ACCESS EXCLUSIVE` lock |
| `ADD COLUMN NOT NULL` without default | **Unsafe** on any version with existing rows |
| `ADD COLUMN` nullable, no default | Always safe |

**Rule:** Confirm PG ≥ 11 before using `ADD COLUMN ... NOT NULL DEFAULT <constant>`. For all other cases, use the expand-contract pattern:

```sql
-- Step 1 (this migration): add nullable, no default
ALTER TABLE tbl_x ADD COLUMN IF NOT EXISTS new_col text;

-- Step 2 (next migration, after backfill): set NOT NULL
ALTER TABLE tbl_x ALTER COLUMN new_col SET NOT NULL;
```

---

## 10. Indexes on Live Tables

`CREATE INDEX` (without `CONCURRENTLY`) takes `SHARE` lock — blocks writes for the duration on tables with existing data. golang-migrate runs migrations in a transaction, which also prevents `CONCURRENTLY`.

**Rule for new tables:** `CREATE INDEX IF NOT EXISTS` (non-concurrent) is fine — no data, no lock contention.

**Rule for ALTER on existing populated tables:** Add indexes outside the migration transaction using `CREATE INDEX CONCURRENTLY`. This requires a separate migration that disables the transaction wrapper, or a manual step documented in the deployment runbook.

```sql
-- In a migration that must run non-transactionally:
-- NOTE: golang-migrate requires `-- migrate: no-transaction` directive support or manual apply
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_tbl_x_col ON tbl_x (col);
```

---

## 11. Composite Primary Keys and Relation Modeling

When a junction table models a typed relationship (e.g., follow vs. block between two actors), include the type discriminator in the PK:

```sql
-- Wrong: only one relation type per actor pair
PRIMARY KEY (actor_id, target_actor_id)

-- Correct: each relation type is independent
PRIMARY KEY (actor_id, target_actor_id, relation_type)
```

---

## 12. Rollback (`.down.sql`) Rules

| Migration type | `.down.sql` content |
|---------------|---------------------|
| `CREATE TABLE` | `DROP TABLE IF EXISTS tbl_<name>;` |
| `ADD COLUMN` | `ALTER TABLE tbl_<name> DROP COLUMN IF EXISTS <col>;` |
| `CREATE INDEX` | `DROP INDEX IF EXISTS idx_<name>;` |
| `CREATE TYPE` enum | `DROP TYPE IF EXISTS <type> CASCADE;` — always `CASCADE` |
| Data seed (DML) | `DELETE FROM tbl_x WHERE id = '<uuid>' AND <key_col> = '<val>';` |

Down migrations for enum files (e.g., 0002) must use `CASCADE`. Without it, the `DROP TYPE` fails while any column referencing that type exists. The only valid rollback of 0002 is after all tables (0004–0054) have been dropped first.

---

## 13. Data Migrations (DML Seeds)

```sql
INSERT INTO tbl_x (id, col, ...)
VALUES ('<hardcoded-uuid>', 'val', ...)
ON CONFLICT (<unique_col>) DO UPDATE
SET col = EXCLUDED.col,
    updated_at = now(),
    deleted_at = NULL;  -- restore if previously soft-deleted
```

- Always hardcode UUIDs — do not use `gen_random_uuid()` in seeds (non-deterministic, breaks idempotency across environments).
- Rollback: `DELETE FROM tbl_x WHERE id = '<uuid>' AND name = '<val>';` — identify by both UUID and a human key.

---

## 14. Down Endpoint Safety (`services/service.go`)

`forceVersion` in the down request body is **required**. A value of `0` is equivalent to "roll back all steps" — a full schema destruction.

Always supply an explicit step count:

```json
{ "migrations": [{ "type": "schema", "forceVersion": 1 }] }
```

The service enforces this at the code level (`forceVersion == 0` returns an error). Never remove that guard.

---

## 15. Consistency Checklist (pre-merge)

Before merging any new migration, verify:

- [ ] Both `.up.sql` and `.down.sql` exist
- [ ] File follows `NNNN_domain_description.up/down.sql` naming
- [ ] Table has `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`
- [ ] PK is `uuid PRIMARY KEY`
- [ ] No inline `UNIQUE` on any column — only partial unique indexes with `WHERE deleted_at IS NULL`
- [ ] `idx_tbl_<name>_deleted_at` index present
- [ ] All FK columns have an index
- [ ] Discriminator/status/type columns use enum types, not `text`
- [ ] Counter/balance/quantity columns have `CHECK (col >= 0)` or equivalent
- [ ] `ADD COLUMN NOT NULL DEFAULT` only deployed to PG 11+
- [ ] Append-only tables have a partitioning plan
- [ ] `.down.sql` correctly reverses the `.up.sql` operation
- [ ] `README.md` migration list updated
