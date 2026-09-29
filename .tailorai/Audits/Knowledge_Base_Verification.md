# Knowledge Base Verification Audit — tsbeh (Flutter Tasbeeh Al Muslim)

> [!NOTE]
> **Audit type:** Read-only diagnostic. This audit follows the contract defined in `AGENT_STRATEGY.md` §7.2: it **reports findings, never fixes them**, and it **never mutates code or governance files** (including `PROJECT_MAP.md`). All remediation is left to a separate, user-approved task.

## Context
You are the Lead Architect for **tsbeh (Flutter Tasbeeh Al Muslim)**. Your task is to **verify** that the Knowledge Base is internally consistent: that `PROJECT_MAP.md` accurately reflects the real `.tailorai/Tasks/` directory, that every task file follows the standard template, and that no references are dangling. You produce a **findings report** — you do **not** edit anything.

## Execution Steps (ALL READ-ONLY):

### 1. Internalize Mandates
Read `.tailorai/Agent.md`, `.tailorai/Architecture/Technical_Architecture.md`, and `.tailorai/Architecture/PRD.md` to understand the standards every task file must satisfy.

### 2. Inventory the Real Tasks Directory
Scan `.tailorai/Tasks/` (all subdirectories: `feature/`, `bugfix/`, `refactor/`, `backend/`, `frontend/`, `security/`, `migration/`, and any custom category). Build an authoritative list of every task file (`*.md`) that exists on disk, excluding `Task_Template.md` and any migration queue/report files in `migration/` (`migration_queue.md`, `step3_rules_migration_report.md`, `migration_report.md`).

### 3. Inventory the Map References
Parse `.tailorai/PROJECT_MAP.md` and extract every backtick-quoted task-file reference that points into `.tailorai/Tasks/` (e.g. `` `.tailorai/Tasks/feature/2026-08-12_xxx.md` ``). Build the list of paths the map *claims* exist.

### 4. Reconciliation Diff (the core verification)
Compare the two inventories and emit three findings lists:

- **🟠 `in_map_not_on_disk`** — the map references a task file that does **not** exist (dead link / dangling reference). This is the most important finding: the map promises context the agent cannot load.
- **🟡 `on_disk_not_in_map`** — a completed task file exists on disk but is **absent** from `PROJECT_MAP.md` (un-archived work; should either be in `ACTIVE_TASKS.md` or added to the map).
- **🔴 `orphaned_in_active`** — a task file referenced in `ACTIVE_TASKS.md` that does not exist on disk, or a task present in **both** `ACTIVE_TASKS.md` and `PROJECT_MAP.md` simultaneously (violates the two-register invariant: a task lives in exactly one register at a time).

### 5. Task Format Compliance Audit
For every task file on disk, check it against `.tailorai/Tasks/Task_Template.md` (the 3-section standard: `## 1. Objective`, `## 2. Atomic Execution Steps` with `[ ]`/`[x]` checkboxes, `## 3. Implementation Reality & Audit Log`, plus the header fields Date/Category/Target Files). Flag:
- **🔴 Malformed task file** — missing one of the 3 mandatory sections.
- **🟡 Incomplete header** — missing Date, Category, or Target Files.
- **🟡 Stale checkbox** — `[ ]` step under a task the map marks `[x]` completed (steps left unchecked despite completion), or vice-versa.

### 6. Documentation Drift Audit
For each completed task (map `[x]`), read its `## 3. Implementation Reality` section and spot-check whether the described code state plausibly matches the current codebase (files referenced still exist, APIs mentioned still present). This is a lightweight sanity check — flag obvious drift, do not re-verify exhaustively.

### 7. Produce the Findings Report
Output a structured report (do **not** modify any file). Structure:

```markdown
# Knowledge Base Verification Report
- **Date:** [YYYY-MM-DD]
- **Project:** tsbeh (Flutter Tasbeeh Al Muslim)
- **Task files on disk:** N
- **Map references:** M
- **Overall health:** ✅ Consistent / ⚠️ Minor drift / 🔴 Inconsistencies found

## A. Reconciliation Findings
### in_map_not_on_disk (dead references)
- [list each path, or "None"]

### on_disk_not_in_map (un-archived tasks)
- [list each path, or "None"]

### register conflicts (orphaned / dual-register)
- [list each path, or "None"]

## B. Task Format Findings
### Malformed task files (missing mandatory sections)
- [list file + missing section, or "None"]

### Incomplete headers / stale checkboxes
- [list file + issue, or "None"]

## C. Documentation Drift
- [list completed tasks whose Implementation Reality no longer matches code, or "None"]

## D. Recommended Remediation (for a separate, user-approved task)
- [Prioritized list of suggested fixes. NOTE: these are recommendations only — the user must approve a separate task file before any file is edited.]
```

> [!WARNING]
> **Contract reminder:** This audit outputs **findings, not fixes**. Do not edit `PROJECT_MAP.md`, do not refactor task files, do not move tasks between registers. Any remediation must happen in a subsequent, explicitly approved task that follows the 8-stage atomic cycle (`Agent.md` §3B). If you are tempted to "just fix it while you're here," stop — that violates the read-only audit contract.
