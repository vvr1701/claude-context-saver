---
name: handoff
description: Create an optimized checkpoint for session transfer or EOD
---

# /handoff — Session Handoff

Create a comprehensive checkpoint optimized for:
- Resuming tomorrow
- Handing off to another person
- Switching machines

## Behavior

1. **Create new checkpoint** (same as /checkpoint but with enhanced structure)

2. **Generate handoff.md** with this structure:

```markdown
# Session Handoff

<!-- Generated: {timestamp} -->
<!-- For: Next session or team member -->

## TL;DR (30 second summary)
{2-3 sentences: what we did, where we are, what's next}

## Context for New Session
{Assume the reader knows NOTHING about this session}

### Project State
- **Branch:** {current git branch}
- **Last commit:** {commit hash + message}
- **Uncommitted changes:** {yes/no + summary}

### What Was Accomplished
{Bullet list of completed items}

### Current Blocker (if any)
{What's stopping progress, or "None"}

### Immediate Next Step
{THE single most important next action}

## Detailed Context

### Decisions Made (with rationale)
{Each decision + WHY — so it's not re-debated}

### Files to Know About
{Key files + what they do + recent changes}

### Gotchas / Warnings
{Things that will bite you if you don't know}

### Commands to Run
{Any setup or verification commands needed}

## Key Code Context
```{language}
{Critical code that must be understood}
```
```

3. **Save to checkpoint:**
   - Write to `.claude/checkpoints/latest/handoff.md`
   - Update meta.json: `"has_handoff": true`

4. **Confirm:**
   ```
   📋 Handoff checkpoint saved to #{checkpoint_id}
      Ready for session transfer or resume.
   ```
