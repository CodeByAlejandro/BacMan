CREATE TABLE files
(
    id               INTEGER PRIMARY KEY,

    snapshot_id      INTEGER NOT NULL,

    relative_path    TEXT    NOT NULL,
    -- Relative to snapshots.snapshot_path

    mtime            TEXT    NOT NULL,
    size             INTEGER NOT NULL,
    checksum         BLOB    NOT NULL,

    state            TEXT    NOT NULL,
    -- CREATED | STALE | MODIFIED | MOVED | REMOVED

    moved_from_id    INTEGER,
    -- Points to record with state = MOVED (the old location), this record will have state = CREATED

    reliability      TEXT    NOT NULL DEFAULT 'RELIABLE',
    -- RELIABLE | UNRELIABLE

    last_verified_at INTEGER,

    created_at       TEXT    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    updated_at       TEXT    NOT NULL,

    CONSTRAINT ck_files_relative_path_not_empty CHECK (relative_path != ''),
    CONSTRAINT ck_files_size_non_negative CHECK (size >= 0),
    CONSTRAINT ck_files_state_valid CHECK (state IN ('CREATED', 'STALE', 'MODIFIED', 'MOVED', 'REMOVED')),
    CONSTRAINT ck_files_reliability_valid CHECK (reliability IN ('RELIABLE', 'UNRELIABLE')),

    FOREIGN KEY (snapshot_id)
        REFERENCES snapshots (id)
        ON DELETE CASCADE,

    FOREIGN KEY (moved_from_id)
        REFERENCES files (id)
        ON DELETE SET NULL -- Prevent cascading delete errors due to self-referencing
);

CREATE UNIQUE INDEX idx_files_snapshot_path
    ON files (snapshot_id, relative_path);

CREATE INDEX idx_files_snapshot_state
    ON files (snapshot_id, state);

-- Needed for efficient ON DELETE SET NULL
CREATE INDEX idx_files_moved_from
    ON files (moved_from_id)
    WHERE moved_from_id IS NOT NULL;

CREATE INDEX idx_files_checksum
    ON files (checksum);

CREATE INDEX idx_files_scrub
    ON files (reliability, last_verified_at);

CREATE INDEX idx_files_unreliable
    ON files (snapshot_id)
    WHERE reliability = 'UNRELIABLE';