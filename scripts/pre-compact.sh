#!/usr/bin/env bash
# pre-compact.sh — Save checkpoint before compaction
# RELIABILITY: 100% — must never crash

set +e  # Do not exit on error

# Configuration
CHECKPOINT_DIR="${CLAUDE_CWD:-.}/.claude/checkpoints"
MAX_CHECKPOINTS=20
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Logging function (silent, never fails)
log_error() {
    echo "$TIMESTAMP pre-compact $1" >> "$CHECKPOINT_DIR/.error-log" 2>/dev/null || true
}

# Get next checkpoint ID (zero-padded)
get_next_id() {
    local last_id=0
    if [[ -d "$CHECKPOINT_DIR" ]]; then
        last_id=$(ls -1 "$CHECKPOINT_DIR" 2>/dev/null | grep -E '^[0-9]+$' | sort -n | tail -1 || echo "0")
    fi
    printf "%03d" $((10#${last_id:-0} + 1))
}

# Get previous checkpoint ID
get_previous_id() {
    local current="$1"
    local prev=$((10#$current - 1))
    if [[ $prev -gt 0 ]]; then
        printf "%03d" $prev
    else
        echo "null"
    fi
}

# Extract last commands from transcript (simplified)
extract_last_commands() {
    local transcript="${CLAUDE_TRANSCRIPT_PATH:-}"
    if [[ -n "$transcript" ]] && [[ -f "$transcript" ]]; then
        # Extract tool names from last 5 tool uses
        tail -c 102400 "$transcript" 2>/dev/null | \
            grep -o '"tool_name":"[^"]*"' | \
            tail -5 | \
            sed 's/"tool_name":"//g; s/"//g' | \
            paste -sd ',' - 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Extract files from transcript (simplified)
extract_files() {
    local transcript="${CLAUDE_TRANSCRIPT_PATH:-}"
    if [[ -n "$transcript" ]] && [[ -f "$transcript" ]]; then
        tail -c 102400 "$transcript" 2>/dev/null | \
            grep -oE '"file_path":"[^"]*"' | \
            sed 's/"file_path":"//g; s/"//g' | \
            sort -u | \
            head -10 | \
            paste -sd ',' - 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Main function
main() {
    # Create checkpoint directory
    mkdir -p "$CHECKPOINT_DIR" 2>/dev/null || {
        log_error "Failed to create checkpoint directory"
        echo "⚠️ Checkpoint directory creation failed"
        return 0
    }

    # Get IDs
    local ID
    ID=$(get_next_id)
    local PREV_ID
    PREV_ID=$(get_previous_id "$ID")
    local CHECKPOINT_PATH="$CHECKPOINT_DIR/$ID"

    # Create checkpoint subdirectory
    mkdir -p "$CHECKPOINT_PATH" 2>/dev/null || {
        log_error "Failed to create checkpoint $ID"
        echo "⚠️ Checkpoint creation failed"
        return 0
    }

    # Extract context
    local LAST_CMDS
    LAST_CMDS=$(extract_last_commands)
    local FILES
    FILES=$(extract_files)

    # Format arrays for JSON
    local LAST_CMDS_JSON="[]"
    if [[ -n "$LAST_CMDS" ]]; then
        LAST_CMDS_JSON=$(echo "$LAST_CMDS" | tr ',' '\n' | sed 's/.*/"&"/' | paste -sd ',' - | sed 's/^/[/; s/$/]/')
    fi

    local FILES_JSON="[]"
    if [[ -n "$FILES" ]]; then
        FILES_JSON=$(echo "$FILES" | tr ',' '\n' | sed 's/.*/"&"/' | paste -sd ',' - | sed 's/^/[/; s/$/]/')
    fi

    # Write auto.json
    cat > "$CHECKPOINT_PATH/auto.json" 2>/dev/null << EOF
{
  "version": 1,
  "checkpoint_id": "$ID",
  "timestamp": "$TIMESTAMP",
  "trigger": "${CLAUDE_HOOK_MATCHER:-unknown}",
  "session_id": "${CLAUDE_SESSION_ID:-unknown}",
  "cwd": "${CLAUDE_CWD:-$(pwd)}",
  "last_commands": $LAST_CMDS_JSON,
  "files_in_context": $FILES_JSON
}
EOF

    if [[ $? -ne 0 ]]; then
        log_error "Failed to write auto.json"
        # Emergency fallback
        echo "{\"version\":1,\"checkpoint_id\":\"$ID\",\"timestamp\":\"$TIMESTAMP\",\"error\":\"partial\"}" > "$CHECKPOINT_PATH/auto.json" 2>/dev/null || true
    fi

    # Write meta.json
    local PREV_JSON="null"
    [[ "$PREV_ID" != "null" ]] && PREV_JSON="\"$PREV_ID\""

    cat > "$CHECKPOINT_PATH/meta.json" 2>/dev/null << EOF
{
  "version": 1,
  "checkpoint_id": "$ID",
  "created_at": "$TIMESTAMP",
  "trigger": "${CLAUDE_HOOK_MATCHER:-unknown}",
  "has_summary": false,
  "parent_checkpoint": $PREV_JSON
}
EOF

    # Update latest symlink
    ln -sfn "$ID" "$CHECKPOINT_DIR/latest" 2>/dev/null || {
        log_error "Failed to update latest symlink"
    }

    # === v2.0: Update index.json ===
    update_index || true

    # Output confirmation
    echo "✅ Checkpoint #$ID saved before compaction"

    return 0
}

# === v2.0: Index.json update function ===
update_index() {
    local INDEX_FILE="$CHECKPOINT_DIR/index.json"
    local SUMMARY_PREVIEW=""

    # Get summary preview if exists
    if [[ -f "$CHECKPOINT_PATH/summary.md" ]]; then
        SUMMARY_PREVIEW=$(grep -m1 "^## Current Task" -A1 "$CHECKPOINT_PATH/summary.md" 2>/dev/null | tail -1 | head -c 100 || echo "")
    fi

    # Create index if doesn't exist
    if [[ ! -f "$INDEX_FILE" ]]; then
        cat > "$INDEX_FILE" << 'INDEXEOF'
{
  "version": 1,
  "current": "001",
  "checkpoints": []
}
INDEXEOF
    fi

    # Update current pointer
    local TEMP_INDEX=$(mktemp)
    if command -v jq &> /dev/null; then
        jq --arg id "$ID" --arg ts "$TIMESTAMP" --arg trigger "${CLAUDE_HOOK_MATCHER:-unknown}" --arg preview "$SUMMARY_PREVIEW" \
           '.current = $id | .checkpoints += [{"id": $id, "timestamp": $ts, "trigger": $trigger, "summary_preview": (if $preview == "" then null else $preview end), "has_summary": false, "has_handoff": false}]' \
           "$INDEX_FILE" > "$TEMP_INDEX" && mv "$TEMP_INDEX" "$INDEX_FILE"
    else
        # Fallback: append entry manually (simplified)
        sed -i 's/"current": "[^"]*"/"current": "'"$ID"'"/' "$INDEX_FILE" 2>/dev/null || true
    fi
}

# Execute main and always exit 0
main
exit 0
