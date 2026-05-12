# Vocabunny Migrations

![VocaBunny](https://img.shields.io/badge/VocabBunny-🐰%20Language%20Learning-ff69b4)
![Version](https://img.shields.io/badge/version-1.0.0-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Database](https://img.shields.io/badge/database-PostgreSQL-blue)
![Migration](https://img.shields.io/badge/migration-golang--migrate-orange)
![Architecture](https://img.shields.io/badge/architecture-microservices-lightgrey)

This repository contains **database migration scripts** for the VocabBunny platform.
It is designed to support a **microservice architecture**, where each service manages
its own database schema while sharing common migration standards.

---

## Structure

Migrations are now stored in a single folder:

```text
migration/
└── schema/
    ├── 0001_shared_extensions.up.sql
    ├── 0001_shared_extensions.down.sql
    ├── ...
    ├── 0053_items_item_consumptions.up.sql
    └── 0053_items_item_consumptions.down.sql
```

This removes cross-folder ordering problems and keeps a single global migration version sequence in `schema_migrations`.

## Ordered Migration List

The current global order is:

<details>
  <summary>details</summary>

```text
migrations/
└── schema/
    ├── 0001_shared_extensions
    ├── 0002_shared_enums
    ├── 0003_shared_base_functions
    ├── 0004_identity_users
    ├── 0005_identity_roles
    ├── 0006_identity_user_roles
    ├── 0007_identity_role_permissions
    ├── 0008_identity_auth_identities
    ├── 0009_actor_guests
    ├── 0010_actor_identity
    ├── 0011_actor_user_devices
    ├── 0012_media_assets
    ├── 0013_content_sections
    ├── 0014_content_lessons
    ├── 0015_content_units
    ├── 0016_content_question_sets
    ├── 0017_content_questions
    ├── 0018_content_question_choices
    ├── 0019_content_tags
    ├── 0020_content_question_tags
    ├── 0021_items_catalog
    ├── 0022_items_actor_inventory
    ├── 0023_items_gacha_rolls
    ├── 0024_items_shop_orders
    ├── 0025_items_shop_order_items
    ├── 0026_items_shop_purchase_requests
    ├── 0027_quests_definitions
    ├── 0028_quests_daily_quest_sets
    ├── 0029_quests_daily_quest_set_items
    ├── 0030_quests_actor_daily_quests
    ├── 0031_quests_quest_events
    ├── 0032_attempts_question_set_attempts
    ├── 0033_attempts_question_attempts
    ├── 0034_attempts_actor_progress
    ├── 0035_streaks_actor_streaks
    ├── 0036_streaks_streak_events
    ├── 0037_streaks_streak_milestones
    ├── 0038_streaks_streak_rewards_claimed
    ├── 0039_achievements_trophy_tiers
    ├── 0040_achievements_actor_monthly_progress
    ├── 0041_achievements_actor_trophies
    ├── 0042_achievements_actor_showcase
    ├── 0043_stats_exp_ledger
    ├── 0044_stats_actor_stats
    ├── 0045_leaderboard_weekly
    ├── 0046_social_actor_relations
    ├── 0047_economy_actor_wallets
    ├── 0048_economy_coin_ledger
    ├── 0049_economy_coin_transactions
    ├── 0050_buffs_actor_buffs
    ├── 0051_buffs_buff_activation_requests
    ├── 0052_analytics_events
    └── 0053_items_item_consumptions
```

</details>

Every version must have both an `.up.sql` and `.down.sql` file with the same version prefix.

## API Usage

Start the service:

```bash
go run .
```

Health check:

```bash
curl http://localhost:1323/health
```

Run all migrations:

```bash
curl -X POST http://localhost:1323/up \
  -H 'Content-Type: application/json' \
  -d '{}'
```

The default payload resolves to:

```json
{
  "migrations": [
    {
      "type": "schema",
      "forceVersion": 0
    }
  ]
}
```

Run schema and data migrations together:

```bash
curl -X POST http://localhost:1323/up \
  -H 'Content-Type: application/json' \
  -d '{
    "migrations": [
      {
        "type": "schema",
        "forceVersion": 0
      },
      {
        "type": "data",
        "forceVersion": 0
      }
    ]
  }'
```

Rollback with explicit step count:

```bash
curl -X POST http://localhost:1323/down \
  -H 'Content-Type: application/json' \
  -d '{
    "migrations": [
      {
        "type": "schema",
        "forceVersion": 1
      }
    ]
  }'
```

## Naming Rules

- Format: `0001_domain_description.up.sql` and `0001_domain_description.down.sql`
- Version numbers are global, unique, increasing, and zero-padded to 4 digits
- Domain prefixes such as `shared`, `identity`, `actor`, `content`, or `items` are used for readability only
- Once a migration has been applied in a shared environment, do not edit it; add a new migration instead

## Operational Notes

- Use a fresh development database after renumbering or moving migration files
- `down` migrations should be used only in development or staging
- Production rollback should be handled with forward-fix migrations when possible

---

_© 2026 VocabBunny. Released under the MIT License._
