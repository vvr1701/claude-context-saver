# Roadmap

## Completed

### v1.0 — Foundation (2026-04-13)
- [x] PreCompact/PostCompact hooks
- [x] Automatic checkpoint save/restore
- [x] `/checkpoint` command for rich summaries
- [x] `/restore` command for manual restoration
- [x] Structured storage (auto.json, summary.md, meta.json)
- [x] Context-saver skill

### v2.0 — Time Travel (2026-04-13)
- [x] `/rewind` command (go back N checkpoints)
- [x] `/rewind #NNN` (go to specific checkpoint)
- [x] `/handoff` command (session transfer optimization)
- [x] `/debug-session` command (diff analysis)
- [x] `index.json` timeline index
- [x] Enhanced checkpoint navigation

### v3.0 — Branching & Multi-Agent (2026-04-13)
- [x] `/branch` command (fork sessions)
- [x] `/branch switch` (change branches)
- [x] `/merge` command (merge branches)
- [x] Branch-aware index.json
- [x] Cursor adapter (planned)
- [x] Codex adapter (planned)
- [x] Architecture documentation

## In Progress

### v3.1 — Adapter Implementation
- [ ] Cursor adapter implementation
- [ ] Test cross-agent checkpoint sharing
- [ ] Codex adapter implementation
- [ ] VS Code extension support

## Planned

### v3.2 — Enhanced Analytics
- [ ] Checkpoint statistics dashboard
- [ ] Session productivity metrics
- [ ] Context usage patterns
- [ ] Compaction frequency analysis

### v4.0 — Cloud Sync
- [ ] Optional cloud backup
- [ ] Multi-machine synchronization
- [ ] Team checkpoint sharing
- [ ] Encrypted storage option

### v4.1 — Smart Compression
- [ ] Automatic summary generation improvements
- [ ] Semantic deduplication
- [ ] Intelligent context pruning
- [ ] Relevance scoring

### v5.0 — Knowledge Graph
- [ ] Relationship mapping between checkpoints
- [ ] Decision tree visualization
- [ ] File evolution tracking
- [ ] Project timeline view

## Future Considerations

- Integration with git workflows
- Checkpoint diffing tools
- Export to various formats (Markdown, PDF)
- Search across all checkpoints
- Tag-based organization
- Custom retention policies
- Webhook notifications
- CI/CD integration
