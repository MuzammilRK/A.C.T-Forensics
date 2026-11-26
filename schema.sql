PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS cases (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  reference TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL,
  posture_json TEXT NOT NULL DEFAULT '{}'
);
CREATE TABLE IF NOT EXISTS evidence (
  id TEXT PRIMARY KEY,
  case_id TEXT NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  mime TEXT NOT NULL DEFAULT '',
  size_bytes INTEGER NOT NULL CHECK(size_bytes >= 0),
  kind TEXT NOT NULL CHECK(kind IN ('image','video','audio','document','code','unknown')),
  sha256 TEXT NOT NULL,
  hash_registered_at TEXT NOT NULL,
  added_at TEXT NOT NULL,
  source TEXT NOT NULL CHECK(source IN ('upload','demo')),
  analysis_json TEXT NOT NULL,
  region_query_json TEXT,
  integrity_json TEXT,
  text_query_json TEXT
);
CREATE INDEX IF NOT EXISTS idx_evidence_case_added ON evidence(case_id, added_at DESC);
CREATE TABLE IF NOT EXISTS scans (
  id TEXT PRIMARY KEY,
  case_id TEXT NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  kind TEXT NOT NULL CHECK(kind IN ('source','dependencies','posture')),
  target TEXT NOT NULL,
  created_at TEXT NOT NULL,
  score INTEGER NOT NULL CHECK(score BETWEEN 0 AND 100),
  grade TEXT NOT NULL,
  findings_json TEXT NOT NULL DEFAULT '[]',
  stats_json TEXT NOT NULL DEFAULT '{}'
);
CREATE INDEX IF NOT EXISTS idx_scans_case_created ON scans(case_id, created_at DESC);
CREATE TABLE IF NOT EXISTS website_audits (
  id TEXT PRIMARY KEY,
  case_id TEXT NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  host TEXT NOT NULL,
  created_at TEXT NOT NULL,
  score INTEGER NOT NULL CHECK(score BETWEEN 0 AND 100),
  grade TEXT NOT NULL,
  plain TEXT NOT NULL,
  via TEXT NOT NULL,
  headers_available INTEGER NOT NULL CHECK(headers_available IN (0,1)),
  findings_json TEXT NOT NULL DEFAULT '[]',
  headers_json TEXT NOT NULL DEFAULT '[]',
  inventory_json TEXT NOT NULL DEFAULT '{}',
  top_fixes_json TEXT NOT NULL DEFAULT '[]'
);
CREATE INDEX IF NOT EXISTS idx_audits_case_created ON website_audits(case_id, created_at DESC);
