# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
