# Migration Risk Review

Production readiness review of all 54 schema migrations + 1 data migration.
Assumptions: live traffic, PostgreSQL 11+, millions of rows, zero-downtime deployment.

---

## 🔴 Critical — Fix Before Production

### 1. UNIQUE constraints include soft-deleted rows (systemic)

**Affected:** 0004, 0008, 0013, 0019, 0021, 0027, 0037

Every table that combines soft-delete (`deleted_at`) with a `UNIQUE` constraint will reject re-insertion of the same value after a soft-delete. A user deleted and re-registered with the same email hits a constraint violation immediately.

Affected columns:
- `tbl_users.email`, `tbl_users.username` (0004)
- `tbl_auth_identities (provider, provider_user_id)` (0008)
- `tbl_sections.slug` (0013)
- `tbl_tags.name` (0019)
- `tbl_items.key`, `tbl_item_catalog.sku` (0021)
- `tbl_quest_definitions.code` (0027)
- `tbl_streak_milestones.days` (0037)

**Fix:** Replace all inline `UNIQUE` column constraints and non-partial unique indexes with partial indexes:

```sql
-- Example for tbl_users
ALTER TABLE tbl_users DROP CONSTRAINT tbl_users_email_key;
ALTER TABLE tbl_users DROP CONSTRAINT tbl_users_username_key;
CREATE UNIQUE INDEX idx_tbl_users_email_active ON tbl_users (email) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_tbl_users_username_active ON tbl_users (username) WHERE deleted_at IS NULL;
```

Apply same pattern to all affected tables above.

---

### 2. `tbl_actor_relations` PK missing `relation_type` (0046)

`PRIMARY KEY (actor_id, target_actor_id)` means an actor can hold exactly one relation type to any target. If actor A follows B, then tries to block B — the PK conflicts. FOLLOW and BLOCK cannot coexist.

**Fix:**
```sql
-- Replace PK
PRIMARY KEY (actor_id, target_actor_id, relation_type)
```

---

### 3. `tbl_actor_wallets.coin_balance` allows negative values (0047)

No `CHECK` constraint. Concurrent debit requests can race past the application-layer balance check and produce a negative balance.

**Fix:**
```sql
ALTER TABLE tbl_actor_wallets ADD CONSTRAINT chk_coin_balance_non_negative CHECK (coin_balance >= 0);
```
Also enforce `SELECT ... FOR UPDATE` in the debit path.

---

### 4. `tbl_actor_inventory.qty` allows negative values (0022)

Same race condition as above. Item consumption can drain qty below zero.

**Fix:**
```sql
ALTER TABLE tbl_actor_inventory ADD CONSTRAINT chk_qty_non_negative CHECK (qty >= 0);
```

---

### 5. `tbl_actor_showcase` can reference unearned trophy (0042)

`showcase_trophy_tier_id` FK references `tbl_trophy_tiers(id)` only. No constraint verifies the actor actually holds that trophy. An actor can showcase any trophy tier regardless of their achievement record.

**Fix:** Add composite FK to `tbl_actor_trophies`:
```sql
ALTER TABLE tbl_actor_showcase
  ADD CONSTRAINT fk_tbl_actor_showcase_earned_trophy
  FOREIGN KEY (actor_id, showcase_trophy_month_key, showcase_trophy_tier_id)
  REFERENCES tbl_actor_trophies(actor_id, month_key, trophy_tier_id);
```
Requires `showcase_trophy_month_key NOT NULL` when `showcase_trophy_tier_id` is set.

---

### 6. `Service.Down()` rolls back everything when `ForceVersion` is 0 (`services/service.go:104`)

```go
forceVersion := (int(curVersion) - migration.ForceVersion) * -1
```

If `ForceVersion` is omitted (defaults to 0), result is `-curVersion` — rolls back the entire schema. No guard exists. A misconfigured POST `/down` with `{}` body destroys all data structure.

**Fix:**
```go
if migration.ForceVersion == 0 {
    return errors.New("forceVersion is required for down migrations")
}
```

---

## 🟡 Risk — Performance / Zero-Downtime / Data Quality

### 7. One device per actor UNIQUE index includes soft-deleted rows (0011)

`CREATE UNIQUE INDEX idx_tbl_user_devices_actor_id ON tbl_user_devices (actor_id)` — soft-deleted device record blocks new device registration for same actor.

**Fix:**
```sql
-- Replace with partial index
DROP INDEX idx_tbl_user_devices_actor_id;
CREATE UNIQUE INDEX idx_tbl_user_devices_actor_id_active ON tbl_user_devices (actor_id) WHERE deleted_at IS NULL;
```

---

### 8. `tbl_sections` missing `deleted_at` index (0013)

Every other table has `idx_tbl_<name>_deleted_at`. Sections is the only exception. Queries filtering `WHERE deleted_at IS NULL` on sections will scan the full table.

**Fix:**
```sql
CREATE INDEX IF NOT EXISTS idx_tbl_sections_deleted_at ON tbl_sections (deleted_at);
```

---

