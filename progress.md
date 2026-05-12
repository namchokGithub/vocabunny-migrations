# Progress — VocabBunny Migrations

_Last updated: 2026-05-13_

## Project goal

Build and maintain the PostgreSQL migration service for the VocabBunny language-learning platform. The service applies schema (DDL) and data (DML) migrations via a REST API backed by `golang-migrate`.

---

## What has been done

### Foundation
- Bootstrapped Go project with Echo HTTP server and `golang-migrate` (postgres driver).
- `main.go` handles DB connection, graceful shutdown, and health endpoint.
- `services/` layer separates HTTP handler logic from migration driver logic.

### Migration structure redesign
- Moved from per-service/per-folder migrations to a **single flat folder** (`migration/schema/`) with a global version sequence.
- Added a **separate `migration/data/`** folder for DML seeds, tracked independently via `data_migrations` table.

### Schema migrations (0001–0054)
All core platform domains are covered. See AGENTS.md for the full domain-to-range table.

Notable milestones:
- `0001–0003` — Shared PostgreSQL extensions, enums, and trigger functions
- `0004–0011` — Full identity + actor stack (users, roles, permissions, auth identities, guests, devices)
- `0013–0020` — Content hierarchy (sections → lessons → units → question sets → questions → choices → tags)
- `0021–0053` — Items, quests, attempts, streaks, achievements, stats, leaderboard, social, economy, buffs, analytics
- `0054` — Added `color` column (`text NOT NULL DEFAULT '#60A5FA'`) to `tbl_tags`

### Data migrations (0001)
- `0001_content_default_student_tag` — Seeds the default "Student" tag (UUID `2d055627-...`, color `#60A5FA`) using `ON CONFLICT DO UPDATE` for idempotency.

### Documentation
- `README.md` — Full API usage, naming rules, migration list, operational notes.
- `dbml/vocabunny.dbml` — Schema documented in DBML with Thai-language annotations per column.
- `AGENTS.md` — Agent/contributor guide for navigating and extending this repo.

---

## Key decisions made

| Decision | Rationale |
|---|---|
| Single flat `migration/schema/` folder | Eliminates cross-folder ordering bugs; single global `schema_migrations` version sequence |
| Separate `migration/data/` with its own tracking table | Allows DDL and DML migrations to run and version independently |
| REST API instead of CLI | Other services and CI/CD can trigger migrations over HTTP without shipping the binary or config |
| `forceVersion` field in request | Provides a recovery escape hatch when the DB state is dirty or out of sync |
| Down via `m.Steps(negative diff)` | Calculates rollback steps relative to current version rather than an absolute target |
| UUID PKs everywhere | Forward-compatible with distributed systems and future cross-service references |
| Soft deletes (`deleted_at`) on all tables | Preserves referential history; avoids FK cascade headaches in analytics/audit contexts |
| `ON CONFLICT DO UPDATE` in data seeds | Makes data migrations safe to re-run; idempotent by design |
| Domain-prefixed filenames | Human-readable grouping without enforcing separate version sequences per domain |
| DBML with Thai annotations | Content team and Thai-speaking stakeholders can read schema intent without SQL expertise |

---

## Current migration count

- Schema: **54 migrations** (0001–0054)
- Data: **1 migration** (0001)

---

## 2026-05-13 — Production Readiness Review

### What was done

Full review of all 54 schema migrations and 1 data migration against production criteria:
zero-downtime deployment, live traffic, millions of rows, Go + PostgreSQL API-first architecture.

Produced two new documents:
- **`risk.md`** — 14 prioritized findings with SQL fix examples
- **`MIGRATION_RULES.md`** — 15 mandatory rules for all future migrations, derived from findings

### Critical findings (must fix before production)

| # | Issue | Affected |
|---|-------|----------|
| 1 | UNIQUE constraints include soft-deleted rows — blocks re-registration, re-linking, re-use of slugs/codes/keys | 0004, 0008, 0013, 0019, 0021, 0027, 0037 |
| 2 | `tbl_actor_relations` PK missing `relation_type` — FOLLOW + BLOCK on same target pair impossible | 0046 |
| 3 | `coin_balance` no `CHECK (>= 0)` — concurrent debits can go negative | 0047 |
| 4 | `qty` no `CHECK (>= 0)` — item consumption race can drain inventory below zero | 0022 |
| 5 | `tbl_actor_showcase` FK only checks tier exists, not that actor earned it | 0042 |
| 6 | `Service.Down()` with `forceVersion=0` rolls back all steps — full schema destruction | service.go:104 |

### Risk findings (performance / data quality)

- `tbl_user_devices` UNIQUE on `actor_id` includes deleted rows → blocks device re-registration (0011)
- `tbl_sections` missing `deleted_at` index → full scans on every soft-delete filter (0013)
- Leaderboard index stores `weekly_exp` ASC, rank queries need DESC → wrong sort (0045)
- `tbl_leaderboard_weekly.display_name` denormalized → goes stale on user rename (0045)
- `tbl_coin_ledger.balance_after` nullable → breaks point-in-time ledger reconstruction (0048)
- No partitioning on `tbl_exp_ledger`, `tbl_coin_ledger`, `tbl_analytics_events` → unbounded growth (0043, 0048, 0052)
- Missing composite index `(actor_id, day_key, is_completed, reward_claimed)` for daily quest reward queries (0030)
- No partial unique index on active buffs per type → multiple concurrent active buffs possible (0050)

### Key rules established (MIGRATION_RULES.md)

| Rule | Summary |
|------|---------|
| Partial unique indexes | All `UNIQUE` on soft-delete tables must use `WHERE deleted_at IS NULL` |
| `deleted_at` index mandatory | Every table must have `idx_tbl_<name>_deleted_at` |
| Enum types only | No `text` for closed-value-set columns; define in 0002 |
| CHECK constraints | All balance/quantity/counter columns need `CHECK (col >= 0)` |
| Ledger `balance_after` NOT NULL | Running totals must be supplied by writer, never NULL |
| Partitioning upfront | Append-only tables partitioned before first data, not after |
| `ADD COLUMN NOT NULL DEFAULT` | Safe only on PG 11+; use expand-contract on PG ≤ 10 |
| `forceVersion` required for down | `0` is banned — guard enforced in service layer |
| Pre-merge checklist | 13-point checklist added to MIGRATION_RULES.md |

---

## Pending / next steps

- [ ] **Fix risk.md items 1–6** — create corrective migrations (0055+) for all critical findings
- [ ] Add partial unique indexes to 0004, 0008, 0013, 0019, 0021, 0027, 0037 via new migrations
- [ ] Fix `tbl_actor_relations` PK (0046 corrective)
- [ ] Add CHECK constraints to `tbl_actor_wallets` and `tbl_actor_inventory`
- [ ] Fix `service.go:104` — guard `forceVersion == 0` in `Down()`
- [ ] Add partitioning plan for ledger + analytics tables
- [ ] Add remaining data seeds as domain content is finalized
- [ ] Integrate migration service into CI/CD pipeline for staging auto-apply
- [ ] Consider adding `GET /status` endpoint to expose current migration version per type
