---
name: merge
description: Merge a branch's checkpoints into current branch
---

# /merge — Merge Branch

Merge another branch's work into current branch.

## Usage

- `/merge experiment-auth` — Merge experiment-auth into current branch

## Behavior

1. **Get source branch checkpoints**
2. **Find divergence point** (last common checkpoint)
3. **List changes to merge:**
   ```
   🔀 Merging: experiment-auth → main

   ## Checkpoints to merge
   - #004: "Tried OAuth approach"
   - #005: "OAuth working"

   ## Files changed in branch
   - src/auth/oauth.ts (created)
   - src/auth/jwt.ts (modified)

   Proceed? (describe what to keep)
   ```

4. **On confirmation:**
   - Copy branch checkpoints to main timeline
   - Renumber if needed
   - Update index.json

5. **Confirm:**
   ```
   ✅ Merged experiment-auth into main
      Added 2 checkpoints

   💡 Run /branch delete experiment-auth to clean up
   ```