### 9. Leaderboard index wrong sort order; stale `display_name` (0045)

Index `(week_key, weekly_exp, updated_at)` stores `weekly_exp` ASC. Rank queries use `ORDER BY weekly_exp DESC` — descending sort will not use this index efficiently.

`display_name` is denormalized from `tbl_users`. Goes stale when user updates display name.

**Fix:**
```sql
-- Replace index
DROP INDEX idx_tbl_leaderboard_weekly_week_key_weekly_exp_updated_at;
CREATE INDEX idx_tbl_leaderboard_weekly_rank ON tbl_leaderboard_weekly (week_key, weekly_exp DESC);
```
Remove `display_name` column and JOIN to `tbl_users` at query time, or add an app-layer update path when display_name changes.

---

### 10. `tbl_coin_ledger.balance_after` is nullable (0048)

A NULL `balance_after` makes point-in-time balance reconstruction from the ledger impossible. The ledger loses its auditability guarantee.

**Fix:** Change to `NOT NULL` — require the writer to compute and supply it:
```sql
balance_after bigint NOT NULL
```

---

### 11. No partitioning on append-only tables (0043, 0048, 0052)

`tbl_exp_ledger`, `tbl_coin_ledger`, and `tbl_analytics_events` are unbounded append-only tables. At millions of rows query performance degrades with no partition pruning. Retrofitting partitioning after data exists is painful.

**Fix:** Add declarative range partitioning on `created_at` before first data lands:
```sql
-- Example
CREATE TABLE tbl_analytics_events (...) PARTITION BY RANGE (occurred_at);
CREATE TABLE tbl_analytics_events_2025 PARTITION OF tbl_analytics_events
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
```
At minimum, document the archiving/partition strategy in `AGENTS.md`.

---

### 12. Missing composite index for daily quest reward queries (0030)

Fetching an actor's unclaimed completed quests today requires filtering `actor_id`, `day_key`, `is_completed`, and `reward_claimed`. Existing `(actor_id, day_key)` index covers the first two columns only.

**Fix:**
```sql
CREATE INDEX idx_tbl_actor_daily_quests_actor_day_claim ON tbl_actor_daily_quests
  (actor_id, day_key, is_completed, reward_claimed);
```

---

### 13. No uniqueness guard on active buffs per type (0050)

No constraint prevents multiple active buffs of the same type for one actor. If only one-active-per-type is intended, concurrent buff activation can create duplicates.

**Fix (if one-active-per-type intended):**
```sql
CREATE UNIQUE INDEX idx_tbl_actor_buffs_one_active_per_type
  ON tbl_actor_buffs (actor_id, buff_type)
  WHERE is_active = true AND deleted_at IS NULL;
```

---

### 14. `ALTER TABLE` in 0054 requires PG 11+ for zero-downtime

`ADD COLUMN ... NOT NULL DEFAULT '#60A5FA'` avoids table rewrite on PG11+ (constant default stored in catalog). On PG10 or below, this rewrites the entire `tbl_tags` table — takes an `ACCESS EXCLUSIVE` lock for the duration.

**Fix:** Confirm PG version ≥ 11 before deploying 0054.

---

## 🔵 Nit — Type Consistency

| File | Issue | Fix |
|------|-------|-----|
| 0036 `tbl_streak_events.event_type` | `text` instead of enum | Add `streak_event_type` enum to 0002, reference it |
| 0051 `tbl_buff_activation_requests.buff_type` | `text` while `tbl_actor_buffs` uses `buff_type` enum | Use the `buff_type` enum |
| 0017 `tbl_questions.type` | `text` instead of enum | Define `question_type` enum in 0002 |
| 0053 `tbl_item_consumptions.reason` | Nullable without documented purpose — audit gap | Make `NOT NULL` or document valid NULL case |
| 0017 `tbl_questions.blank_position` | No CHECK tying it to `type = 'FILL_IN_THE_BLANK'` | Add `CHECK (type != 'FILL_IN_THE_BLANK' OR blank_position IS NOT NULL)` |
| 0002.down | `DROP TYPE` without `CASCADE` — fails if any dependent column exists | Add `CASCADE` or document manual rollback order |

---

## Fix Priority

| Priority | Files | Issue |
|----------|-------|-------|
| 1 | 0004, 0008, 0013, 0019, 0021, 0027, 0037 | UNIQUE on soft-delete tables → partial indexes |
| 2 | 0046 | PK missing `relation_type` |
| 3 | 0047 | `coin_balance` no negative guard |
| 4 | 0022 | `qty` no negative guard |
| 5 | 0042 | Showcase can reference unearned trophy |
| 6 | service.go | `ForceVersion=0` rolls back everything |
| 7 | 0011 | UNIQUE device index includes deleted rows |
| 8 | 0013 | Missing `deleted_at` index on sections |
| 9 | 0045 | Leaderboard index wrong order; stale `display_name` |
| 10 | 0048 | `balance_after` nullable breaks ledger integrity |
| 11 | 0043, 0048, 0052 | No partitioning on append-only tables |
