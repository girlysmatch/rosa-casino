PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS participants (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_key TEXT NOT NULL UNIQUE,
  team TEXT CHECK (team IN ('hearts','spades') OR team IS NULL),
  is_rosa INTEGER NOT NULL DEFAULT 0 CHECK (is_rosa IN (0,1)),
  final_unlocked INTEGER NOT NULL DEFAULT 0 CHECK (final_unlocked IN (0,1)),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS sessions (
  token_hash TEXT PRIMARY KEY,
  actor_type TEXT NOT NULL CHECK (actor_type IN ('participant','admin')),
  participant_id TEXT REFERENCES participants(id) ON DELETE CASCADE,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  CHECK ((actor_type='participant' AND participant_id IS NOT NULL) OR (actor_type='admin' AND participant_id IS NULL))
);
CREATE INDEX IF NOT EXISTS idx_sessions_expiry ON sessions(expires_at);
CREATE TABLE IF NOT EXISTS app_settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
INSERT OR IGNORE INTO app_settings(key,value) VALUES ('quiz_open','false');
INSERT OR IGNORE INTO app_settings(key,value) VALUES ('quiz_results_published','false');
CREATE TABLE IF NOT EXISTS missions (
  id INTEGER PRIMARY KEY CHECK (id BETWEEN 1 AND 6),
  title TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  configured INTEGER NOT NULL DEFAULT 0 CHECK (configured IN (0,1)),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
INSERT OR IGNORE INTO missions(id,title,description,configured) VALUES
 (1,'Misión 01','',0),(2,'Misión 02','',0),(3,'Misión 03','',0),
 (4,'Misión 04','',0),(5,'Misión 05','',0),(6,'Misión 06','',0);
CREATE TABLE IF NOT EXISTS mission_progress (
  participant_id TEXT NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  mission_id INTEGER NOT NULL REFERENCES missions(id) ON DELETE CASCADE,
  completed_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY(participant_id,mission_id)
);
CREATE TABLE IF NOT EXISTS challenges (
  id INTEGER PRIMARY KEY CHECK (id BETWEEN 1 AND 10),
  title TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  configured INTEGER NOT NULL DEFAULT 0 CHECK (configured IN (0,1)),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
INSERT OR IGNORE INTO challenges(id,title,description,configured) VALUES
 (1,'Reto 01','',0),(2,'Reto 02','',0),(3,'Reto 03','',0),(4,'Reto 04','',0),(5,'Reto 05','',0),
 (6,'Reto 06','',0),(7,'Reto 07','',0),(8,'Reto 08','',0),(9,'Reto 09','',0),(10,'Reto 10','',0);
CREATE TABLE IF NOT EXISTS challenge_submissions (
  id TEXT PRIMARY KEY,
  participant_id TEXT NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  challenge_id INTEGER NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
  submitted_at TEXT NOT NULL DEFAULT (datetime('now')),
  reviewed_at TEXT,
  UNIQUE(participant_id,challenge_id)
);
CREATE INDEX IF NOT EXISTS idx_challenge_status ON challenge_submissions(status);
CREATE TABLE IF NOT EXISTS quiz_questions (
  id INTEGER PRIMARY KEY CHECK (id BETWEEN 1 AND 15),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy','medium','hard')),
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option TEXT NOT NULL CHECK (correct_option IN ('A','B','C','D')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS quiz_attempts (
  participant_id TEXT PRIMARY KEY REFERENCES participants(id) ON DELETE CASCADE,
  score INTEGER NOT NULL DEFAULT 0 CHECK (score BETWEEN 0 AND 100),
  submitted_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS quiz_answers (
  participant_id TEXT NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  question_id INTEGER NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
  answer TEXT NOT NULL CHECK (answer IN ('A','B','C','D')),
  is_correct INTEGER NOT NULL CHECK (is_correct IN (0,1)),
  PRIMARY KEY(participant_id,question_id)
);
CREATE TABLE IF NOT EXISTS team_winner (
  id INTEGER PRIMARY KEY CHECK (id=1),
  team TEXT NOT NULL CHECK (team IN ('hearts','spades')),
  assigned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
