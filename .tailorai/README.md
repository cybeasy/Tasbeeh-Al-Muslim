# Governance & Technical Documentation (`.tailorai/`)
**Project:** tsbeh (Flutter Tasbeeh Al Muslim)

Welcome to the central AI governance, architectural specifications, and task tracking hub. All AI agents and human developers working on the repository must follow the guidelines documented here.

> **Companion references (in project root, outside `.tailorai/`):**
> - **`AGENT_BLUEPRINT.md`** — Architecture knowledge base: *what* the workspace is + *why* it was designed this way. The master reference for structure, decisions, and the placeholder contract.
> - **`AGENT_STRATEGY.md`** — Operational strategy: *how* the agent behaves + *when* it takes each action. Read this before changing any behavioral rule.
> - **`init-agent.md`** — Setup protocol (Steps 0-5) used to instantiate this workspace in a new repository.
>
> Read these first when extending or maintaining the agent itself.

---

## 📚 Core Documentation Index

### 1. Primary Operating Standards
* 🧭 **[PROJECT_MAP.md](PROJECT_MAP.md)**: Master index listing all foundation docs and completed task files.
* 🤖 **[Agent.md](Agent.md)**: Mandatory protocol for AI agents (task creation rules, code standards, execution protocol).
* 📋 **[ACTIVE_TASKS.md](ACTIVE_TASKS.md)**: Currently in-progress tasks.

### 2. Architecture & Design (`.tailorai/Architecture/`)
* 🏗️ **[Technical_Architecture.md](Architecture/Technical_Architecture.md)**: System architecture, tech stack, and folder structure.
* 📄 **[PRD.md](Architecture/PRD.md)**: Product Requirements Document — roles, modules, and scope.
* 🎨 **[Visual_Identity.md](Architecture/Visual_Identity.md)**: Visual identity guide, color palette, typography, and design tokens.

### 3. Operational Protocols (`.tailorai/Protocols/`)
* 🔌 **[API_Contracts.md](Protocols/API_Contracts.md)**: Standard API response envelopes and error shapes.
* 🔐 **[Security_Protocol.md](Protocols/Security_Protocol.md)**: Authentication, authorization, and data protection.
* 🧪 **[Testing_Standards.md](Protocols/Testing_Standards.md)**: Testing guidelines and quality assurance standards.
* 🚀 **[Deployment_Protocol.md](Protocols/Deployment_Protocol.md)**: Deployment procedures and environment setup.
* 🌿 **[Git_Workflow.md](Protocols/Git_Workflow.md)**: Branch naming, commit message standards, and PR guidelines.

### 4. AI Skills (`.tailorai/Skills/`)
* 🧹 **[CleanCode_Skill.md](Skills/CleanCode_Skill.md)**: Code quality, SRP, decomposition, and naming rules.
* 🔒 **[Security_Skill.md](Skills/Security_Skill.md)**: Security best practices and vulnerability prevention.
* ⚡ **[Performance_Skill.md](Skills/Performance_Skill.md)**: Performance optimization patterns.
* 🔍 **[Code_Review_Skill.md](Skills/Code_Review_Skill.md)**: Systematic code review methodology.
* 📱 **[Flutter_Clean_Arch_Skill.md](Skills/Flutter_Clean_Arch_Skill.md)**: Flutter & BLoC clean architecture, widget decomposition, and performance.
* 🎨 **[Designer_Skill.md](Skills/Designer_Skill.md)**: UI/UX design principles and accessibility.

### 5. Audit Prompts (`.tailorai/Audits/`)
* 🧹 **[CleanCode_Audit_Prompt.md](Audits/CleanCode_Audit_Prompt.md)**: Scan codebase for code quality violations.
* 🔒 **[Security_Audit_Prompt.md](Audits/Security_Audit_Prompt.md)**: Scan for security vulnerabilities.
* 📱 **[Widget_Decomposition_Audit.md](Audits/Widget_Decomposition_Audit.md)**: Scan Flutter widgets for decomposition and unnecessary rebuilds.
* 📂 **[TailorAI_Folder_Audit_Prompt.md](Audits/TailorAI_Folder_Audit_Prompt.md)**: Audit `.tailorai/` folder consistency and completeness.
* 🔄 **[Knowledge_Base_Verification.md](Audits/Knowledge_Base_Verification.md)**: Verify PROJECT_MAP matches actual Tasks.

---

## 📁 Directory Structure

```
.tailorai/
├── Agent.md                            # Master AI Instruction Protocol
├── PROJECT_MAP.md                      # Knowledge Base Master Index
├── ACTIVE_TASKS.md                     # Currently In-Progress Tasks
├── README.md                           # Documentation Index & Directory Guide
├── Architecture/                       # Architecture & Design System
│   ├── Technical_Architecture.md
│   ├── PRD.md
│   ├── Visual_Identity.md
│   └── Architecture_Questions.md       # Helper questions for setup
├── Protocols/                          # Operational Standards & Protocols
│   ├── API_Contracts.md
│   ├── Security_Protocol.md
│   ├── Testing_Standards.md
│   ├── Deployment_Protocol.md
│   └── Git_Workflow.md
├── Skills/                             # AI Agent Skills & Rules
│   ├── CleanCode_Skill.md
│   ├── Security_Skill.md
│   ├── Performance_Skill.md
│   ├── Code_Review_Skill.md
* 📱 **[Flutter_Clean_Arch_Skill.md](Skills/Flutter_Clean_Arch_Skill.md)**: Flutter & BLoC clean architecture, widget decomposition, and performance.
│   ├── Designer_Skill.md
│   └── Knowledge_Builder_Skill.md     # Step 4 legacy task conversion protocol
├── Audits/                             # Automated Audit Prompts
│   ├── CleanCode_Audit_Prompt.md
│   ├── Security_Audit_Prompt.md
* 📱 **[Widget_Decomposition_Audit.md](Audits/Widget_Decomposition_Audit.md)**: Scan Flutter widgets for decomposition and unnecessary rebuilds.
│   ├── TailorAI_Folder_Audit_Prompt.md
│   └── Knowledge_Base_Verification.md
├── Brand/                              # Brand Identity Assets
│   └── Brand_Guide_Template.md
└── Tasks/                              # Category-based Task Tracking
    ├── Task_Template.md
    ├── feature/
    ├── bugfix/
    ├── refactor/
    ├── backend/
    ├── frontend/
    ├── security/
    └── migration/                     # Legacy migration tasks & queue
```

---

## 🛠️ How to Work with Tasks

1. **Before starting a task:** Check `ACTIVE_TASKS.md` for ongoing work, then consult `PROJECT_MAP.md` to locate related completed tasks.
2. **Creating a new task:** Use `Task_Template.md` to format your task file inside `.tailorai/Tasks/[category]/YYYY-MM-DD_[task_slug].md`.
3. **Executing a task:** Work atomically (one sub-task at a time). Mark steps `[x]` upon completion and document all changes in `## 3. Implementation Reality`.
4. **Completing a task:** After user confirmation, remove from `ACTIVE_TASKS.md` and add to `PROJECT_MAP.md` with `[x]`.
