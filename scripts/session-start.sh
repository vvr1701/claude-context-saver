#!/usr/bin/env bash
# session-start.sh — Load checkpoint on session start
# RELIABILITY: 100% — must never crash

set +e  # Do not exit on error

# Configuration
CHECKPOINT_DIR="${CLAUDE_CWD:-.}/.claude/checkpoints"
LATEST="$CHECKPOINT_DIR/latest"
MATCHER="${CLAUDE_HOOK_MATCHER:-startup}"

# Main function
main() {
    # Check matcher type
    case "$MATCHER" in
        resume|compact)
            # Continuing session — try to restore
            if [[ -f "$LATEST/auto.json" ]]; then
                local ID
                ID=$(basename "$(readlink -f "$LATEST" 2>/dev/null || echo "$LATEST")" 2>/dev/null || echo "unknown")

                local TIMESTAMP
                TIMESTAMP=$(grep -o '"timestamp":"[^"]*"' "$LATEST/auto.json" 2>/dev/null | head -1 | sed 's/.*:"\([^"]*\)".*/\1/' || echo "unknown")

                echo "📂 Session resumed from checkpoint #$ID"
                echo "   Saved: $TIMESTAMP"
                echo ""

                # Inject auto.json contents
                if [[ -f "$LATEST/auto.json" ]]; then
                    local FILES_LIST COMMANDS_LIST
                    FILES_LIST=$(grep -o '"files_in_context":\[[^]]*\]' "$LATEST/auto.json" 2>/dev/null | sed 's/"files_in_context":\[//; s/\]//; s/"//g' || echo "")
                    COMMANDS_LIST=$(grep -o '"last_commands":\[[^]]*\]' "$LATEST/auto.json" 2>/dev/null | sed 's/"last_commands":\[//; s/\]//; s/"//g' || echo "")

                    if [[ -n "$FILES_LIST" ]]; then
                        echo "**Files in context:** $FILES_LIST"
                    fi
                    if [[ -n "$COMMANDS_LIST" ]]; then
                        echo "**Last actions:** $COMMANDS_LIST"
                    fi
                    echo ""
                fi

                # Include summary if available
                if [[ -f "$LATEST/summary.md" ]]; then
                    echo "---"
                    echo ""
                    cat "$LATEST/summary.md" 2>/dev/null || true
                    echo ""
                fi
            else
                echo "ℹ️ No checkpoint found for this project."
            fi
            ;;

        startup|clear|*)
            # New session — just show activation
            echo "📦 **claude-context-saver** active"
            echo "   • Auto-saves before compaction"
            echo "   • Run \`/checkpoint\` to save rich context"
            echo "   • Run \`/restore\` to manually restore"
            ;;
    esac

    return 0
}

# Execute main and always exit 0
main
exit 0
