#!/usr/bin/env node
// bankai installer — zero dependencies, works on Node >= 14.
// Usage:
//   npx github:Ahmed-OC/bankai            (from anywhere)
//   node bin/install.js [target-dir]       (from a clone)
'use strict';
const fs = require('fs');
const path = require('path');
const os = require('os');

const ROOT = path.resolve(__dirname, '..');
const SRC = path.join(ROOT, 'bankai'); // the whole canon: SKILL.md + skills/*

function copyRecursive(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) copyRecursive(s, d);
    else fs.copyFileSync(s, d);
  }
}

const projectDirs = ['.agents/skills', '.claude/skills', '.codex/skills', '.cursor/skills'];
const candidates = projectDirs
  .map((c) => path.join(process.cwd(), c))
  .concat(projectDirs.map((c) => path.join(os.homedir(), c)));

const target =
  process.argv[2] || process.env.BANKAI_TARGET || candidates.find((c) => fs.existsSync(c));

if (!target) {
  console.error('No skills directory found (.agents/skills, .claude/skills, .codex/skills, .cursor/skills).');
  console.error('Create one (mkdir -p .agents/skills) or pass a target: npx github:Ahmed-OC/bankai path/to/skills-dir');
  process.exit(1);
}

copyRecursive(SRC, target);
console.log('Installed bankai into: ' + target);
console.log('Start with: bankai (it routes to its 106 sub-skills automatically).');
