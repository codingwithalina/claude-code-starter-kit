---
description: Run comprehensive project validation (tests, types, lint, build)
allowed-tools: Read, Bash, Glob, Grep
---

# Validate: Comprehensive Project Check

Run all validation commands to ensure the project is in a healthy state.

## Mode

- `quick` or no argument → Level 1 (lint) + Level 2 (types) + Level 3 (tests) + Level 3b (coverage)
- `full` → All 5 levels including build and runtime
- Default: `quick` during /execute, `full` when standalone or in /build

## Process

### 1. Detect Project Tools

Read `CLAUDE.md` "Development Commands" section to identify available commands. If not populated, auto-detect from config files:

- `package.json` → scripts section (test, lint, typecheck, build)
- `pyproject.toml` → tool sections (pytest, mypy, ruff, pyright)
- `tsconfig.json` → TypeScript project
- `biome.json` → Biome linter/formatter

### 2. Run Validation Suite

Execute each detected command in order. Report results after each:

#### Level 1: Lint & Format Check
Run the project's linting and format checking commands.

**Expected**: No errors or warnings.

#### Level 2: Type Checking
Run type checker (tsc, mypy, pyright, etc.).

**Expected**: No type errors.

#### Level 3: Test Suite
Run the full test suite.

**Expected**: All tests pass.

#### Level 3b: Coverage Check
If coverage tooling is available (`vitest --coverage`, `jest --coverage`, `pytest --cov`):
- Run tests with coverage enabled
- Parse coverage for new/changed files (use `git diff --name-only` to identify changed files)
- Report files below 80% threshold
- **Status**: WARN (not blocking) — flag for visibility, do not fail the validation

If no coverage tooling is configured, skip this level silently.

#### Level 4: Build *(full mode only)*
Run the build command to verify the project compiles/bundles.

**Expected**: Build succeeds without errors.

#### Level 5: Runtime Validation *(full mode only, if applicable)*
If the project has a dev server or runtime entry point:
- Start it in background
- Run smoke test (health endpoint, CLI help, basic execution)
- Stop the server
- Report results

Skip if no runtime validation is configured in CLAUDE.md.

### 3. Summary Report

```
## Validation Results

| Check       | Status | Details              |
|-------------|--------|----------------------|
| Lint        | ✅/❌  | [output summary]     |
| Type Check  | ✅/❌  | [output summary]     |
| Tests       | ✅/❌  | [X passed, Y failed] |
| Coverage    | ✅/⚠️  | [X% avg, files below 80%] |
| Build       | ✅/❌/⏭️ | [output summary or "skipped (quick mode)"] |

**Overall: ✅ PASS / ❌ FAIL**
**Mode: quick / full**
```

### 4. If Failures Detected

For each failure:
- Identify the root cause
- Describe the fix. Do NOT apply fixes automatically — run `/code-review-fix` or fix manually, then re-run `/validate`.

Do NOT silently skip failing checks.

## Next Steps

- **All passing?** → `/commit`
- **Failures found?** → Fix issues, then re-run `/validate`
- **Want a code review first?** → `/review` before committing
