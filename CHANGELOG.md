# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-04-13

### Added
- `/branch` command — fork sessions for experimentation
- `/branch switch` — switch between session branches
- `/branch delete` — remove a branch
- `/merge` command — merge branch into current
- Cursor adapter (planned)
- Codex adapter (planned)
- Multi-agent architecture documentation
- `docs/ARCHITECTURE.md` — System architecture overview
- `docs/ROADMAP.md` — Product roadmap
- `docs/MULTI-AGENT.md` — Multi-agent integration guide

### Changed
- index.json now supports branches (version 2)
- Checkpoints can belong to multiple branches

## [2.0.0] - 2026-04-13

### Added
- `/rewind` command — time travel to previous checkpoints
- `/rewind N` — go back N checkpoints
- `/rewind #NNN` — go to specific checkpoint
- `/handoff` command — comprehensive session transfer checkpoint
- `/debug-session` command — analyze changes between checkpoints
- `index.json` — timeline index for fast navigation
- `handoff.md` — enhanced handoff format

### Changed
- pre-compact.sh now updates index.json
- SKILL.md includes v2 command suggestions

## [1.0.0] - 2026-04-13

### Added
- PreCompact hook for automatic checkpoint saving
- PostCompact hook for automatic context restoration
- SessionStart hook for session resume support
- SessionEnd hook for cleanup
- `/checkpoint` command for rich LLM-generated summaries
- `/restore` command for manual restoration
- Structured checkpoint storage (auto.json, summary.md, meta.json)
- Failure handling (hooks never crash)
- Context-saver skill for proactive behavior

### Technical
- Three-layer architecture (Infrastructure, Intelligence, State)
- 100% reliable auto-checkpoints via hooks
- Best-effort rich checkpoints via LLM commands
- Maximum 20 checkpoints retained (auto-cleanup)
