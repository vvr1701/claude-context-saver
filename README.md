# claude-context-saver

> Makes AI coding sessions persistent and recoverable — so you never have to re-explain again.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## The Problem

You're deep in a debugging session. Claude finally understands your architecture. Then:

```
⚠️ Context compacted

Claude: I don't have context about your project.
        Can you explain what we were doing?

You: 😐
```

## The Solution

**claude-context-saver** automatically saves checkpoints before compaction and restores them after.

```
✅ Context restored from checkpoint #003

Claude: Got it — we were implementing JWT refresh tokens.
        The bug was in verifyToken(). Let me continue...

You: 😌
```

## Install

```bash
/plugin add github:vvr1701/claude-context-saver
```

That's it. No configuration needed.

## How It Works

```
Session starts     →  📦 Plugin activates
You work           →  Context grows...
Context hits 83%   →  ✅ Auto-checkpoint saved
Compaction happens →  🔄 Context auto-restored
Session continues  →  You never re-explain
```

## Commands

| Command | Description |
|---------|-------------|
| `/checkpoint` | Save rich context (decisions, files, next steps) |
| `/restore` | Manually restore from latest checkpoint |

## What Gets Saved

**Automatically (100% reliable):**
- Session ID and timestamp
- Files in context
- Last commands executed

**Via /checkpoint (best effort):**
- Current task summary
- Decisions with rationale
- Files modified and why
- Errors and solutions
- Next steps
- Key code context

## Storage

Checkpoints are stored in your project:

```
.claude/checkpoints/
├── 001/
│   ├── auto.json      # Automatic (guaranteed)
│   └── summary.md     # Rich (/checkpoint)
├── 002/
│   └── ...
└── latest -> 002/
```

## Philosophy

- **Hooks are deterministic** — Auto-save always happens
- **LLM is best-effort** — Rich context when available
- **Never crash** — All errors handled silently
- **Zero config** — Works immediately after install

## License

MIT
