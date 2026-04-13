---
name: branch
description: Fork current session into a named branch for experimentation
---

# /branch — Fork Session

Create a named branch from current checkpoint for experimentation.

## Usage

- `/branch` — List all branches
- `/branch experiment-auth` — Create new branch from current checkpoint
- `/branch switch main` — Switch to existing branch

## Behavior

### Create branch: `/branch <name>`

1. **Validate name:**
   - Alphanumeric + hyphens only
   - No spaces, no special chars

2. **Create branch directory:**
   ```
   .claude/checkpoints/branches/<name>/
   ```

3. **Copy current checkpoint to branch:**
   - Copy latest checkpoint to branch directory
   - Update branch's meta.json with branch info

4. **Update index.json:**
   ```json
   {
     "branches": {
       "main": ["001", "002", "003"],
       "experiment-auth": ["001", "002", "004"]
     },
     "current_branch": "experiment-auth"
   }
   ```

5. **Confirm:**
   ```
   🌿 Created branch: experiment-auth
      Forked from checkpoint #003

   You're now on branch 'experiment-auth'.
   New checkpoints will be saved to this branch.
   Use /branch switch main to return.
   ```

### List branches: `/branch`

```
📋 Session Branches

* experiment-auth (current)
  └── 2 checkpoints, last: 10 min ago

  main
  └── 5 checkpoints, last: 1 hour ago

Commands:
  /branch switch <name> — switch branch
  /branch delete <name> — delete branch
  /branch merge <name> — merge into current
```

### Switch branch: `/branch switch <name>`

1. **Update current_branch in index.json**
2. **Update latest symlink to branch's latest checkpoint**
3. **Load that checkpoint's context**
4. **Confirm switch**
