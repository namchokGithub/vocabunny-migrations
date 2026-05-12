# Progress — VocabBunny Migrations

_Last updated: 2026-05-12_

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

## Pending / next steps

- [ ] Add remaining data seeds as domain content is finalized
- [ ] Integrate migration service into CI/CD pipeline for staging auto-apply
- [ ] Consider adding a `GET /status` endpoint to expose current migration version per type
