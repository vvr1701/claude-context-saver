---
name: debug-session
description: Analyze what changed between checkpoints to find where things broke
---

# /debug-session — Debug Session History

Analyze checkpoint history to find where something went wrong.

## Usage

- `/debug-session` — Compare last 2 checkpoints
- `/debug-session 3 5` — Compare checkpoint #003 to #005
- `/debug-session "auth broke"` — Find checkpoint where auth-related changes happened

## Behavior

### Default (no args): Compare last 2 checkpoints

1. **Identify checkpoints:**
   - Current: `.claude/checkpoints/latest`
   - Previous: parent_checkpoint from meta.json

2. **Compare and report:**
   ```
   🔍 Debug: Checkpoint #004 → #005

   ## Files Changed
   - `src/auth.ts` — Modified in #005
   - `src/middleware.ts` — Created in #005

   ## Decisions Changed
   - #004: "Using sessions for auth"
   - #005: "Switched to JWT" ← CHANGE

   ## Errors Introduced
   - #005: "TypeError in verifyToken()" ← NEW ERROR

   ## Likely Culprit
   The switch from sessions to JWT in checkpoint #005
   likely introduced the verifyToken() error.

   💡 Suggestion: /rewind 1 to go back before this change
   ```

### With checkpoint range: Compare specific checkpoints

1. **Read both checkpoints' auto.json and summary.md**
2. **Diff the files_in_context arrays**
3. **Diff the decisions (if summary.md exists)**
4. **Report changes**

### With search term: Find relevant checkpoint

1. **Search all summary.md files for term**
2. **List matching checkpoints**
3. **Suggest which to rewind to**
