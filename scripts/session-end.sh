#!/usr/bin/env bash
# session-end.sh — Cleanup on session end
# RELIABILITY: 100% — must never crash
# NOTE: No stdout output (session is ending)

set +e  # Do not exit on error

# Configuration
CHECKPOINT_DIR="${CLAUDE_CWD:-.}/.claude/checkpoints"
MAX_CHECKPOINTS=20
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Main function
main() {
    # Log session end
    echo "$TIMESTAMP session_end session_id=${CLAUDE_SESSION_ID:-unknown}" >> "$CHECKPOINT_DIR/.session-log" 2>/dev/null || true

    # Cleanup old checkpoints
    if [[ -d "$CHECKPOINT_DIR" ]]; then
        # List numeric directories, sort, get all but last N
        local TO_DELETE
        TO_DELETE=$(ls -1 "$CHECKPOINT_DIR" 2>/dev/null | grep -E '^[0-9]+$' | sort -n | head -n -$MAX_CHECKPOINTS)

        for dir in $TO_DELETE; do
            rm -rf "${CHECKPOINT_DIR:?}/$dir" 2>/dev/null || true
        done
    fi

    return 0
}

# Execute main and always exit 0
main
exit 0
