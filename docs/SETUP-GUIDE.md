# Detailed Setup Guide

This guide covers all installation methods and configurations.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
- [Configuration](#configuration)
- [Verification](#verification)
- [Uninstallation](#uninstallation)

---

## Prerequisites

### Required

| Requirement | Minimum Version | Check Command |
|-------------|-----------------|---------------|
| Claude Code CLI | Latest | `claude --version` |
| Bash | 4.0+ | `bash --version` |
| Git | 2.0+ | `git --version` |

### Install Claude Code CLI

```bash
# Using npm (recommended)
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

---

## Installation Methods

### Method 1: Plugin Command (Easiest)

**Best for:** Most users

```bash
# 1. Start Claude Code in any directory
claude

# 2. Run the plugin install command
/plugin add github:vvr1701/claude-context-saver

# 3. Restart Claude Code
exit
claude

# 4. Verify
# You should see: 📦 claude-context-saver active
```

### Method 2: Git Clone

**Best for:** Users who want to inspect the code first

```bash
# 1. Clone to plugins directory
git clone https://github.com/vvr1701/claude-context-saver.git \
    ~/.claude/plugins/claude-context-saver

# 2. Make scripts executable
chmod +x ~/.claude/plugins/claude-context-saver/scripts/*.sh

# 3. Start Claude Code
claude

# 4. Verify
# You should see: 📦 claude-context-saver active
```

### Method 3: Manual Download

**Best for:** Users without Git

1. Download ZIP from: https://github.com/vvr1701/claude-context-saver/archive/main.zip
2. Extract to `~/.claude/plugins/claude-context-saver/`
3. Run: `chmod +x ~/.claude/plugins/claude-context-saver/scripts/*.sh`
4. Start Claude Code

### Method 4: Development Setup

**Best for:** Contributors

```bash
# 1. Fork on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/claude-context-saver.git
cd claude-context-saver

# 2. Create symlink
ln -s $(pwd) ~/.claude/plugins/claude-context-saver

# 3. Make scripts executable
chmod +x scripts/*.sh

# 4. Test
claude
```

---

## Configuration

### Plugin Location

The plugin installs to:
```
~/.claude/plugins/claude-context-saver/
```

### Checkpoint Location

Checkpoints are stored per-project:
```
/your/project/.claude/checkpoints/
```

### Customization

Currently, the plugin works with zero configuration. Future versions may support:

- Custom checkpoint directory
- Checkpoint retention count
- Auto-checkpoint frequency

---

## Verification

### Step 1: Check Plugin Files

```bash
ls -la ~/.claude/plugins/claude-context-saver/
```

Expected:
```
.claude-plugin/
hooks/
scripts/
commands/
skills/
README.md
LICENSE
CHANGELOG.md
```

### Step 2: Check Scripts Executable

```bash
ls -la ~/.claude/plugins/claude-context-saver/scripts/
```

All `.sh` files should show `x` permission.

### Step 3: Check Startup Message

```bash
claude
```

Should display:
```
📦 claude-context-saver active
   • Auto-saves before compaction
   • Run /checkpoint to save rich context
   • Run /restore to manually restore
```

### Step 4: Test Manual Checkpoint

```bash
# Inside Claude Code
/checkpoint
```

Should create `.claude/checkpoints/001/` in your project.

---

## Uninstallation

### Method 1: Plugin Command

```bash
# Inside Claude Code
/plugin remove claude-context-saver
```

### Method 2: Manual Removal

```bash
rm -rf ~/.claude/plugins/claude-context-saver
```

### Clean Up Project Checkpoints (Optional)

```bash
# In each project where you used the plugin
rm -rf .claude/checkpoints
```

---

## Platform-Specific Notes

### macOS

Works out of the box.

### Linux

Works out of the box.

### Windows (WSL)

1. Use WSL (Windows Subsystem for Linux)
2. Install Claude Code in WSL
3. Follow Linux instructions

### Windows (Native)

Not currently supported. Use WSL.

---

## Troubleshooting Installation

See [Troubleshooting](../README.md#-troubleshooting) in main README.
