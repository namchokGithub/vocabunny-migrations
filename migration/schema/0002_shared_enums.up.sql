-- Generated from dbml/vocabunny.dbml
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_status') THEN
        CREATE TYPE user_status AS ENUM ('INACTIVE', 'ACTIVE', 'BANNED', 'DELETED');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_name') THEN
        CREATE TYPE role_name AS ENUM ('ADMIN', 'CONTENT_ADMIN', 'MODERATOR', 'USER');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'permission_code') THEN
        CREATE TYPE permission_code AS ENUM ('CONTENT_READ', 'CONTENT_WRITE', 'CONTENT_PUBLISH', 'USER_READ', 'USER_BAN', 'ANALYTICS_READ', 'SYSTEM_CONFIG');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'storage_mode') THEN
        CREATE TYPE storage_mode AS ENUM ('EXTERNAL', 'DATABASE');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'media_asset_type') THEN
        CREATE TYPE media_asset_type AS ENUM ('IMAGE', 'VIDEO', 'DOCUMENT');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'media_purpose_type') THEN
        CREATE TYPE media_purpose_type AS ENUM ('AVATAR', 'QUESTION_IMAGE', 'BADGE_ICON', 'TROPHY_ICON', 'BANNER');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'storage_provider') THEN
        CREATE TYPE storage_provider AS ENUM ('S3', 'R2', 'GCS', 'LOCAL');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'attempt_status') THEN
        CREATE TYPE attempt_status AS ENUM ('STARTED', 'FINISHED', 'ABANDONED');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'quest_type') THEN
        CREATE TYPE quest_type AS ENUM ('COMPLETE_QUIZZES', 'SCORE_THRESHOLD', 'CORRECT_ANSWERS', 'NEW_CATEGORY', 'MAINTAIN_STREAK');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'daily_quest_strategy') THEN
        CREATE TYPE daily_quest_strategy AS ENUM ('RANDOM', 'FIXED_ROTATION');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'quest_event_type') THEN
        CREATE TYPE quest_event_type AS ENUM ('PROGRESS_UPDATED', 'COMPLETED', 'CLAIMED');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trophy_tier_code') THEN
        CREATE TYPE trophy_tier_code AS ENUM ('WOOD', 'STONE', 'COPPER', 'IRON', 'SILVER', 'GOLD', 'PLATINUM', 'MYTHRIL', 'ADAMANTITE', 'OBSIDIAN', 'DIAMOND');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'exp_source') THEN
        CREATE TYPE exp_source AS ENUM ('QUIZ', 'BONUS', 'ADMIN_ADJUST', 'EVENT');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'actor_relation_type') THEN
        CREATE TYPE actor_relation_type AS ENUM ('FOLLOW', 'BLOCK');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'coin_source_type') THEN
        CREATE TYPE coin_source_type AS ENUM ('DAILY_QUEST', 'MONTHLY_TROPHY', 'STREAK_MILESTONE', 'LEVEL_UP', 'SHOP_PURCHASE', 'GACHA', 'ADMIN_ADJUST', 'EVENT', 'REFUND', 'PROMOTION', 'SYSTEM_ADJUST');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'item_type') THEN
        CREATE TYPE item_type AS ENUM ('CONSUMABLE', 'TIMED_BUFF');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'gacha_roll_type') THEN
        CREATE TYPE gacha_roll_type AS ENUM ('FREE_DAILY', 'PAID');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'shop_order_status') THEN
        CREATE TYPE shop_order_status AS ENUM ('COMPLETED', 'CANCELLED', 'FAILED');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'item_consumption_reason') THEN
        CREATE TYPE item_consumption_reason AS ENUM ('STREAK_AUTO_FREEZE', 'USER_ACTION_HINT', 'QUEST_REWARD_USE', 'SYSTEM_EFFECT');
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'buff_type') THEN
        CREATE TYPE buff_type AS ENUM ('EXP_BOOST', 'DOUBLE_COINS', 'STREAK_PROTECT', 'QUIZ_SPEED', 'ACCURACY_BOOST');
    END IF;
END $$;
