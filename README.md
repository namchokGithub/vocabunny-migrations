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

```text
migrations/
├── content/
│   ├── 0001_init_schema.sql
│   └── 0002_add_vocab_table.sql
│
├── identity/
│   ├── 0001_init_schema.sql
│   └── 0002_add_user_device.sql
│
└── shared/
    └── 0001_extensions.sql
```

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
- Format: `X_description.sql`
- Version numbers are incremental and start from `1`
- Each migration must have a unique and increasing version number

### Examples
- `1_init_schema.sql`
- `2_add_vocab_table.sql`
- `3_add_user_device.sql`

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