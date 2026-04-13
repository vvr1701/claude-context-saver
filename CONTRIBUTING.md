# Contributing to claude-context-saver

Thank you for your interest in contributing! This document provides guidelines.

## Code of Conduct

Be respectful. Be helpful. Be patient.

## Getting Started

### Prerequisites

- Claude Code CLI installed
- Bash shell (macOS/Linux) or WSL (Windows)
- Git

### Setup Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/claude-context-saver.git
cd claude-context-saver

# Link to Claude plugins (for testing)
ln -s $(pwd) ~/.claude/plugins/claude-context-saver

# Test installation
claude
# Should see: 📦 claude-context-saver active
```

## Making Changes

### Branch Naming

- `feature/description` — New features
- `fix/description` — Bug fixes
- `docs/description` — Documentation

### Commit Messages

Follow conventional commits:
- `feat: add new command`
- `fix: handle edge case`
- `docs: update README`
- `chore: update dependencies`

### Critical Rules for Scripts

**All hooks must follow these rules:**

1. **Never crash:**
   ```bash
   set +e  # Do not exit on error
   ```

2. **Always succeed:**
   ```bash
   exit 0  # ALWAYS at the end
   ```

3. **Silent errors:**
   ```bash
   some_command 2>/dev/null || true
   ```

4. **Log errors internally:**
   ```bash
   echo "error message" >> .error-log 2>/dev/null || true
   ```

### Testing

Before submitting:

```bash
# Syntax check all scripts
bash -n scripts/*.sh

# Validate JSON
python3 -m json.tool .claude-plugin/plugin.json
python3 -m json.tool hooks/hooks.json

# Dry run
CLAUDE_CWD=/tmp bash scripts/pre-compact.sh
CLAUDE_CWD=/tmp bash scripts/post-compact.sh
```

## Pull Request Process

1. Update CHANGELOG.md with your changes
2. Update README.md if adding features
3. Ensure all tests pass
4. Request review from maintainers

## Questions?

Open an issue with the `question` label.
