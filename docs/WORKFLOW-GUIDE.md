# The Agentic Coding Workflow

How to build software with the Claude Code Starter Kit — the methodology behind the commands.

---

## Two-Tier Context System

| Tier | What | How it loads | Examples |
|------|------|-------------|----------|
| **Always-on** | Rules, CLAUDE.md | Automatically every session | Code quality, testing, security, git workflow |
| **On-demand** | Skills, plans, references | Activated when relevant or invoked | TDD methodology, debugging framework, PRD templates |

Rules define *what* Claude must always follow. Skills provide *how* — loaded only when the task matches, keeping context lean.

---

## Development Pipeline

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌──────────┐    ┌─────────┐
│  Prime  │───→│  Plan   │───→│ Execute │───→│ Validate │───→│ Commit  │
└─────────┘    └─────────┘    └─────────┘    └──────────┘    └─────────┘
  context        design       implement        verify          ship
```

| Phase | Kit command | What happens |
|-------|-------------|-------------|
| Context loading | `/prime` | Reads project structure, stack, git state |
| Design | `/plan <feature>` | Creates implementation plan with confidence score |
| Implementation | `/execute <plan>` | Implements from plan, validates per-task |
| Verification | `/validate` | Runs lint, types, tests, build |
| Shipping | `/commit` | Conventional commit with atomic changes |
| **Full pipeline** | `/build <feature>` | Chains all above with gates between steps |

Each step must pass a gate before the next begins. `/build` automates the entire pipeline. Use individual commands when you want manual control between steps.

---

## Validation Pyramid

```
          ┌───────────┐
          │   Build   │   Can it compile/bundle?        (full mode only)
         ┌┴───────────┴┐
         │  Coverage   │   Are new files ≥80%?           (warning, not blocking)
        ┌┴─────────────┴┐
        │    Tests      │   Does it behave correctly?
       ┌┴───────────────┴┐
       │  Type Checks    │   Are types consistent?
      ┌┴─────────────────┴┐
      │     Linting       │   Does it follow conventions?
     ┌┴───────────────────┴┐
     │   Code Review       │   Is it maintainable?
     └─────────────────────┘
```

`/validate quick` runs lint, types, tests, and coverage. `/validate full` adds build and runtime checks. `/review` adds the human-quality code review layer. Together they catch issues at every level before code is committed.

---

## Stress-Testing & Architecture

Two skills help you go beyond implementation:

- **`grill-me`** — Stress-test your plan before execution. Claude interviews you relentlessly about edge cases, trade-offs, and assumptions until the design is solid. Use it after `/plan` and before `/execute`.
- **`improve-codebase-architecture`** — Explore the codebase for architectural improvements: shallow modules, tight coupling, testability gaps. Produces RFCs as GitHub issues, not direct changes.

---

## Feedback Loops

```
/execution-report → /system-review → improve CLAUDE.md, commands, workflows
```

After each feature:

1. `/execution-report` compares the plan against what was actually built — captures divergences, challenges, and lessons learned
2. `/system-review` analyzes the process and suggests concrete improvements to CLAUDE.md, command templates, and workflows
3. Add recurring gotchas to `.claude/rules/known-issues.md` — this file is auto-loaded every session and checked during `/plan`
4. Apply the improvements so the next iteration is better

This is how the kit gets smarter over time. The `known-issues.md` file captures project-specific lessons, while `/system-review` improves the process itself.

---

## Best Practices

| Practice | Why |
|----------|-----|
| **Small iterations** | Each plan-implement-validate loop should be one logical change. Smaller scope = higher success rate. |
| **Subagent delegation** | Use `researcher` (haiku) for codebase exploration. Keep the main context focused on implementation. |
| **Context budgeting** | Run `/clear` between unrelated tasks. Keep sessions to 30-45 minutes. Context is a finite resource — at 70% utilization, precision drops. |
| **Parallel execution with worktrees** | When multiple features are independent, use worktrees so agents don't conflict on file edits. |
| **Vertical slices** | Structure features as vertical slices (route + logic + data + tests) for parallel-safe development. |
| **Plan as checkpoint** | Commit the plan before execution — enables rollback if implementation goes wrong. |
| **On-demand depth** | Skills load overviews first, deep references only when needed. Don't front-load context you might not use. |

---

## Workflow Examples

### New Feature (Autonomous)
```
/build add user authentication with JWT
```
One command. Prime → Plan → Execute → Validate → Commit with gates between each step.

### New Feature (Manual Control)
```
/prime                                    # Understand the codebase
/plan add user authentication with JWT    # Design the approach
# Review the plan, ask questions, iterate
/execute .plans/add-user-authentication.md  # Implement
/validate                                 # Verify everything passes
/commit                                   # Ship it
```

### Bug Fix
```
/rca 123                    # Investigate the bug
/fix 123                    # Implement the fix + tests
/commit                     # Ship the fix
```

### Stress-Test Before Building
```
/plan add payment processing
# Then before executing:
grill-me                    # Claude grills you on the plan
/execute .plans/add-payment-processing.md
```

### Continuous Improvement
```
/execution-report           # What diverged from the plan?
/system-review .plans/feature.md .plans/reports/feature-report.md
# Apply suggested improvements to CLAUDE.md and commands
```
