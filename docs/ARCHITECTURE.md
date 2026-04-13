# Architecture

## Overview

claude-context-saver uses a three-layer architecture to ensure both reliability and intelligence.

## Layers

### 1. Infrastructure Layer (Hooks)
**Reliability: 100%**

- PreCompact hook — Auto-saves checkpoint
- PostCompact hook — Auto-restores context
- SessionStart hook — Detects resume scenario
- SessionEnd hook — Cleanup

These are deterministic bash scripts that never fail. They create the `auto.json` checkpoint that guarantees context survival.

### 2. Intelligence Layer (LLM Commands)
**Reliability: Best effort**

- `/checkpoint` — Rich context with decisions, rationale, next steps
- `/restore` — Manual restoration trigger
- `/rewind` — Time travel to previous checkpoints
- `/handoff` — Session transfer optimization
- `/debug-session` — Diff analysis between checkpoints
- `/branch` — Fork sessions for experimentation
- `/merge` — Merge branch work

These are LLM-powered and provide human-readable summaries in `summary.md` and `handoff.md`.

### 3. State Layer (Checkpoints)
**Format: Structured JSON + Markdown**

Each checkpoint contains:
- `auto.json` — Guaranteed context (files, commands, metadata)
- `summary.md` — Rich LLM-generated summary (optional)
- `handoff.md` — Session transfer summary (optional)
- `meta.json` — Checkpoint metadata and relationships

## Data Flow

```
Session starts
    ↓
User works → Context grows
    ↓
Context hits 83% threshold
    ↓
PreCompact hook fires → auto.json saved
    ↓
Compaction happens → Context cleared
    ↓
PostCompact hook fires → auto.json loaded
    ↓
Session continues seamlessly
```

## Time Travel (v2.0)

Time travel is implemented via symlink manipulation:

1. **Current checkpoint** = `.claude/checkpoints/latest` → `005/`
2. **Rewind to #003** = Update symlink: `latest` → `003/`
3. **Load checkpoint #003** context
4. **Forward checkpoints** (#004, #005) still exist
5. **Resume forward** via `/rewind #005`

The `index.json` provides O(1) lookup for checkpoint metadata without reading individual files.

## Branching (v3.0)

Branches allow parallel experimentation:

```
main: 001 → 002 → 003 → 005
                    ↓
          experiment: 004 → 006
```

- Branches share common checkpoints
- Each branch has independent timeline
- Merge reconciles divergent work
- Checkpoint IDs are globally unique

## Multi-Agent Support (v3.0)

Adapters translate between different agent systems:

```
Claude Code → checkpoint format ← Cursor adapter
                ↓
           Shared state
                ↓
    Any agent can resume session
```

## Design Principles

1. **Hooks are deterministic** — No LLM dependency for survival
2. **LLM adds intelligence** — But never required for basic function
3. **Never crash** — All errors handled gracefully
4. **Zero config** — Works immediately after install
5. **Git-like branching** — Familiar mental model
6. **Agent agnostic** — Checkpoint format is universal
