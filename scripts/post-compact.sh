#!/usr/bin/env bash
# post-compact.sh — Restore context after compaction
# RELIABILITY: 100% — must never crash

set +e  # Do not exit on error

# Configuration
CHECKPOINT_DIR="${CLAUDE_CWD:-.}/.claude/checkpoints"
LATEST="$CHECKPOINT_DIR/latest"

# Logging function
log_error() {
    local TIMESTAMP
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$TIMESTAMP post-compact $1" >> "$CHECKPOINT_DIR/.error-log" 2>/dev/null || true
}

# Main function
main() {
    # Check for latest checkpoint
    if [[ ! -L "$LATEST" ]] && [[ ! -d "$LATEST" ]]; then
        echo "ℹ️ No checkpoint found to restore."
        return 0
    fi

    local AUTO_JSON="$LATEST/auto.json"

    if [[ ! -f "$AUTO_JSON" ]]; then
        echo "ℹ️ Checkpoint exists but auto.json missing."
        return 0
    fi

    # Read checkpoint ID
    local ID
    ID=$(basename "$(readlink -f "$LATEST" 2>/dev/null || echo "$LATEST")" 2>/dev/null || echo "unknown")

    # Parse auto.json (simple extraction without jq dependency)
    local SESSION_ID TIMESTAMP FILES_LIST COMMANDS_LIST

    SESSION_ID=$(grep -o '"session_id":"[^"]*"' "$AUTO_JSON" 2>/dev/null | head -1 | sed 's/.*:"\([^"]*\)".*/\1/' || echo "unknown")
    TIMESTAMP=$(grep -o '"timestamp":"[^"]*"' "$AUTO_JSON" 2>/dev/null | head -1 | sed 's/.*:"\([^"]*\)".*/\1/' || echo "unknown")

    # Extract arrays (simplified)
    FILES_LIST=$(grep -o '"files_in_context":\[[^]]*\]' "$AUTO_JSON" 2>/dev/null | sed 's/"files_in_context":\[//; s/\]//; s/"//g' || echo "")
    COMMANDS_LIST=$(grep -o '"last_commands":\[[^]]*\]' "$AUTO_JSON" 2>/dev/null | sed 's/"last_commands":\[//; s/\]//; s/"//g' || echo "")

    # Output restored context
    echo "🔄 Context restored from checkpoint #$ID"
    echo ""
    echo "## Restored Context"
    echo "- **Session:** $SESSION_ID"
    echo "- **Saved:** $TIMESTAMP"

    if [[ -n "$FILES_LIST" ]]; then
        echo "- **Files in context:** $FILES_LIST"
    fi

    if [[ -n "$COMMANDS_LIST" ]]; then
        echo "- **Last actions:** $COMMANDS_LIST"
    fi

    echo ""
    echo "Continue from where you left off."

    # Also output summary.md if exists
    local SUMMARY="$LATEST/summary.md"
    if [[ -f "$SUMMARY" ]]; then
        echo ""
        echo "---"
        echo ""
        echo "## Rich Context (from /checkpoint)"
        echo ""
        cat "$SUMMARY" 2>/dev/null || true
    fi

    return 0
}

# Execute main and always exit 0
main
exit 0
