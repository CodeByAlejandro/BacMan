CREATE TABLE path_filters
(
    id          INTEGER PRIMARY KEY,

    backup_id   INTEGER NOT NULL,

    path_filter TEXT    NOT NULL,
    -- Relative to backups.source_path
    -- Supports *, **, ?, trailing /

    filter_type TEXT    NOT NULL,
    -- EXCLUDE | INCLUDE

    order_index INTEGER NOT NULL,

    created_at  TEXT    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at  TEXT    NOT NULL,

    CONSTRAINT ck_path_filters_path_filter_not_empty CHECK (path_filter != ''),
    CONSTRAINT ck_path_filters_filter_type_valid CHECK (filter_type IN ('EXCLUDE', 'INCLUDE')),
    CONSTRAINT ck_path_filters_order_index_non_negative CHECK (order_index >= 0),

    FOREIGN KEY (backup_id)
        REFERENCES backups (id)
        ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_path_filters_backup_path_filter
    ON path_filters (backup_id, path_filter);

CREATE UNIQUE INDEX idx_path_filters_backup_order
    ON path_filters (backup_id, order_index);