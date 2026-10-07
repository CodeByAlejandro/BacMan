CREATE TABLE schedules
(
    id              INTEGER PRIMARY KEY,

    backup_id       INTEGER NOT NULL,

    cron_expression TEXT    NOT NULL,

    active          INTEGER NOT NULL DEFAULT 1,
    -- 0 = INACTIVE
    -- 1 = ACTIVE

    next_run_at     TEXT,

    last_run_at     TEXT,
    last_run_status TEXT,
    -- IN_PROGRESS | COMPLETED | FAILED

    created_at      TEXT    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at      TEXT    NOT NULL,

    UNIQUE (backup_id, cron_expression),
    CHECK (cron_expression != ''),
    CHECK (active IN (0, 1)),
    CHECK (last_run_status IN ('IN_PROGRESS', 'COMPLETED', 'FAILED')),

    FOREIGN KEY (backup_id)
        REFERENCES backups (id)
        ON DELETE CASCADE
);

CREATE INDEX idx_schedules_backup_active_next_run_at
    ON schedules (backup_id, active, next_run_at)
    WHERE active = 1;

CREATE INDEX idx_schedules_active_next_run_at
    ON schedules (active, next_run_at)
    WHERE active = 1;

CREATE INDEX idx_schedules_backup_last_run_at
    ON schedules (backup_id, last_run_at);

CREATE INDEX idx_schedules_backup_last_run_status
    ON schedules (backup_id, last_run_status);