#!/usr/bin/env node

/**
 * Agent Brain CLI
 * 
 * AI agents call this tool via terminal to search, remember, plan, and index.
 * Uses sql.js (pure JavaScript SQLite) for universal cross-platform support.
 * 
 * Usage:
 *   node brain.js setup                          # initialize database
 *   node brain.js search "query"                 # search all nodes
 *   node brain.js search --type widget "query"   # search by type
 *   node brain.js remember "type" "content"      # store a memory
 *   node brain.js task add "title" "description" # add a task
 *   node brain.js task list [--status active]     # list tasks
 *   node brain.js task update "id" "status"       # update task status
 *   node brain.js relate "src" "rel" "target"     # create relationship
 *   node brain.js node add "type" "name" "desc" [--file path] # add a node
 *   node brain.js index                           # full codebase scan
 *   node brain.js index --incremental             # update changed only
 *   node brain.js status                          # database stats
 *   node brain.js registry                        # regenerate registry.md
 */

const path = require('path');
const fs = require('fs');

const TOOLS_DIR = __dirname;
const BRAIN_DIR = path.resolve(TOOLS_DIR, '..');
const AGENT_DIR = path.resolve(BRAIN_DIR, '..');
const PROJECT_ROOT = path.resolve(AGENT_DIR, '..');
const DB_PATH = path.join(AGENT_DIR, 'brain.db');

// ============================================================
// DATABASE LAYER
// ============================================================
let _db = null;

async function getDb() {
  if (_db) return _db;
  let initSqlJs;
  try {
    initSqlJs = require('sql.js');
  } catch (err) {
    console.error('Error: sql.js not installed.\nRun: cd .agent/brain/tools && npm install');
    process.exit(1);
  }
  const SQL = await initSqlJs();
  if (fs.existsSync(DB_PATH)) {
    _db = new SQL.Database(fs.readFileSync(DB_PATH));
  } else {
    _db = new SQL.Database();
  }
  return _db;
}

function saveDb() {
  if (!_db) return;
  fs.writeFileSync(DB_PATH, Buffer.from(_db.export()));
}

function queryAll(db, sql, params = []) {
  const stmt = db.prepare(sql);
  if (params.length > 0) stmt.bind(params);
  const rows = [];
  while (stmt.step()) rows.push(stmt.getAsObject());
  stmt.free();
  return rows;
}

function queryOne(db, sql, params = []) {
  const rows = queryAll(db, sql, params);
  return rows.length > 0 ? rows[0] : null;
}

function exec(db, sql, params = []) {
  if (params.length > 0) {
    db.run(sql, params);
  } else {
    db.run(sql);
  }
  return db.getRowsModified();
}

