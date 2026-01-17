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

## 📂 Structure (Not completed yet)

<details>
  <summary>คลิกเพื่อดูโครงสร้างไฟล์ (Migrations)</summary>

```text
migrations/
├── schema_shared/
│   ├── 0001_extensions.up.sql
│   ├── 0001_extensions.down.sql
│   ├── 0002_enums.up.sql
│   ├── 0002_enums.down.sql
│   ├── 0003_base_functions.up.sql
│   └── 0003_base_functions.down.sql
│
├── schema_content/
│   ├── 0001_init_sections.up.sql
│   ├── 0001_init_sections.down.sql
│   ├── 0002_init_lessons.up.sql
│   ├── 0002_init_lessons.down.sql
│   ├── 0003_init_units.up.sql
│   ├── 0003_init_units.down.sql
│   ├── 0004_init_question_sets.up.sql
│   ├── 0004_init_question_sets.down.sql
│   ├── 0005_init_questions.up.sql
│   ├── 0005_init_questions.down.sql
│   ├── 0006_init_question_choices.up.sql
│   ├── 0006_init_question_choices.down.sql
│   ├── 0007_init_tags.up.sql
│   ├── 0007_init_tags.down.sql
│   ├── 0008_init_question_tags.up.sql
│   └── 0008_init_question_tags.down.sql
│
├── schema_identity/
│   ├── 0001_init_users.up.sql
│   ├── 0001_init_users.down.sql
│   ├── 0002_init_roles.up.sql
│   ├── 0002_init_roles.down.sql
│   ├── 0003_init_user_roles.up.sql
│   ├── 0003_init_user_roles.down.sql
│   ├── 0004_init_role_permissions.up.sql
│   ├── 0004_init_role_permissions.down.sql
│   ├── 0005_init_auth_identities.up.sql
│   └── 0005_init_auth_identities.down.sql
│
├── schema_actor/
│   ├── 0001_init_actor_identity.up.sql
│   ├── 0001_init_actor_identity.down.sql
│   ├── 0002_init_guests.up.sql
│   ├── 0002_init_guests.down.sql
│   ├── 0003_init_user_devices.up.sql
│   └── 0003_init_user_devices.down.sql
│
├── schema_media/
│   ├── 0001_init_media_assets.up.sql
│   └── 0001_init_media_assets.down.sql
│
├── schema_attempts/
│   ├── 0001_init_question_set_attempts.up.sql
│   ├── 0001_init_question_set_attempts.down.sql
│   ├── 0002_init_question_attempts.up.sql
│   ├── 0002_init_question_attempts.down.sql
│   ├── 0003_init_actor_progress.up.sql
│   └── 0003_init_actor_progress.down.sql
│
├── schema_streaks/
│   ├── 0001_init_actor_streaks.up.sql
│   ├── 0001_init_actor_streaks.down.sql
│   ├── 0002_init_streak_events.up.sql
│   ├── 0002_init_streak_events.down.sql
│   ├── 0003_init_streak_milestones.up.sql
│   ├── 0003_init_streak_milestones.down.sql
│   ├── 0004_init_streak_rewards_claimed.up.sql
│   └── 0004_init_streak_rewards_claimed.down.sql
│
├── schema_quests/
│   ├── 0001_init_quest_definitions.up.sql
│   ├── 0001_init_quest_definitions.down.sql
│   ├── 0002_init_daily_quest_sets.up.sql
│   ├── 0002_init_daily_quest_sets.down.sql
│   ├── 0003_init_daily_quest_set_items.up.sql
│   ├── 0003_init_daily_quest_set_items.down.sql
│   ├── 0004_init_actor_daily_quests.up.sql
│   ├── 0004_init_actor_daily_quests.down.sql
│   ├── 0005_init_quest_events.up.sql
│   └── 0005_init_quest_events.down.sql
│
├── schema_achievements/
│   ├── 0001_init_trophy_tiers.up.sql
│   ├── 0001_init_trophy_tiers.down.sql
│   ├── 0002_init_actor_monthly_progress.up.sql
│   ├── 0002_init_actor_monthly_progress.down.sql
│   ├── 0003_init_actor_trophies.up.sql
│   ├── 0003_init_actor_trophies.down.sql
│   ├── 0004_init_actor_showcase.up.sql
│   └── 0004_init_actor_showcase.down.sql
│
├── schema_stats/
│   ├── 0001_init_exp_ledger.up.sql
│   ├── 0001_init_exp_ledger.down.sql
│   ├── 0002_init_actor_stats.up.sql
│   └── 0002_init_actor_stats.down.sql
│
├── schema_leaderboard/
│   ├── 0001_init_leaderboard_weekly.up.sql
│   └── 0001_init_leaderboard_weekly.down.sql
│
├── schema_social/
│   ├── 0001_init_actor_relations.up.sql
│   └── 0001_init_actor_relations.down.sql
│
├── schema_economy/
│   ├── 0001_init_actor_wallets.up.sql
│   ├── 0001_init_actor_wallets.down.sql
│   ├── 0002_init_coin_ledger.up.sql
│   ├── 0002_init_coin_ledger.down.sql
│   ├── 0003_init_coin_transactions.up.sql
│   └── 0003_init_coin_transactions.down.sql
│
├── schema_items/
│   ├── 0001_init_item_catalog.up.sql
│   ├── 0001_init_item_catalog.down.sql
│   ├── 0002_init_actor_inventory.up.sql
│   ├── 0002_init_actor_inventory.down.sql
│   ├── 0003_init_gacha_rolls.up.sql
│   ├── 0003_init_gacha_rolls.down.sql
│   ├── 0004_init_shop_orders.up.sql
│   ├── 0004_init_shop_orders.down.sql
│   ├── 0005_init_shop_order_items.up.sql
│   ├── 0005_init_shop_order_items.down.sql
│   ├── 0006_init_shop_purchase_requests.up.sql
│   ├── 0006_init_shop_purchase_requests.down.sql
│   ├── 0007_init_item_consumptions.up.sql
│   └── 0007_init_item_consumptions.down.sql
│
├── schema_buffs/
│   ├── 0001_init_actor_buffs.up.sql
│   ├── 0001_init_actor_buffs.down.sql
│   ├── 0002_init_buff_activation_requests.up.sql
│   └── 0002_init_buff_activation_requests.down.sql
│
└── schema_analytics/
    ├── 0001_init_analytics_events.up.sql
    └── 0001_init_analytics_events.down.sql
```

