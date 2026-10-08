CREATE TABLE backups
(
    id                             INTEGER PRIMARY KEY,

    source_path                    TEXT    NOT NULL,
    backup_path                    TEXT    NOT NULL,

    has_file_size_change_detection INTEGER NOT NULL DEFAULT 1,
    -- 0 = DISABLED
    -- 1 = ENABLED

    has_checksum_change_detection  INTEGER NOT NULL DEFAULT 0,
    -- 0 = DISABLED
    -- 1 = ENABLED

    has_scrub_integrity_checks     INTEGER NOT NULL DEFAULT 0,
    -- 0 = DISABLED
    -- 1 = ENABLED

    created_at                     TEXT    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at                     TEXT    NOT NULL,

    CONSTRAINT ck_backups_source_path_not_empty CHECK (source_path != ''),
    CONSTRAINT ck_backups_backup_path_not_empty CHECK (backup_path != ''),
    CONSTRAINT ck_backups_file_size_change_detection_bool CHECK (has_file_size_change_detection IN (0, 1)),
    CONSTRAINT ck_backups_checksum_change_detection_bool CHECK (has_checksum_change_detection IN (0, 1)),
    CONSTRAINT ck_backups_scrub_integrity_checks_bool CHECK (has_scrub_integrity_checks IN (0, 1))
);

CREATE UNIQUE INDEX idx_backups_backup_path
    ON backups (backup_path);