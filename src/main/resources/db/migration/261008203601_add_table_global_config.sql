CREATE TABLE global_config
(
    id                   INTEGER PRIMARY KEY,

    log_directory_path   TEXT NOT NULL,
    database_backup_path TEXT,

    created_at           TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at           TEXT NOT NULL,

    CONSTRAINT ck_global_config_single_row CHECK (id = 1),
    CONSTRAINT ck_global_config_log_directory_path_not_empty CHECK (log_directory_path != ''),
    CONSTRAINT ck_global_config_database_backup_path_not_empty CHECK (database_backup_path IS NULL OR database_backup_path != '')
);