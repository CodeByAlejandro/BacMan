CREATE TABLE snapshot_configs
(
    id                             INTEGER PRIMARY KEY,

    backup_id                      INTEGER NOT NULL,

    tracking_policy                TEXT    NOT NULL DEFAULT 'ALL_FILES',
    -- ALL_FILES | DELETED_FILES_ONLY

    has_hardlink_deduplication     INTEGER NOT NULL DEFAULT 1,
    -- 0 = DISABLED
    -- 1 = ENABLED

    snapshot_amount_limit          INTEGER,
    snapshot_age_limit             INTEGER,
    snapshot_cumulative_size_limit INTEGER,

    created_at                     TEXT    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at                     TEXT    NOT NULL,

    CONSTRAINT ck_snapshot_configs_tracking_policy_valid CHECK (tracking_policy IN ('ALL_FILES', 'DELETED_FILES_ONLY')),
    CONSTRAINT ck_snapshot_configs_hardlink_deduplication_bool CHECK (has_hardlink_deduplication IN (0, 1)),
    CONSTRAINT ck_snapshot_configs_amount_limit_min CHECK (snapshot_amount_limit IS NULL OR snapshot_amount_limit >= 1),
    CONSTRAINT ck_snapshot_configs_age_limit_non_negative CHECK (snapshot_age_limit IS NULL OR snapshot_age_limit >= 0),
    CONSTRAINT ck_snapshot_configs_cumulative_size_limit_non_negative CHECK (snapshot_cumulative_size_limit IS NULL OR snapshot_cumulative_size_limit >= 0),

    FOREIGN KEY (backup_id)
        REFERENCES backups (id)
        ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_snapshot_configs_backup
    ON snapshot_configs (backup_id);