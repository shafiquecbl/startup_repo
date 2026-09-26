#!/usr/bin/env node

/**
 * Shared Agent Tools Sync
 *
 * Syncs approved brain/ and skills/ files from startup_repo.
 * Never overwrites project-specific context/, memory/, or plan/ data.
 *
 * Usage:
 *   node sync.js
 *   node sync.js --source /path/to/startup_repo
 *   node sync.js --source /path/to/startup_repo/.agent
 *   node sync.js --dry-run
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const TARGET_AGENT_DIR = path.resolve(__dirname, '..');
const TARGET_BRAIN_DIR = path.join(TARGET_AGENT_DIR, 'brain');
const TARGET_SKILLS_DIR = path.join(TARGET_AGENT_DIR, 'skills');
const TEMPLATES_DIR = path.join(TARGET_BRAIN_DIR, 'templates');
const DEFAULT_REPO_DIR = path.join(
  process.env.HOME || process.env.USERPROFILE,
  '.flutter_boilerplate',
  'startup_repo',
);
const REPOSITORY_URL = 'https://github.com/shafiquecbl/startup_repo.git';

const DATA_DIRS = [
  { dir: path.join(TARGET_AGENT_DIR, 'context'), files: { 'registry.md': 'registry.md' } },
  {
    dir: path.join(TARGET_AGENT_DIR, 'memory'),
    files: { 'decisions.md': 'decisions.md', 'learning_log.md': 'learning_log.md' },
  },
  { dir: path.join(TARGET_AGENT_DIR, 'memory', 'handoffs'), files: {} },
  { dir: path.join(TARGET_AGENT_DIR, 'plan'), files: { 'active.md': 'active.md', 'history.md': 'history.md' } },
  { dir: path.join(TARGET_AGENT_DIR, 'plan', 'checklists'), files: {} },
];

const args = process.argv.slice(2);
const dryRun = args.includes('--dry-run');
const sourceIndex = args.indexOf('--source');
const sourceInput = sourceIndex === -1 ? DEFAULT_REPO_DIR : args[sourceIndex + 1];

if (!sourceInput) {
  throw new Error('--source requires a path.');
}

const SOURCE_AGENT_DIR = resolveAgentDir(sourceInput);
const SOURCE_REPO_DIR = path.dirname(SOURCE_AGENT_DIR);

function main() {
  console.log('Shared Agent Tools Sync');
  console.log('─'.repeat(40));

  ensureSource();
  if (!fs.existsSync(SOURCE_AGENT_DIR)) {
    console.log('\nSource is unavailable. No files were changed.');
    return;
  }
  pullSource();
  backupSharedTools();

  syncSharedDirectory('brain', path.join(SOURCE_AGENT_DIR, 'brain'), TARGET_BRAIN_DIR);
  syncSharedDirectory('skills', path.join(SOURCE_AGENT_DIR, 'skills'), TARGET_SKILLS_DIR);

  createMissingProjectData();

  console.log('\n✓ Sync complete.');
  if (dryRun) console.log('(dry run — no changes made)');
}

function resolveAgentDir(input) {
  const resolved = path.resolve(input);
  if (path.basename(resolved) === 'brain') return path.dirname(resolved);
  if (path.basename(resolved) === '.agent') return resolved;
  return path.join(resolved, '.agent');
}

function ensureSource() {
  if (fs.existsSync(SOURCE_AGENT_DIR)) return;

  if (sourceIndex !== -1) {
    throw new Error(`Source does not contain .agent/: ${sourceInput}`);
  }

  console.log(`Source not found: ${SOURCE_REPO_DIR}`);
  if (dryRun) {
    console.log(`Would clone: ${REPOSITORY_URL}`);
    return;
  }

  fs.mkdirSync(path.dirname(SOURCE_REPO_DIR), { recursive: true });
  execSync(`git clone "${REPOSITORY_URL}" "${SOURCE_REPO_DIR}"`, { stdio: 'inherit' });
}

function pullSource() {
  if (!fs.existsSync(SOURCE_AGENT_DIR)) return;

  console.log('Pulling latest startup_repo...');
  if (dryRun) return;

  try {
    execSync(`git -C "${SOURCE_REPO_DIR}" pull --ff-only`, { stdio: 'pipe' });
    console.log('Updated.');
  } catch (_) {
    console.log('Pull failed or source has local changes. Using the current local version.');
  }
}

function backupSharedTools() {
  if (dryRun) return;

  const backupDir = path.join(TARGET_AGENT_DIR, '..', '.dart_tool', 'agent-shared-tools-backup');
  if (fs.existsSync(backupDir)) fs.rmSync(backupDir, { recursive: true });
  fs.mkdirSync(backupDir, { recursive: true });

  if (fs.existsSync(TARGET_BRAIN_DIR)) copyDir(TARGET_BRAIN_DIR, path.join(backupDir, 'brain'));
  if (fs.existsSync(TARGET_SKILLS_DIR)) copyDir(TARGET_SKILLS_DIR, path.join(backupDir, 'skills'));
  console.log(`Backup: ${backupDir}`);
}

function syncSharedDirectory(name, source, target) {
  if (!fs.existsSync(source)) {
    throw new Error(`Missing shared ${name}/ directory: ${source}`);
  }

  console.log(`\nSyncing ${name}/ from ${source}`);
  const changes = syncDir(source, target);
  console.log(`  Files synced: ${changes.synced}`);
  console.log(`  Files unchanged: ${changes.unchanged}`);
}

function createMissingProjectData() {
  console.log('\nChecking project data files...');
  for (const { dir, files } of DATA_DIRS) {
    if (!fs.existsSync(dir)) {
      if (dryRun) {
        console.log(`  Would create: ${dir}`);
      } else {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`  Created: ${path.relative(TARGET_AGENT_DIR, dir)}/`);
      }
    }

    for (const [dataFile, templateFile] of Object.entries(files)) {
      const dataPath = path.join(dir, dataFile);
      const templatePath = path.join(TEMPLATES_DIR, templateFile);
      if (fs.existsSync(dataPath) || !fs.existsSync(templatePath)) continue;

      if (dryRun) {
        console.log(`  Would create: ${path.relative(TARGET_AGENT_DIR, dataPath)} (from template)`);
      } else {
        fs.copyFileSync(templatePath, dataPath);
        console.log(`  Created: ${path.relative(TARGET_AGENT_DIR, dataPath)} (from template)`);
      }
    }
  }
}

function syncDir(source, target) {
  let synced = 0;
  let unchanged = 0;

  if (!fs.existsSync(target) && !dryRun) fs.mkdirSync(target, { recursive: true });

  for (const item of fs.readdirSync(source)) {
    if (item.startsWith('.') || item === 'node_modules') continue;

    const sourcePath = path.join(source, item);
    const targetPath = path.join(target, item);
    if (fs.statSync(sourcePath).isDirectory()) {
      const nested = syncDir(sourcePath, targetPath);
      synced += nested.synced;
      unchanged += nested.unchanged;
      continue;
    }

    if (fs.existsSync(targetPath)) {
      const sourceContent = fs.readFileSync(sourcePath);
      const targetContent = fs.readFileSync(targetPath);
      if (sourceContent.equals(targetContent)) {
        unchanged++;
        continue;
      }
    }

    if (!dryRun) {
      fs.mkdirSync(path.dirname(targetPath), { recursive: true });
      fs.copyFileSync(sourcePath, targetPath);
    }
    synced++;
  }

  return { synced, unchanged };
}

function copyDir(source, target) {
  fs.mkdirSync(target, { recursive: true });
  for (const item of fs.readdirSync(source)) {
    if (item === 'node_modules') continue;

    const sourcePath = path.join(source, item);
    const targetPath = path.join(target, item);
    if (fs.statSync(sourcePath).isDirectory()) {
      copyDir(sourcePath, targetPath);
    } else {
      fs.copyFileSync(sourcePath, targetPath);
    }
  }
}

main();
