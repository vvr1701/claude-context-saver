# Multi-Agent Support

## Vision

Enable seamless context handoff between different AI coding agents. Start work in Claude Code, continue in Cursor, finish in Codex.

## Checkpoint Format (Universal)

All agents share the same checkpoint structure:

```
.claude/checkpoints/
├── 001/
│   ├── auto.json      # Machine-readable context
│   ├── summary.md     # Human-readable summary
│   ├── handoff.md     # Session transfer summary
│   └── meta.json      # Checkpoint metadata
├── 002/
├── index.json         # Timeline index
└── latest -> 002/
```

This format is agent-agnostic. Any agent that understands it can resume a session.

## Adapter Architecture

Each agent needs an adapter that:

1. **Hooks into agent lifecycle**
   - Detect compaction/session-start events
   - Trigger checkpoint save/restore

2. **Translates agent-specific data**
   - Extract files in context
   - Extract recent commands
   - Map to universal checkpoint format

3. **Provides agent-specific commands**
   - Register `/checkpoint`, `/rewind`, etc.
   - Or use agent's command system

## Adapter: Claude Code (Reference)

This plugin IS the Claude Code adapter. It uses:
- Claude Code hooks (PreCompact, PostCompact)
- Claude Code skills (context-saver)
- Claude Code transcript format

## Adapter: Cursor (Planned)

### Lifecycle Hooks
```typescript
// cursor-adapter.ts
import { CursorAPI } from 'cursor-sdk';

CursorAPI.on('beforeContextReset', async () => {
  await saveCheckpoint();
});

CursorAPI.on('afterContextReset', async () => {
  await restoreCheckpoint();
});
```

### Command Registration
```typescript
CursorAPI.registerCommand('checkpoint', async () => {
  const summary = await generateSummary();
  await saveCheckpoint({ summary });
});
```

### Context Extraction
```typescript
function extractContext(): CheckpointData {
  return {
    files: CursorAPI.getOpenFiles(),
    commands: CursorAPI.getRecentActions(),
    cwd: CursorAPI.getWorkspaceRoot()
  };
}
```

## Adapter: Codex (Planned)

### Lifecycle Hooks
```python
# codex_adapter.py
from codex import hooks

@hooks.pre_session_end
def save_checkpoint():
    checkpoint_data = extract_context()
    write_checkpoint(checkpoint_data)

@hooks.post_session_start
def restore_checkpoint():
    checkpoint = load_latest_checkpoint()
    inject_context(checkpoint)
```

### Context Extraction
```python
def extract_context():
    return {
        'files': codex.get_context_files(),
        'commands': codex.get_recent_commands(),
        'cwd': os.getcwd()
    }
```

## Cross-Agent Workflow Example

### Scenario: Start in Claude Code, finish in Cursor

1. **Claude Code session:**
   ```
   User works on auth implementation
   Context grows...
   PreCompact hook fires → Checkpoint #003 saved
   User closes Claude Code
   ```

2. **Cursor session (same project directory):**
   ```
   User opens Cursor
   Cursor adapter detects .claude/checkpoints/
   Loads checkpoint #003
   User continues from exact same context
   ```

### Scenario: Branching across agents

1. **Claude Code:**
   ```
   /branch experiment-oauth
   Work on OAuth implementation
   Checkpoint #004 saved to experiment-oauth branch
   ```

2. **Cursor:**
   ```
   Opens same project
   Detects branches: main, experiment-oauth
   /branch switch experiment-oauth
   Continues OAuth work from #004
   ```

## Implementation Checklist

### For new adapter authors:

- [ ] Hook into agent's compaction/session events
- [ ] Extract context (files, commands, cwd)
- [ ] Write to `.claude/checkpoints/{id}/auto.json`
- [ ] Update `.claude/checkpoints/latest` symlink
- [ ] Update `index.json` with new checkpoint
- [ ] Implement `/checkpoint` command (optional)
- [ ] Implement `/restore` command
- [ ] Implement `/rewind` command (v2)
- [ ] Implement `/branch` commands (v3)
- [ ] Test cross-agent compatibility

## Technical Specification

### auto.json Format (v1)
```json
{
  "version": 1,
  "checkpoint_id": "003",
  "timestamp": "2026-04-13T10:00:00Z",
  "trigger": "pre-compact",
  "session_id": "abc123",
  "agent": "claude-code",
  "cwd": "/path/to/project",
  "last_commands": ["Read", "Edit", "Bash"],
  "files_in_context": ["src/auth.ts", "src/middleware.ts"]
}
```

### index.json Format (v2)
```json
{
  "version": 2,
  "current": "005",
  "current_branch": "main",
  "branches": {
    "main": {
      "checkpoints": ["001", "002", "003", "005"],
      "created_at": "2026-04-13T10:00:00Z",
      "forked_from": null
    }
  },
  "checkpoints": [
    {
      "id": "001",
      "timestamp": "2026-04-13T10:00:00Z",
      "agent": "claude-code",
      "trigger": "pre-compact",
      "summary_preview": "Started auth implementation",
      "has_summary": true,
      "has_handoff": false,
      "branches": ["main"]
    }
  ]
}
```

## Benefits

1. **Never lose context** — Even when switching agents
2. **Pick the best tool** — Use different agents for different tasks
3. **Team collaboration** — Share checkpoints across team members
4. **Agent evolution** — Upgrade to better agents without losing history
5. **Experimentation** — Try new agents risk-free
