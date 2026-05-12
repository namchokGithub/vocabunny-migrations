# AGENTS.md — VocabBunny Migrations

This file describes how AI agents and contributors should understand, navigate, and extend this repository.

## What this repo is

A standalone Go microservice that applies PostgreSQL database migrations for the VocabBunny language-learning platform. It exposes a small HTTP API (Echo) over which other services or CI/CD pipelines trigger `up` / `down` migrations using the `golang-migrate` library.

## Repository layout

```
migration/
  schema/        # DDL migrations — global sequential version numbers (0001–0054+)
  data/          # DML seed migrations — separate version sequence tracked in data_migrations
services/
  handler.go     # Echo route handlers (UpDB, DownDB)
  service.go     # Migration driver logic (Up, Down)
  request.go     # Request/Migrations structs
main.go          # HTTP server bootstrap, DB connection, graceful shutdown
dbml/
  vocabunny.dbml # Full schema documented in DBML format (Thai annotations)
configs/
  config.yml.example
```

## How migrations work

- **Schema migrations**: tracked in the standard `schema_migrations` table (golang-migrate default).
- **Data migrations**: tracked in a separate `data_migrations` table. Each file under `migration/data/` belongs to its own version sequence.
- The `Up` and `Down` HTTP endpoints accept a `migrations` array so both types can be triggered in one call.
- `forceVersion` in the request body forces the migrator to a specific version before running (useful for recovery).

## Migration naming convention

```
NNNN_domain_description.up.sql
NNNN_domain_description.down.sql
```

- `NNNN` — 4-digit zero-padded global sequence number (schema) or local sequence (data)
- Domain prefixes used for readability only: `shared`, `identity`, `actor`, `content`, `media`, `items`, `quests`, `attempts`, `streaks`, `achievements`, `stats`, `leaderboard`, `social`, `economy`, `buffs`, `analytics`
- Every migration must have both `.up.sql` and `.down.sql`

## Domain coverage (schema)

| Range     | Domain             |
|-----------|--------------------|
| 0001–0003 | shared (extensions, enums, base functions) |
| 0004–0008 | identity (users, roles, permissions, auth) |
| 0009–0011 | actor (guests, identity link, devices) |
| 0012      | media (assets) |
| 0013–0020 | content (sections, lessons, units, question sets, questions, choices, tags) |
| 0021–0026 | items (catalog, inventory, gacha, shop) |
| 0027–0031 | quests (definitions, daily sets, actor progress, events) |
| 0032–0034 | attempts (question set attempts, question attempts, actor progress) |
| 0035–0038 | streaks (actor streaks, events, milestones, rewards) |
| 0039–0042 | achievements (trophy tiers, monthly progress, trophies, showcase) |
| 0043–0044 | stats (exp ledger, actor stats) |
| 0045      | leaderboard (weekly) |
| 0046      | social (actor relations) |
| 0047–0049 | economy (wallets, coin ledger, transactions) |
| 0050–0051 | buffs (actor buffs, activation requests) |
| 0052      | analytics (events) |
| 0053      | items (item consumptions) |
| 0054      | content (tags: add color column) |

## Rules for agents adding migrations

1. Never edit an applied migration — add a new one with the next version number.
2. Always provide both `.up.sql` and `.down.sql`.
3. Update the migration list in `README.md` when adding new files.
4. Use `IF NOT EXISTS` / `IF EXISTS` guards in DDL for idempotency where appropriate.
5. Use `ON CONFLICT ... DO UPDATE` in data migrations to make seeds idempotent.
6. All tables must follow the soft-delete pattern: include `deleted_at timestamptz`.
7. All primary keys must be UUID.

## Running locally

```bash
# Copy env file
cp configs/config.yml.example .env   # or set env vars directly

go run .

# Health check
curl http://localhost:1323/health

# Run all schema migrations
curl -X POST http://localhost:1323/up -H 'Content-Type: application/json' -d '{}'

# Run schema + data
curl -X POST http://localhost:1323/up -H 'Content-Type: application/json' \
  -d '{"migrations":[{"type":"schema"},{"type":"data"}]}'

# Roll back 1 schema step
curl -X POST http://localhost:1323/down -H 'Content-Type: application/json' \
  -d '{"migrations":[{"type":"schema","forceVersion":1}]}'
```
