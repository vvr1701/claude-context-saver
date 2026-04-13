# Cursor Adapter

Adapter for using claude-context-saver with Cursor IDE.

## Status: PLANNED

## Architecture

Cursor uses different hook mechanisms. This adapter will:
1. Translate Claude Code hooks → Cursor events
2. Use same checkpoint format
3. Share checkpoints between agents

## Installation (Future)

```bash
# In Cursor
cursor --install-extension claude-context-saver-cursor
```
