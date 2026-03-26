#!/bin/bash

# Get the name of the current directory to use as the base session name
# Replace dots with underscores since tmux session names shouldn't contain dots
BASE_NAME=$(basename "$PWD" | tr '.' '_')
SESSION_NAME=$BASE_NAME

# Function to check if a tmux session exists
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Find an available session name
if session_exists "$SESSION_NAME"; then
    i=2
    while session_exists "${BASE_NAME}_${i}"; do
        i=$((i + 1))
    done
    SESSION_NAME="${BASE_NAME}_${i}"
fi

# Create the new detached session in the current directory
tmux new-session -d -s "$SESSION_NAME" -c "$PWD"

echo "Created tmux session: $SESSION_NAME"
