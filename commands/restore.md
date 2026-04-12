---
name: restore
description: Manually restore context from the latest checkpoint
---

# /restore — Restore Context

Manually restore context from the latest checkpoint.

## Instructions

1. **Check for checkpoint**: Look for `.claude/checkpoints/latest/auto.json`
   - If NOT exists: Output "ℹ️ No checkpoint found. Run /checkpoint to create one."

2. **Read auto.json**: Display key fields:
   - Session ID
   - Timestamp
   - Files in context
   - Last commands

3. **Check for summary.md**: If `.claude/checkpoints/latest/summary.md` exists:
   - Read and display the full content
   - Internalize:
     - Decisions (do NOT re-decide these)
     - Files modified (verify they still exist)
     - Errors encountered (avoid repeating)
     - Next steps (continue from here)
     - Key context (use verbatim)

4. **Confirm**: Output "✅ Context restored from checkpoint #{ID}. Ready to continue from: {first next step}"
