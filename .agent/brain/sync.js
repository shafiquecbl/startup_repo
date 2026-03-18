#!/usr/bin/env node

/**
 * Agent Brain Sync
 * 
 * Syncs the brain/ directory (tool) from startup_repo.
 * Creates data files from templates on first run.
 * Never overwrites project-specific data (context/, memory/, plan/).
 * 
 * Usage:
 *   node sync.js                    # sync from default source
 *   node sync.js --source /path     # sync from custom path
 *   node sync.js --dry-run          # show what would change
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// ============================================================
// CONFIGURATION
// ============================================================
const AGENT_DIR = path.resolve(__dirname, '..');
const BRAIN_DIR = path.join(AGENT_DIR, 'brain');
const TEMPLATES_DIR = path.join(BRAIN_DIR, 'templates');

const DEFAULT_SOURCE = path.join(
  process.env.HOME || process.env.USERPROFILE,
  '.flutter_boilerplate', 'startup_repo', '.agent', 'brain'
);

// Data directories — NEVER synced, NEVER overwritten
const DATA_DIRS = [
  { dir: path.join(AGENT_DIR, 'context'), files: { 'registry.md': 'registry.md' } },
  { dir: path.join(AGENT_DIR, 'memory'), files: { 'decisions.md': 'decisions.md', 'pending_promotions.md': 'pending_promotions.md' } },
  { dir: path.join(AGENT_DIR, 'memory', 'handoffs'), files: {} },
  { dir: path.join(AGENT_DIR, 'plan'), files: { 'active.md': 'active.md', 'history.md': 'history.md' } },
];

// ============================================================
// PARSE ARGS
// ============================================================
const args = process.argv.slice(2);
const dryRun = args.includes('--dry-run');
const sourceIdx = args.indexOf('--source');
const sourceDir = sourceIdx !== -1 ? args[sourceIdx + 1] : DEFAULT_SOURCE;

// ============================================================
// MAIN
// ============================================================
function main() {
  console.log('Agent Brain Sync');
  console.log('─'.repeat(40));

  // Step 1: Ensure source exists
  if (!fs.existsSync(sourceDir)) {
    console.log(`\nSource not found: ${sourceDir}`);
    console.log('Cloning startup_repo...');
    if (!dryRun) {
      const parentDir = path.dirname(path.dirname(sourceDir));
      execSync(`git clone https://github.com/shafiquecbl/startup_repo.git "${path.dirname(sourceDir)}"`, { stdio: 'inherit' });
    }
  } else {
    // Pull latest
    console.log('Pulling latest from startup_repo...');
    if (!dryRun) {
      try {
        const repoDir = path.resolve(sourceDir, '..', '..');
        execSync(`git -C "${repoDir}" pull --ff-only`, { stdio: 'pipe' });
        console.log('Updated.');
      } catch (e) {
        console.log('Pull failed (offline?). Using cached version.');
      }
    }
  }

  // Step 2: Backup current brain/
  if (fs.existsSync(BRAIN_DIR) && !dryRun) {
    const backupDir = path.join(AGENT_DIR, '.brain-backup');
    if (fs.existsSync(backupDir)) {
      fs.rmSync(backupDir, { recursive: true });
    }
    copyDir(BRAIN_DIR, backupDir);
    console.log(`Backup: ${backupDir}`);
  }

  // Step 3: Sync brain/ from source
  if (fs.existsSync(sourceDir)) {
    console.log(`\nSyncing brain/ from ${sourceDir}`);
    const changes = syncDir(sourceDir, BRAIN_DIR);
    console.log(`  Files synced: ${changes.synced}`);
    console.log(`  Files unchanged: ${changes.unchanged}`);
  }

  // Step 4: Create data files from templates (only if missing)
  console.log('\nChecking data files...');
  for (const { dir, files } of DATA_DIRS) {
    if (!fs.existsSync(dir)) {
      if (dryRun) {
        console.log(`  Would create: ${dir}`);
      } else {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`  Created: ${path.relative(AGENT_DIR, dir)}/`);
      }
    }

    for (const [dataFile, templateFile] of Object.entries(files)) {
      const dataPath = path.join(dir, dataFile);
      const templatePath = path.join(TEMPLATES_DIR, templateFile);

      if (!fs.existsSync(dataPath) && fs.existsSync(templatePath)) {
        if (dryRun) {
          console.log(`  Would create: ${path.relative(AGENT_DIR, dataPath)} (from template)`);
        } else {
          fs.copyFileSync(templatePath, dataPath);
          console.log(`  Created: ${path.relative(AGENT_DIR, dataPath)} (from template)`);
        }
      }
    }
  }

  // Step 5: Check pending promotions
  const pendingPath = path.join(AGENT_DIR, 'memory', 'pending_promotions.md');
  if (fs.existsSync(pendingPath)) {
    const content = fs.readFileSync(pendingPath, 'utf8');
    const entryCount = (content.match(/^## \d{4}/gm) || []).length;
    if (entryCount > 0) {
      console.log(`\n⚠ ${entryCount} pending promotion(s) in memory/pending_promotions.md`);
      console.log('  Review and add to brain/skills/flutter/learning_log.md');
    }
  }

  // Step 6: Archive old handoffs (>14 days)
  const handoffDir = path.join(AGENT_DIR, 'memory', 'handoffs');
  if (fs.existsSync(handoffDir)) {
    const now = Date.now();
    const twoWeeks = 14 * 24 * 60 * 60 * 1000;
    const files = fs.readdirSync(handoffDir);
    let archived = 0;

    for (const file of files) {
      if (file.startsWith('.') || file === 'archive') continue;
      const filePath = path.join(handoffDir, file);
      const stat = fs.statSync(filePath);

      if (now - stat.mtimeMs > twoWeeks) {
        const archiveDir = path.join(handoffDir, 'archive');
        if (!dryRun) {
          if (!fs.existsSync(archiveDir)) fs.mkdirSync(archiveDir, { recursive: true });
          fs.renameSync(filePath, path.join(archiveDir, file));
        }
        archived++;
      }
    }

    if (archived > 0) {
      console.log(`\nArchived ${archived} handoff(s) older than 14 days.`);
    }
  }

  // Step 7: Install CLI dependencies if needed
  const toolsDir = path.join(BRAIN_DIR, 'tools');
  const nodeModules = path.join(toolsDir, 'node_modules');
  if (!fs.existsSync(nodeModules) && fs.existsSync(path.join(toolsDir, 'package.json'))) {
    console.log('\nInstalling brain CLI dependencies...');
    if (!dryRun) {
      try {
        execSync('npm install --production', { cwd: toolsDir, stdio: 'pipe' });
        console.log('Dependencies installed.');
      } catch (e) {
        console.log('npm install failed. Run manually: cd .agent/brain/tools && npm install');
      }
    }
  }

  console.log('\n✓ Sync complete.');
  if (dryRun) console.log('(dry run — no changes made)');
}

// ============================================================
// HELPERS
// ============================================================
function syncDir(source, target) {
  let synced = 0, unchanged = 0;

  if (!fs.existsSync(target)) fs.mkdirSync(target, { recursive: true });

  const items = fs.readdirSync(source);
  for (const item of items) {
    if (item.startsWith('.') || item === 'node_modules') continue;

    const srcPath = path.join(source, item);
    const tgtPath = path.join(target, item);
    const stat = fs.statSync(srcPath);

    if (stat.isDirectory()) {
      const sub = syncDir(srcPath, tgtPath);
      synced += sub.synced;
      unchanged += sub.unchanged;
    } else {
      // Compare content
      if (fs.existsSync(tgtPath)) {
        const srcContent = fs.readFileSync(srcPath);
        const tgtContent = fs.readFileSync(tgtPath);
        if (srcContent.equals(tgtContent)) {
          unchanged++;
          continue;
        }
      }

      if (!dryRun) {
        fs.copyFileSync(srcPath, tgtPath);
      }
      synced++;
    }
  }

  return { synced, unchanged };
}

function copyDir(source, target) {
  if (!fs.existsSync(target)) fs.mkdirSync(target, { recursive: true });
  const items = fs.readdirSync(source);
  for (const item of items) {
    if (item === 'node_modules') continue;
    const srcPath = path.join(source, item);
    const tgtPath = path.join(target, item);
    const stat = fs.statSync(srcPath);
    if (stat.isDirectory()) {
      copyDir(srcPath, tgtPath);
    } else {
      fs.copyFileSync(srcPath, tgtPath);
    }
  }
}

main();
