#!/bin/bash
# Stop hook: Notify when Claude finishes a task

input=$(cat)

if command -v jq &>/dev/null; then
  stop_reason=$(echo "$input" | jq -r '.stop_reason // "done"')
else
  stop_reason="done"
fi

# Cross-platform notification
if command -v osascript &>/dev/null; then
  # macOS
  osascript -e "display notification \"Claude Code has finished ($stop_reason)\" with title \"Claude Code\"" 2>/dev/null
elif command -v notify-send &>/dev/null; then
  # Linux
  notify-send "Claude Code" "Task finished ($stop_reason)" 2>/dev/null
elif command -v powershell.exe &>/dev/null; then
  # Windows (WSL/Git Bash)
  powershell.exe -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Claude Code has finished ($stop_reason)', 'Claude Code')" 2>/dev/null &
fi

exit 0