</details>

## 🚀 Usage

#### 1. Add new sql script to migration/db

How to [Naming](#naming-rules).

#### 2. Run postman to dev env to migration db up test

> [POST] `http://localhost:1323/up`

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

#### 3. How to sit migration down

> [POST] `http://localhost:1323/down`

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

## 🧱 Migration Naming Convention

### Naming Rules

- Format: `0001_description.up.sql` and `0001_description.down.sql`
- Version numbers are incremental and start from `0001` (zero-padded to 4 digits)
- Each migration must have a unique and increasing version number

### Examples

- `0001_init_sections.up.sql` / `0001_init_sections.down.sql`
- `0002_init_lessons.up.sql` / `0002_init_lessons.down.sql`
- `0003_init_user_devices.up.sql` / `0003_init_user_devices.down.sql`

Once a migration is applied, it **must not be edited**.

## 🌍 Supported Environments

- Development
- Staging
- Production

Each environment should use a separate database instance.

## 🔄 Rollback Policy

- `down` migrations should be used only in development or staging
- Production rollback should be handled via forward-fix migrations
- Forced versioning must be used with caution

## 🔌 Migration API

The migration endpoints are exposed by a dedicated internal service.
They should not be publicly accessible and must be protected in non-development environments.
</br></br>

---

_© 2026 VocabBunny. Released under the MIT License._
