# Anti-Patterns Guide

Common mistakes when working with Claude Code — and how to avoid them.

## Workflow Anti-Patterns

### Prompt Tunneling

**Problem:** Sending 10+ messages without checking intermediate results. Claude drifts from the goal, compounds errors, and wastes context.

**Fix:** Review output after each meaningful step. Confirm direction before continuing. Use sub-agents for parallel exploration instead of deep serial chains.

### Ghost Context

**Problem:** Assuming Claude remembers details from a previous session. Each conversation starts fresh — Claude has no memory of prior work unless you provide it.

**Fix:** Use CLAUDE.md for persistent project rules. Use memory-enabled sub-agents for cross-session knowledge. Reference specific files and line numbers instead of saying "that thing we changed."

### Mega-Prompt

**Problem:** Requesting 5 features in a single message. Claude may miss some, conflate requirements, or produce inconsistent implementations.

**Fix:** One task per prompt. If tasks are related, use a plan file to sequence them. Use sub-agent parallel dispatch for truly independent tasks.

### Kitchen Sink Session

**Problem:** Mixing unrelated tasks (debug auth, then refactor CSS, then add a feature) in one session. Context fills with irrelevant information, degrading quality.

**Fix:** Use `/clear` between unrelated tasks. Start fresh sessions for fresh topics. Keep sessions focused on one area of the codebase.

## Configuration Anti-Patterns

### Over-Specified CLAUDE.md

**Problem:** A 500+ line CLAUDE.md that tries to cover every scenario. Claude can't prioritize, and important rules get lost in noise.

**Fix:** Keep CLAUDE.md under 200 lines. Use `.claude/rules/` files for detailed standards. Use imperative, specific statements — not essays.

### Zero Verification

**Problem:** No test/lint/build commands configured. Claude makes changes but has no way to validate them. Bugs accumulate silently.

**Fix:** Always define verification commands in CLAUDE.md. Run tests after every change. "Give Claude a way to verify its work" is the single highest-leverage practice.

## Hook Anti-Patterns

### Stop Hook Loops

**Problem:** A Stop hook that triggers additional Claude activity, which triggers another Stop, creating an infinite loop.

**Fix:** Guard Stop hooks with an environment variable check (e.g., `STOP_HOOK_ACTIVE`). Keep Stop hooks lightweight — notifications only, no complex logic.

### Exit Code Confusion

**Problem:** Using `exit 1` when you mean to block a tool call. In hooks, `exit 1` is a non-blocking error (hook failed), while `exit 2` blocks the tool from executing.

**Fix:**
- `exit 0` — success, continue normally
- `exit 1` — hook error (logged but tool still runs)
- `exit 2` — block the tool call (PreToolUse only)

Use the JSON output format with `permissionDecision: "ask"` for softer blocking that lets the user decide.

## Context Anti-Patterns

### Reading Everything Upfront

**Problem:** Reading every file in a directory "just in case." Burns context window budget on irrelevant code.

**Fix:** Read just-in-time. Use glob/grep to find specific files first. Read interfaces before implementations. Delegate broad research to sub-agents.

### Ignoring Context Limits

**Problem:** Running sessions for hours without clearing. After ~30-45 minutes of active work, context quality degrades as older messages get compressed.

**Fix:** Use `/clear` between tasks. Start new sessions for major topic changes. Use sub-agents to offload research-heavy work from the main context.
