---
description: Interactive project initialization wizard — configure tech stack, rules, skills, and commands
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Setup: Project Initialization Wizard

## Objective

Configure this starter kit for your specific project. This wizard will populate CLAUDE.md, copy relevant template rules and skills, install community skills, and verify the setup.

```
Supported Stacks:
- Frameworks: Next.js, FastAPI, CLI tools, AI Agents
- Databases: Supabase, PostgreSQL, SQLite
- ORMs: Prisma, Drizzle
- UI: shadcn/ui, Tailwind CSS
- Languages: TypeScript, Python
```

## Process

### Step 1: Detect or Ask Tech Stack

**Auto-detect first** by checking for existing config files:
- `package.json` → Node.js project (check for Next.js, React, etc.)
- `pyproject.toml` / `requirements.txt` → Python project (check for FastAPI, Flask)
- `tsconfig.json` → TypeScript enabled

**If no config files found or ambiguous, ask the user:**

**Phase A: Primary framework (exactly one)**
> What are you building?
> 1. **Next.js web app** (React, App Router, Tailwind)
> 2. **FastAPI backend** (Python, async)
> 3. **CLI tool** (Node.js or Python command-line application)
> 4. **AI Agent** (LLM-powered, JS/TS or Python)
> 5. **Custom** (I'll specify — Express, Hono, etc.)

**Phase A.5: Database & ORM (if applicable)**
> What database and ORM will you use?
> 1. **Supabase** (PostgreSQL + Auth + Edge Functions)
> 2. **PostgreSQL + Prisma ORM**
> 3. **PostgreSQL + Drizzle ORM**
> 4. **SQLite + Drizzle ORM** (dev/small projects)
> 5. **SQLite + Prisma ORM**
> 6. **None / configure later**

**Phase A.6: UI Library (if frontend project)**
> What UI library?
> 1. **shadcn/ui + Tailwind CSS**
> 2. **Tailwind CSS only**
> 3. **None / configure later**

**Phase B: Additional capabilities (zero or more)**
> Would you like to add any additional skill sets?
> - [ ] **Database patterns** (schema design, migrations, query optimization)
> - [ ] **API design patterns** (REST conventions, pagination, error handling)
> - [ ] **AI agent patterns** (tool design, prompt engineering, MCP)
> - [ ] **Testing patterns** (test architecture, mocking, fixtures for JS/TS and Python)

### Step 1.5: Greenfield Scaffold (if needed)

**If no source code exists** (no `package.json`, `src/`, `app/`, `pyproject.toml`):

Ask: "This appears to be a new project. Should I scaffold it?"

**Scaffolding per framework:**

- **Next.js:**
  - GOTCHA: `create-next-app` refuses non-empty directories — always scaffold in a temp dir
  - Run `npx create-next-app@latest temp-scaffold --typescript --tailwind --eslint --app --src-dir --no-git`
  - Move all files from `temp-scaffold/` into the project root
  - Remove `temp-scaffold/`
  - Update `package.json` name to match project
  - Ensure `eslint.config.mjs` exists (Next.js 15+ uses flat config)
  - Create `.gitattributes` if not present

- **FastAPI:**
  - Create `pyproject.toml` with project metadata, FastAPI + uvicorn dependencies
  - Create `app/main.py` with basic FastAPI app
  - Create `app/__init__.py`
  - Create `.python-version` with `3.12`

- **CLI tool (Node.js):**
  - Run `npm init -y`
  - Create `src/index.ts` with basic CLI entry point
  - Create `tsconfig.json`

- **CLI tool (Python):**
  - Create `pyproject.toml` with click/typer dependency
  - Create `src/<project_name>/cli.py`

### Step 2: Identify Architecture

**Ask the user:**
> What architecture pattern do you prefer?
> 1. **Vertical Slice Architecture** (recommended — organize by feature)
> 2. **Clean Architecture** (layers: domain, application, infrastructure)
> 3. **Simple/Flat** (for small projects — minimal structure)

### Step 3: Detect Package Manager & Tools

**Auto-detect:**
- Lock files: `pnpm-lock.yaml` → pnpm, `bun.lockb` → bun, `package-lock.json` → npm, `uv.lock` → uv, `yarn.lock` → yarn
- Test config: `vitest.config.*` → Vitest, `jest.config.*` → Jest, `pytest.ini` or `pyproject.toml[tool.pytest]` → pytest
- Lint config: `biome.json` → Biome, `.eslintrc*` or `eslint.config.*` → ESLint, `pyproject.toml[tool.ruff]` → Ruff

**If not detected, ask the user for each.**

### Step 4: Ask About MCP Servers (Optional)

> Would you like to enable any MCP server integrations?
> - [ ] **Playwright** — Browser automation & UI testing
> - [ ] **Supabase** — Database management
> - [ ] **GitHub** — GitHub API integration
> - [ ] **PostgreSQL** — Direct database access
> - [ ] **Memory** — Persistent memory across sessions
> - [ ] **Fetch** — Web content fetching
> - [ ] **Filesystem** — Extended file operations
> - [ ] **None for now** (can add later)

### Step 5: Execute Setup

Based on answers, perform these actions:

**a. Populate CLAUDE.md**
Edit the template sections in CLAUDE.md:
- Fill in Tech Stack, Architecture, Package Manager, Test Framework, Lint/Format
- Fill in Development Commands (install, dev, test, lint, typecheck, build)
- Fill in Key Directories (source, tests, config)

**b. Copy Matching Template Rules**
Based on the detected/chosen stack, copy relevant templates from `templates/rules/` to `.claude/rules/`:

| Selection | File to Copy |
|-----------|-------------|
| Next.js | `templates/rules/nextjs.md` → `.claude/rules/nextjs.md` |
| FastAPI | `templates/rules/fastapi.md` → `.claude/rules/fastapi.md` |
| CLI tool | `templates/rules/cli-tool.md` → `.claude/rules/cli-tool.md` |
| AI Agent | `templates/rules/ai-agents.md` → `.claude/rules/ai-agents.md` |
| Custom + Express | `templates/rules/express.md` → `.claude/rules/express.md` |
| Custom + Hono | `templates/rules/hono.md` → `.claude/rules/hono.md` |
| Supabase | `templates/rules/supabase.md` → `.claude/rules/supabase.md` |
| Prisma | `templates/rules/prisma.md` → `.claude/rules/prisma.md` |
| Drizzle | `templates/rules/drizzle.md` → `.claude/rules/drizzle.md` |
| shadcn/ui | `templates/rules/shadcn-ui.md` → `.claude/rules/shadcn-ui.md` |

Then add the `@import` for each copied rule file to CLAUDE.md.

**c. Copy Matching Template Skills**
Based on the stack and Phase B selections, copy skill templates to `.claude/skills/`:

**Default combinations (auto-included with primary framework):**
- Next.js → `vercel-react-best-practices/` + `vercel-composition-patterns/` + `nextjs-app-router-patterns/`
- FastAPI → `api-design/` + `database-schema-design/` + `fastapi-templates/` + `python-performance-optimization/`
- CLI tool → (no default skills)
- AI Agent → `agent-development/`
- Custom + Express → `express-typescript/` + `express-production/` + `api-design/`

**Phase B additions (user-selected, additive):**
- Database patterns → `database-schema-design/`
- API design patterns → `api-design/`
- AI agent patterns → `agent-development/`
- Python testing patterns → `python-testing-patterns/`

Deduplicate: if a skill is already included by the primary framework default, don't copy it twice.

**d. Create `.env.example`**
Based on stack selections, create `.env.example` with relevant placeholder values:

```bash
# Next.js
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# PostgreSQL (non-Supabase)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# SQLite
DATABASE_URL=file:./dev.db
```

Only include variables relevant to the user's selections.

**e. Create `.gitattributes`**
If `.gitattributes` doesn't exist in the target project, create it with line ending normalization.

**f. Configure MCP Servers (if selected)**
Read the selected MCP template(s) from `.claude/mcp-templates/` and merge their config into `.mcp.json` at the project root.

**g. Initialize Project Structure**
If starting fresh (no existing source code):
- Create recommended directory structure based on chosen architecture
- Create `.plans/` directory for plan files
- Initialize git if not already initialized
- Create `.gitignore` if it doesn't exist

**h. Install Dependencies (if applicable)**
Run the appropriate install command if package manager is configured.

### Step 5.5: Install Community Skills

After copying rules/templates, install relevant community skills using `npx skills add`. Based on the user's stack selections:

| Selection | Install Command | Source |
|-----------|----------------|--------|
| Next.js | `npx skills add vercel-labs/next-skills` | Vercel (Next.js best practices) |
| Supabase | `npx skills add supabase/agent-skills` | Supabase official |
| Prisma | `npx skills add prisma/skills` | Prisma official (v7 patterns) |
| shadcn/ui | `npx skills add shadcn/ui` | shadcn official |
| AI Agent | `npx skills add langchain-ai/langchain-skills` | LangChain |
| React/Tailwind | `npx skills add vercel-labs/agent-skills` | Vercel (already in kit) |

**Skills without official repos** (use template rules instead):
- Drizzle ORM → use `templates/rules/drizzle.md` (already copied in Step 5b)
- FastAPI → use existing `templates/skills/fastapi-templates/` (already copied in Step 5c)

### Step 6: Verify

Run `/prime` to verify everything loaded correctly:
- Confirm CLAUDE.md is populated
- Confirm rules are loading
- Confirm skills are detected
- Confirm commands are available

## Output

```markdown
### Setup Complete

**Project Configuration:**
- Tech Stack: [detected/chosen stack]
- Database: [chosen DB + ORM]
- UI Library: [chosen UI]
- Architecture: [chosen pattern]
- Package Manager: [detected/chosen]
- Test Framework: [detected/chosen]
- Lint/Format: [detected/chosen]

**Files Modified:**
- `CLAUDE.md` — Populated with project config
- `.claude/rules/` — [X] rule files active
- `.claude/skills/` — [X] skills available
- `.env.example` — Environment variable template
- `.gitattributes` — Line ending normalization
- `.claude/settings.json` — [MCP servers if any]

**Community Skills Installed:**
- [list of installed skills]

**Available Commands:**
- `/prime` — Load codebase context
- `/plan <feature>` — Create implementation plan
- `/execute <plan-path>` — Implement from plan
- `/validate` — Run all checks
- `/commit` — Create atomic commit
- `/build <feature>` — End-to-end pipeline
- `/create-prd <filename>` — Generate PRD
- `/review` — Code review
- `/execution-report` — Post-implementation reflection
- `/code-review-fix <review-file>` — Fix issues from a code review
- `/rca <issue-id>` — Root cause analysis
- `/fix <issue-id>` — Implement fix from RCA

**Next Steps:**
1. Review CLAUDE.md and adjust if needed
2. Start building: `/build <your-first-feature>`
```
