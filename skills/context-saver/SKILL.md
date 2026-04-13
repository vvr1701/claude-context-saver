# Context Saver Skill

## Description
Automatic context preservation across compaction events.

## Trigger Conditions
Activate this skill when:
- User mentions "save context", "checkpoint", "preserve state"
- Before switching to a significantly different task
- When user seems frustrated about lost context
- After detecting compaction occurred (context dramatically smaller)

## Behaviors

### Proactive Checkpointing
- After completing a significant sub-task, offer: "Would you like me to save a checkpoint?"
- Before context-heavy operations, suggest: "Consider running /checkpoint first"

### Post-Compaction Recovery
If you detect compaction occurred (conversation history is minimal but user references prior work):
1. Check for `.claude/checkpoints/latest/auto.json`
2. Read and internalize the checkpoint
3. Inform user: "I've restored context from checkpoint #X"
4. Continue from documented next steps

### Checkpoint Quality
When writing summary.md via /checkpoint:
- Include the WHY for each decision, not just WHAT
- Use complete file paths from project root
- Make code snippets complete and runnable
- Order next steps by priority

## Files
- `.claude/checkpoints/` — All checkpoint data
- `.claude/checkpoints/latest/` — Most recent checkpoint
- `auto.json` — Automatic context (always exists after compaction)
- `summary.md` — Rich context (created by /checkpoint)

## Commands
- `/checkpoint` — Save rich context manually
- `/restore` — Restore context manually

## v2 Commands

- `/rewind` — List checkpoints or go back N steps
- `/rewind N` — Go back N checkpoints (time travel)
- `/rewind #NNN` — Go to specific checkpoint
- `/handoff` — Create comprehensive handoff checkpoint
- `/debug-session` — Analyze what changed between checkpoints

## Time Travel Behavior

When user says:
- "go back" / "undo" / "revert" → Suggest `/rewind`
- "what changed" / "what broke" → Suggest `/debug-session`
- "end of day" / "handoff" / "switching machines" → Suggest `/handoff`