// ============================================================
// SETUP
// ============================================================
async function setup() {
  const db = await getDb();
  db.run(`CREATE TABLE IF NOT EXISTS nodes (
    id TEXT PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL,
    description TEXT, properties TEXT, file_path TEXT,
    status TEXT DEFAULT 'active',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
  )`);
  db.run(`CREATE TABLE IF NOT EXISTS edges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_id TEXT NOT NULL, target_id TEXT NOT NULL,
    type TEXT NOT NULL, context TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    UNIQUE(source_id, target_id, type)
  )`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_nodes_type ON nodes(type)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_nodes_status ON nodes(status)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_nodes_file ON nodes(file_path)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_edges_source ON edges(source_id)`);
  db.run(`CREATE INDEX IF NOT EXISTS idx_edges_target ON edges(target_id)`);
  saveDb();
  console.log('Database initialized at', DB_PATH);
}

// ============================================================
// SEARCH
// ============================================================
async function search(query, typeFilter) {
  const db = await getDb();
  const words = query.toLowerCase().split(/\s+/).filter(Boolean);
  let conditions = words.map(() =>
    `(LOWER(name) LIKE ? OR LOWER(type) LIKE ? OR LOWER(COALESCE(description,'')) LIKE ? OR LOWER(COALESCE(properties,'')) LIKE ?)`
  );
  let sql = `SELECT id, type, name, description, file_path, status FROM nodes WHERE ` + conditions.join(' AND ');
  const params = [];
  for (const w of words) { const l = `%${w}%`; params.push(l, l, l, l); }
  if (typeFilter) { sql += ` AND type = ?`; params.push(typeFilter.toLowerCase()); }
  sql += ` ORDER BY updated_at DESC LIMIT 20`;

  const rows = queryAll(db, sql, params);
  if (rows.length === 0) {
    console.log(`No results for "${query}"${typeFilter ? ` (type: ${typeFilter})` : ''}`);
    return;
  }
  console.log(`Found ${rows.length} result(s):\n`);
  for (const r of rows) {
    console.log(`  [${r.type}] ${r.name} (${r.id})`);
    if (r.description) console.log(`    ${r.description}`);
    if (r.file_path) console.log(`    → ${r.file_path}`);
    if (r.status !== 'active') console.log(`    status: ${r.status}`);
    console.log();
  }
}

// ============================================================
// NODE ADD
// ============================================================
async function nodeAdd(type, name, description, filePath, properties) {
  const db = await getDb();
  const id = genId(type, name);
  exec(db, `INSERT OR REPLACE INTO nodes (id, type, name, description, file_path, properties, status, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?, 'active', COALESCE((SELECT created_at FROM nodes WHERE id = ?), datetime('now')), datetime('now'))`,
    [id, type.toLowerCase(), name, description || null, filePath || null, properties || null, id]);
  saveDb();
  console.log(`Node saved: [${type}] ${name} (${id})`);
  return id;
}

// ============================================================
// REMEMBER
// ============================================================
async function remember(type, content) {
  const db = await getDb();
  const id = `${type.toLowerCase()}_${Date.now()}`;
  exec(db, `INSERT INTO nodes (id, type, name, description, status) VALUES (?, ?, ?, ?, 'active')`,
    [id, type.toLowerCase(), content.slice(0, 100), content]);
  saveDb();
  console.log(`Remembered [${type}]: ${content.slice(0, 80)}${content.length > 80 ? '...' : ''}`);
}

// ============================================================
// TASK
// ============================================================
async function taskAdd(title, description) {
  const db = await getDb();
  const id = genId('task', title);
  exec(db, `INSERT OR REPLACE INTO nodes (id, type, name, description, status, created_at, updated_at)
    VALUES (?, 'task', ?, ?, 'active', COALESCE((SELECT created_at FROM nodes WHERE id = ?), datetime('now')), datetime('now'))`,
    [id, title, description || null, id]);
  saveDb();
  console.log(`Task added: ${title} (${id})`);
}

async function taskList(statusFilter) {
  const db = await getDb();
  let sql = `SELECT id, name, description, status, created_at FROM nodes WHERE type = 'task'`;
  const params = [];
  if (statusFilter) { sql += ` AND status = ?`; params.push(statusFilter); }
  sql += ` ORDER BY created_at DESC LIMIT 50`;
  const rows = queryAll(db, sql, params);
  if (rows.length === 0) { console.log('No tasks found.'); return; }
  console.log(`Tasks (${rows.length}):\n`);
  for (const r of rows) {
    const m = r.status === 'done' ? '✓' : r.status === 'active' ? '○' : '·';
    console.log(`  ${m} [${r.status}] ${r.name} (${r.id})`);
    if (r.description) console.log(`    ${r.description}`);
  }
}

async function taskUpdate(id, status) {
  const db = await getDb();
  const valid = ['active', 'done', 'blocked', 'archived'];
  if (!valid.includes(status)) { console.error(`Invalid status. Use: ${valid.join(', ')}`); process.exit(1); }
  let changes = exec(db, `UPDATE nodes SET status = ?, updated_at = datetime('now') WHERE id = ? AND type = 'task'`, [status, id]);
  if (changes === 0) {
    const r = queryOne(db, `SELECT id, name FROM nodes WHERE type = 'task' AND id LIKE ?`, [`%${id}%`]);
    if (r) { exec(db, `UPDATE nodes SET status = ?, updated_at = datetime('now') WHERE id = ?`, [status, r.id]); saveDb(); console.log(`Task updated: ${r.name} → ${status}`); return; }
    console.error(`Task not found: ${id}`); return;
  }
  saveDb();
  console.log(`Task updated: ${id} → ${status}`);
}

// ============================================================
// RELATE
// ============================================================
async function relate(sourceId, rel, targetId, context) {
  const db = await getDb();
  const src = resolveId(db, sourceId), tgt = resolveId(db, targetId);
  if (!src) { console.error(`Source not found: ${sourceId}`); process.exit(1); }
  if (!tgt) { console.error(`Target not found: ${targetId}`); process.exit(1); }
  exec(db, `INSERT OR REPLACE INTO edges (source_id, target_id, type, context, created_at) VALUES (?, ?, ?, ?, datetime('now'))`,
    [src, tgt, rel.toLowerCase(), context || null]);
  saveDb();
  console.log(`Relation: ${src} —[${rel}]→ ${tgt}`);
}

function resolveId(db, partial) {
  const exact = queryOne(db, `SELECT id FROM nodes WHERE id = ?`, [partial]);
  if (exact) return exact.id;
  const like = queryOne(db, `SELECT id FROM nodes WHERE id LIKE ? LIMIT 1`, [`%${partial}%`]);
  return like ? like.id : null;
}

// ============================================================
// INDEX
// ============================================================
async function index(incremental) {
  const db = await getDb();
  const libDir = path.join(PROJECT_ROOT, 'lib');
  if (!fs.existsSync(libDir)) { console.error(`No lib/ directory at ${PROJECT_ROOT}. Are you in a Flutter project?`); process.exit(1); }

  console.log(`${incremental ? 'Incremental' : 'Full'} indexing of ${libDir}...\n`);
  const dartFiles = findFiles(libDir, '.dart');
  let added = 0, updated = 0, skipped = 0;

  for (const file of dartFiles) {
    const rel = path.relative(PROJECT_ROOT, file);
    const entries = parseDartFile(fs.readFileSync(file, 'utf8'), rel);
    for (const e of entries) {
      const existing = queryOne(db, 'SELECT updated_at FROM nodes WHERE id = ?', [e.id]);
      if (incremental && existing) {
        if (fs.statSync(file).mtimeMs <= new Date(existing.updated_at).getTime()) { skipped++; continue; }
        updated++;
      } else if (existing) { updated++; } else { added++; }
      exec(db, `INSERT OR REPLACE INTO nodes (id, type, name, description, file_path, properties, status, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, 'active', COALESCE((SELECT created_at FROM nodes WHERE id = ?), datetime('now')), datetime('now'))`,
        [e.id, e.type, e.name, e.description, e.file_path, e.properties, e.id]);
    }
  }

  saveDb();
  console.log(`Indexing complete:\n  Added: ${added}\n  Updated: ${updated}\n  Skipped: ${skipped}\n  Files scanned: ${dartFiles.length}`);
}

function parseDartFile(content, relPath) {
  const entries = [], lines = content.split('\n');

  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^(?:abstract\s+)?class\s+(\w+)(?:\s+extends\s+(\w+))?(?:\s+(?:with|implements)\s+(.+?))?(?:\s*\{|$)/);
    if (!m) continue;
    const [, cls, ext, mix] = m;
    entries.push({ id: genId(inferType(cls, ext || '', mix || '', relPath), cls), type: inferType(cls, ext || '', mix || '', relPath),
      name: cls, description: extractDesc(lines, i), file_path: relPath,
      properties: JSON.stringify({ extends: ext || undefined, mixins: mix || undefined, line: i + 1 }) });
  }
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^enum\s+(\w+)/);
    if (m) entries.push({ id: genId('enum', m[1]), type: 'enum', name: m[1], description: null, file_path: relPath, properties: JSON.stringify({ line: i + 1 }) });
  }
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^extension\s+(\w+)\s+on\s+(\w+)/);
    if (m) entries.push({ id: genId('extension', m[1]), type: 'extension', name: m[1], description: `Extension on ${m[2]}`, file_path: relPath, properties: JSON.stringify({ on: m[2], line: i + 1 }) });
  }
  return entries;
}

function inferType(cls, ext, mix, fp) {
  if (['StatelessWidget','StatefulWidget','GetView','GetWidget','HookWidget'].includes(ext)) return 'widget';
  if (['GetxController','ChangeNotifier','ValueNotifier'].includes(ext)) return 'controller';
  if (cls.endsWith('Controller')) return 'controller';
  if (cls.endsWith('Service')) return 'service';
  if (cls.endsWith('Repository') || cls.endsWith('Repo')) return 'repository';
  if (cls.endsWith('Model') || cls.endsWith('Entity')) return 'model';
  if (cls.endsWith('Screen') || cls.endsWith('Page') || cls.endsWith('View')) return 'screen';
  if (cls.endsWith('Widget')) return 'widget';
  if (cls.endsWith('Binding')) return 'binding';
  if (cls.endsWith('Middleware')) return 'middleware';
  if (fp.includes('/widgets/')) return 'widget';
  if (fp.includes('/controllers/')) return 'controller';
  if (fp.includes('/services/')) return 'service';
  if (fp.includes('/models/')) return 'model';
  if (fp.includes('/screens/') || fp.includes('/views/') || fp.includes('/pages/')) return 'screen';
  return 'class';
}

function extractDesc(lines, idx) {
  let d = [];
  for (let i = idx - 1; i >= Math.max(0, idx - 5); i--) {
    const l = lines[i].trim();
    if (l.startsWith('///')) d.unshift(l.replace(/^\/\/\/\s?/, ''));
    else if (l.startsWith('//')) d.unshift(l.replace(/^\/\/\s?/, ''));
    else if (l === '' || l.startsWith('@')) continue;
    else break;
  }
  return d.length > 0 ? d.join(' ').slice(0, 200) : null;
}

// ============================================================
// STATUS
// ============================================================
async function status() {
  const db = await getDb();
  const nc = queryOne(db, 'SELECT COUNT(*) as c FROM nodes');
  if (!nc || nc.c === 0) { console.log('Database is empty. Run: node brain.js setup && node brain.js index'); return; }
  const ec = queryOne(db, 'SELECT COUNT(*) as c FROM edges');
  const types = queryAll(db, 'SELECT type, COUNT(*) as c FROM nodes GROUP BY type ORDER BY c DESC');
  const recent = queryAll(db, 'SELECT name, type, updated_at FROM nodes ORDER BY updated_at DESC LIMIT 5');
  const sz = fs.existsSync(DB_PATH) ? (fs.statSync(DB_PATH).size / 1024).toFixed(1) : '0';
  console.log(`Agent Brain Status\n${'─'.repeat(40)}\nNodes: ${nc.c}  |  Edges: ${ec.c}  |  DB: ${sz} KB\n`);
  console.log('Node types:');
  for (const t of types) console.log(`  ${t.type}: ${t.c}`);
  console.log('\nRecently updated:');
  for (const r of recent) console.log(`  [${r.type}] ${r.name} — ${r.updated_at}`);
}

// ============================================================
// REGISTRY
// ============================================================
async function generateRegistry() {
  const db = await getDb();
  const registryPath = path.join(AGENT_DIR, 'context', 'registry.md');
  const types = queryAll(db, 'SELECT DISTINCT type FROM nodes WHERE status = "active" ORDER BY type');
  const total = queryOne(db, 'SELECT COUNT(*) as c FROM nodes WHERE status = "active"');
  let out = `# Project Registry\n\n> Auto-generated from brain.db — ${new Date().toISOString().slice(0, 10)}\n> ${total.c} active nodes\n\n`;
  for (const { type } of types) {
    if (type === 'task') continue;
    const nodes = queryAll(db, `SELECT name, description, file_path FROM nodes WHERE type = ? AND status = 'active' ORDER BY name LIMIT 50`, [type]);
    const plural = type.endsWith('s') ? type + 'es' : type.endsWith('y') ? type.slice(0, -1) + 'ies' : type + 's';
    out += `## ${plural.charAt(0).toUpperCase() + plural.slice(1)}\n`;
    for (const n of nodes) {
      out += `- **${n.name}**`;
      if (n.description) out += ` — ${n.description.slice(0, 80)}`;
      if (n.file_path) out += ` \`${n.file_path}\``;
      out += `\n`;
    }
    out += `\n`;
  }
  const dir = path.dirname(registryPath);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(registryPath, out);
  console.log(`Registry written to ${registryPath}`);
}

// ============================================================
// HELPERS
// ============================================================
function genId(type, name) { return `${type.toLowerCase()}_${name.replace(/[^a-zA-Z0-9]/g, '_').toLowerCase()}`; }

function findFiles(dir, ext) {
  const results = [], skip = ['node_modules', '.dart_tool', '.git', 'build', '.agent', 'generated'];
  (function walk(d) {
    for (const item of fs.readdirSync(d)) {
      if (skip.includes(item) || item.startsWith('.')) continue;
      const f = path.join(d, item), s = fs.statSync(f);
      if (s.isDirectory()) walk(f);
      else if (item.endsWith(ext)) results.push(f);
    }
  })(dir);
  return results;
}

// ============================================================
// CLI ROUTER
// ============================================================
async function main() {
  const args = process.argv.slice(2), cmd = args[0];
  if (!cmd) {
    console.log(`Agent Brain CLI\n\nCommands:\n  setup                            Initialize database\n  search "query"                   Search nodes\n  search --type widget "query"     Search by type\n  node add "type" "name" "desc"    Add a node\n  remember "type" "content"        Quick memory\n  task add "title" "description"   Add task\n  task list [--status active]      List tasks\n  task update "id" "status"        Update task\n  relate "src" "rel" "target"      Create relationship\n  index [--incremental]            Scan codebase\n  status                           Database stats\n  registry                         Regenerate registry.md`);
    process.exit(0);
  }
  if (cmd !== 'setup' && !fs.existsSync(DB_PATH)) { console.log('Database not found. Running setup...'); await setup(); }

  switch (cmd) {
    case 'setup': await setup(); break;
    case 'search': {
      let tf = null, q;
      if (args[1] === '--type') { tf = args[2]; q = args.slice(3).join(' '); } else { q = args.slice(1).join(' '); }
      if (!q) { console.error('Usage: brain.js search [--type TYPE] "query"'); process.exit(1); }
      await search(q, tf); break;
    }
    case 'node': {
      if (args[1] === 'add') {
        const fi = args.indexOf('--file');
        if (!args[2] || !args[3]) { console.error('Usage: brain.js node add "type" "name" ["desc"] [--file path]'); process.exit(1); }
        await nodeAdd(args[2], args[3], args[4], fi !== -1 ? args[fi + 1] : null);
      } break;
    }
    case 'remember': {
      if (!args[1] || !args[2]) { console.error('Usage: brain.js remember "type" "content"'); process.exit(1); }
      await remember(args[1], args.slice(2).join(' ')); break;
    }
    case 'task': {
      if (args[1] === 'add') { if (!args[2]) { console.error('Usage: brain.js task add "title" ["desc"]'); process.exit(1); } await taskAdd(args[2], args.slice(3).join(' ') || null); }
      else if (args[1] === 'list') { const si = args.indexOf('--status'); await taskList(si !== -1 ? args[si + 1] : null); }
      else if (args[1] === 'update') { if (!args[2] || !args[3]) { console.error('Usage: brain.js task update "id" "status"'); process.exit(1); } await taskUpdate(args[2], args[3]); }
      else console.error('Subcommands: add, list, update');
      break;
    }
    case 'relate': {
      if (!args[1] || !args[2] || !args[3]) { console.error('Usage: brain.js relate "src" "rel" "target" ["context"]'); process.exit(1); }
      await relate(args[1], args[2], args[3], args.slice(4).join(' ') || null); break;
    }
    case 'index': await index(args.includes('--incremental')); await generateRegistry(); break;
    case 'status': await status(); break;
    case 'registry': await generateRegistry(); break;
    default: console.error(`Unknown command: ${cmd}`); process.exit(1);
  }
}

main().catch(e => { console.error('Error:', e.message); process.exit(1); });
