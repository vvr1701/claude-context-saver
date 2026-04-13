---
name: rewind
description: Restore to a previous checkpoint (time travel)
---

# /rewind — Time Travel

Restore context to a previous checkpoint.

## Usage

- `/rewind` — Show available checkpoints to rewind to
- `/rewind 1` — Go back 1 checkpoint
- `/rewind 2` — Go back 2 checkpoints
- `/rewind #005` — Go to specific checkpoint #005

## Behavior

1. **Parse argument:**
   - No argument → List last 10 checkpoints with timestamps
   - Number N → Calculate target: current - N
   - #NNN → Go to specific checkpoint

2. **Validate target exists:**
   - Check `.claude/checkpoints/{target}/auto.json` exists
   - If not exists: "❌ Checkpoint #{target} not found"

3. **Update latest symlink:**
   ```bash
   ln -sfn "{target}" .claude/checkpoints/latest
   ```

4. **Load target checkpoint:**
   - Read and display auto.json contents
   - Read and display summary.md if exists

5. **Confirm:**
   ```
   ⏪ Rewound to checkpoint #{target}
      Created: {timestamp}

   Context restored. You are now at checkpoint #{target}.
   Checkpoints after this point still exist — use /rewind #NNN to go forward.
   ```

## Edge Cases

- `/rewind 0` → Re-inject current checkpoint (refresh)
- `/rewind` beyond first → Go to checkpoint #001
- Target missing → Skip to nearest valid, warn user
