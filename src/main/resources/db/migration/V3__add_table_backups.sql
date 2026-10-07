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

    UNIQUE (backup_path),
    CHECK (source_path != ''),
    CHECK (backup_path != ''),
    CHECK (has_file_size_change_detection IN (0, 1)),
    CHECK (has_checksum_change_detection IN (0, 1)),
    CHECK (has_scrub_integrity_checks IN (0, 1))
);