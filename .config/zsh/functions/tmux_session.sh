tmux_session() {
    local session_name=$(basename "$PWD")
    local normalized_name=$(echo "$session_name" | tr '.' '_' | tr '-' '_')

    # Check if we're already inside a tmux session
    if [[ -n "$TMUX" ]]; then
        echo "Already inside tmux session: $TMUX_SESSION"
        echo "Use 'tmux switch-client -t $normalized_name' to switch to $session_name session"
        return 1
    fi

    # Check if tmux is installed
    if ! command -v tmux >/dev/null 2>&1; then
        echo "Error: tmux is not installed"
        return 1
    fi

    # Check if session exists
    if tmux list-sessions 2>/dev/null | grep -q "^$normalized_name:"; then
        echo "📎 Attaching to existing session: $session_name"
        tmux attach-session -t "$normalized_name"
    else
        echo "🆕 Creating new session: $session_name"
        # Create session in the current directory
        tmux new-session -s "$normalized_name" -c "$PWD"
    fi
}

# Additional utility functions
tmux_kill_session() {
    local session_name=$(basename "$PWD" | tr '.' '_' | tr '-' '_')
    if tmux list-sessions 2>/dev/null | grep -q "^$session_name:"; then
        tmux kill-session -t "$session_name"
        echo "🗑️  Killed session: $session_name"
    else
        echo "❌ No session found: $session_name"
    fi
}

tmux_list_sessions() {
    tmux list-sessions 2>/dev/null || echo "No tmux sessions running"
}

# Aliases
alias ts="tmux_session"
alias tks="tmux_kill_session"
alias tls="tmux_list_sessions"
