CREATE TABLE db_migrations
(
    id             INTEGER PRIMARY KEY,
    migration_file TEXT NOT NULL,
    applied_at     TEXT NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now')),

    CHECK (migration_file != '')
);

CREATE UNIQUE INDEX idx_db_migrations_migration_file
    ON db_migrations (migration_file);

CREATE INDEX idx_db_migrations_applied_at_migration_file
    ON db_migrations (applied_at, migration_file);