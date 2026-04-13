<div align="center">

# 🧠 claude-context-saver

**Makes AI coding sessions persistent and recoverable — so you never have to re-explain again.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://claude.ai/code)
[![Version](https://img.shields.io/badge/version-3.0.0-blue)]()

[Installation](#-installation) • [How It Works](#-how-it-works) • [Commands](#-commands) • [Usage Examples](#-usage-examples) • [Troubleshooting](#-troubleshooting)

</div>

---

## 😤 The Problem

You're deep in a debugging session. Claude finally understands your architecture, remembers your decisions, knows what you tried. Then:

```
⚠️ Context compacted

Claude: I don't have context about your project.
        Can you explain what we were doing?

You: *sighs* ... *starts typing the same explanation for the 5th time*
```

**This happens because:**
- Claude Code auto-compacts at ~83% context usage
- Compaction summarizes everything, losing 60-80% of details
- Your decisions, errors, and "why" context evaporate
- You waste 10-20 minutes re-explaining every time

---

## 😌 The Solution

**claude-context-saver** automatically saves checkpoints before compaction and restores them after:

```
✅ Context restored from checkpoint #003

Claude: Got it — we were implementing JWT refresh tokens.
        The bug was in verifyToken() on line 45.
        Let me continue from there...

You: 😌
```

**You never have to re-explain again.**

---

## 📋 Prerequisites

Before installing this plugin, you need:

### 1. Claude Code CLI

```bash
# Check if Claude Code is installed
claude --version

# If not installed, install it:
npm install -g @anthropic-ai/claude-code
```

### 2. Active Claude Account

You need an active Claude account with Claude Code access.

---

## 🚀 Installation

### Method 1: One-Command Install (Recommended)

Open your terminal, navigate to any project, start Claude Code, then run:

```bash
# Step 1: Start Claude Code in your project
cd /path/to/your/project
claude

# Step 2: Inside Claude Code, run this command:
/plugin add github:vvr1701/claude-context-saver
```

That's it! The plugin is now active for ALL your projects.

### Method 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/vvr1701/claude-context-saver.git ~/.claude/plugins/claude-context-saver

# Start Claude Code - it will auto-detect the plugin
cd /path/to/your/project
claude
```

### Method 3: Install from Source (For Contributors)

```bash
# Clone with full history
git clone https://github.com/vvr1701/claude-context-saver.git
cd claude-context-saver

# Link to Claude plugins directory
ln -s $(pwd) ~/.claude/plugins/claude-context-saver

# Verify installation
claude
# You should see: 📦 claude-context-saver active
```

---

## ✅ Verify Installation

After installation, start a new Claude Code session:

```bash
cd /path/to/any/project
claude
```

You should see this message on startup:

```
📦 claude-context-saver active
   • Auto-saves before compaction
   • Run /checkpoint to save rich context
   • Run /restore to manually restore
```

If you don't see this message, check [Troubleshooting](#-troubleshooting).

---

## 🔄 How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  SESSION LIFECYCLE                                          │
└─────────────────────────────────────────────────────────────┘

  Session starts
       │
       ▼
  📦 Plugin activates
       │
       │  ← You work with Claude, context grows...
       │
       ▼
  Context hits ~83%
       │
       ▼
  ✅ Auto-checkpoint saved (before compaction)
       │
       ▼
  [Compaction happens]
       │
       ▼
  🔄 Context auto-restored (after compaction)
       │
       ▼
  Session continues seamlessly
       │
       │  ← You never noticed anything happened
       │
       ▼
  Session ends
       │
       ▼
  🧹 Cleanup (keeps last 20 checkpoints)
```

### What Gets Saved

| Type | Reliability | Contents |
|------|-------------|----------|
| **Auto checkpoint** | 100% guaranteed | Session ID, timestamp, files in context, last commands |
| **Rich checkpoint** | Best effort (LLM) | Decisions, rationale, errors, solutions, next steps, code snippets |

### Where Checkpoints Live

```
your-project/
└── .claude/
    └── checkpoints/
        ├── 001/
        │   ├── auto.json      # Automatic (always exists)
        │   ├── summary.md     # Rich (from /checkpoint)
        │   └── meta.json      # Metadata
        ├── 002/
        │   └── ...
        └── latest -> 002/     # Symlink to most recent
```

---

## 📖 Commands

| Command | Description |
|---------|-------------|
| `/checkpoint` | Save rich context with decisions, files, next steps |
| `/restore` | Manually restore from latest checkpoint |
| `/rewind` | List available checkpoints |
| `/rewind N` | Go back N checkpoints |
| `/rewind #005` | Go to specific checkpoint #005 |
| `/handoff` | Create comprehensive checkpoint for session transfer |
| `/debug-session` | Analyze what changed between checkpoints |
| `/branch` | List all session branches |
| `/branch <name>` | Create new branch from current checkpoint |
| `/branch switch <name>` | Switch to existing branch |
| `/merge <name>` | Merge branch into current |

---

## 💡 Usage Examples

### Example 1: Basic Usage (Automatic)

Just work normally. The plugin handles everything:

```
You: Let's implement JWT authentication

Claude: [works on implementation...]

⚠️ Context approaching limit

✅ Checkpoint #001 saved before compaction

[Compaction happens]

🔄 Context restored from checkpoint #001

Claude: Continuing with JWT implementation. We were adding
        the refresh token logic to src/auth/jwt.ts...
```

### Example 2: Save Rich Context Before Break

```
You: /checkpoint

Claude: ✅ Rich checkpoint saved to #002

        ## Saved Context
        - Current task: JWT refresh token implementation
        - Decisions: Using HTTP-only cookies for security
        - Files: src/auth/jwt.ts, src/middleware/auth.ts
        - Next: Add rate limiting to auth routes
```

### Example 3: Time Travel After Bug

```
You: Something broke after my last changes. What changed?

You: /debug-session

Claude: 🔍 Debug: Checkpoint #003 → #004

        ## Changes Detected
        - src/auth/jwt.ts modified (lines 45-67)
        - New error: TypeError in verifyToken()

        💡 Suggestion: /rewind 1 to go back before this change

You: /rewind 1

Claude: ⏪ Rewound to checkpoint #003
        Context restored. The problematic changes are undone.
```

### Example 4: End of Day Handoff

```
You: I'm done for today, create a handoff for tomorrow

You: /handoff

Claude: 📋 Handoff checkpoint saved to #005

        ## TL;DR
        Implemented JWT auth, refresh tokens working.
        Blocked on rate limiting - need to decide on strategy.

        ## Immediate Next Step
        Decide between Redis vs in-memory rate limiting.
```

---

## 🔧 Troubleshooting

### Plugin not loading

**Symptom:** No "📦 claude-context-saver active" message on startup

**Fix:**
```bash
# Check if plugin is installed
ls ~/.claude/plugins/

# If not there, reinstall:
claude
/plugin add github:vvr1701/claude-context-saver
```

### Checkpoints not saving

**Symptom:** No `.claude/checkpoints/` directory in your project

**Fix:**
1. Checkpoints are created on first compaction or `/checkpoint`
2. Try running `/checkpoint` manually
3. Check write permissions on your project directory

### Context not restoring after compaction

**Symptom:** Claude still asks for context after compaction

**Fix:**
```bash
# Check if checkpoint exists
ls -la .claude/checkpoints/latest/

# If exists but not loading, try manual restore:
/restore
```

### Permission errors

**Symptom:** "Permission denied" in Claude output

**Fix:**
```bash
# Make scripts executable
chmod +x ~/.claude/plugins/claude-context-saver/scripts/*.sh
```

### Hooks not firing

**Symptom:** No auto-save on compaction

**Fix:**
```bash
# Verify hooks.json is valid
cat ~/.claude/plugins/claude-context-saver/hooks/hooks.json | python3 -m json.tool

# Restart Claude Code
exit
claude
```

---

## 📄 License

MIT License — Use it, fork it, improve it.

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

---

<div align="center">

**[⬆ back to top](#-claude-context-saver)**

Made by [vvr1701](https://github.com/vvr1701)

*"You never have to re-explain again."*

</div>
