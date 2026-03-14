#!/bin/bash
# PostToolUse hook: Auto-lint after file edits
# Only runs linter (not formatter — that's auto-format.sh's job)

input=$(cat)

if command -v jq &>/dev/null; then
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')
else
  file_path=$(echo "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:.*"\(.*\)"/\1/')
fi

if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
  exit 0
fi

ext="${file_path##*.}"

case "$ext" in
  ts|tsx|js|jsx|mjs|cjs)
    if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
      npx biome lint "$file_path" 2>/dev/null
    elif [ -f ".eslintrc" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
      npx eslint "$file_path" 2>/dev/null
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check "$file_path" 2>/dev/null
    elif command -v uv &>/dev/null; then
      uv run ruff check "$file_path" 2>/dev/null
    fi
    ;;
esac

exit 0
