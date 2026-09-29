# Architecture Questions — Helper Guide for tsbeh (Flutter Tasbeeh Al Muslim)

> **Helper Document:** Use the questions below to gather information for populating:
> - `Technical_Architecture.md`
> - `PRD.md`
> - `Visual_Identity.md`
>
> Sections 4–6 below additionally feed the operational protocol files (`Security_Protocol.md`, `Deployment_Protocol.md`, `Testing_Standards.md`) — those tokens are auto-populated in Step 1 where detectable, but the questions help confirm them during Step 2.
>
> You can answer these manually or prompt the AI Agent to help construct the architecture files based on your answers.

---

## 1. Technical Architecture
> Feeds: `Technical_Architecture.md`

### 1.1 Tech Stack
- What is the Backend Framework? (Laravel, Django, Express.js, Go, .NET, Rails, etc.)
- What is the Frontend Framework? (Next.js, Vue, React, Flutter, Angular, None, etc.)
- What is the Database? (PostgreSQL, MySQL, MongoDB, SQLite, etc.)
- What is the Cache/Queue System? (Redis, RabbitMQ, SQS, etc. — if applicable)
- What is the Storage/CDN? (S3, R2, Cloudinary, Local, etc. — if applicable)
- What is the Auth mechanism? (JWT, Session cookies, OAuth2, etc.)

### 1.2 Architectural Patterns
- What is the overall architecture pattern? (Monolith, Modular Monolith, Microservices, Serverless, etc.)
- What key design patterns are used? (MVC, HMVC, Clean Architecture, Domain-Driven Design, Repository+Service, CQRS, etc.)
- Is there a specific domain/feature module organization?
- What is the main directory layout? (Sketch a high-level tree)

### 1.3 Communication & APIs
- What API paradigm is used? (REST, GraphQL, gRPC, tRPC, etc.)
- Are WebSockets or real-time event systems present?
- What external third-party APIs are integrated?

### 1.4 Database Schema & Data Model
- What are the key database tables/collections and their relationships? (List core entities + cardinality, e.g. User 1—N Orders)
- Are there any polymorphic, multi-tenant, or soft-delete patterns in the schema?

---

## 2. Product Requirements Document (PRD)
> Feeds: `PRD.md`

### 2.1 Product Overview
- What is the product? (Clear one-sentence summary)
- What primary problem does it solve?
- Who is the target audience?

### 2.2 Roles & Permissions
- What are the user roles? (Admin, User, Doctor, Staff, etc.)
- What permissions apply to each role?
- Is there a Multi-tenancy architecture? (SaaS / Standalone / Both)

### 2.3 Core Modules
- What are the primary feature modules?
  - Example: Authentication, Dashboard, Billing, Users, Reports, Settings
- Which modules are completed versus pending development?

### 2.4 Primary User Journeys
- What are the top 3 user journeys?
  - Example: Registration → Onboarding / Account Setup → Daily Core Usage

### 2.5 Capacity & Non-Functional Requirements
- What are the expected scale targets? (Concurrent users, requests/sec, data volume, retention)
- What are the non-functional requirements across:
  - **Performance** (latency budgets, page-load targets)
  - **Security** (compliance standards: GDPR, HIPAA, PCI, etc., if applicable)
  - **Accessibility** (WCAG level targeted, RTL/LTR, screen-reader support)
  - **Scalability** (horizontal vs vertical, expected growth)

---

## 3. Visual Identity & Design Tokens
> Feeds: `Visual_Identity.md`

### 3.1 Color System
- Primary Color?
- Secondary Color?
- Accent Color? (for success / positive feedback states)
- Danger Color? (for errors, destructive actions)
- Background Color?
- Surface / Container Color?
- Is Dark Mode supported? (If yes, provide the dark-mode equivalents of the colors above; if no, state "Single theme only" so the token is flagged rather than invented.)

### 3.2 Typography
- What font family is used? (Inter, Roboto, System UI, etc.)
- What is the Heading scale / ratio? (e.g. 1.25 major third, or list each heading size)
- What is the Body scale / base font size? (e.g. 16px base with 1.125 ratio)
- Is RTL/Multilingual layout required? (This populates `{{LAYOUT_DIRECTION}}` — LTR / RTL / Multilingual)

### 3.3 Spacing & Geometry
- What spacing grid baseline is used? (e.g. 4px / 8px base unit)
- What border radius scale applies? (e.g. sharp / 4px / 8px / pill)
- Is a Design System or CSS Token set defined? (If yes, where is it stored so tokens can be auto-detected?)

---

## 4. Localization & i18n
> Feeds: `Security_Protocol.md` validation scope + `Visual_Identity.md` direction token

- What locales are supported?
- How is localization key parity managed?

---

## 5. Security
> Feeds: `Security_Protocol.md`

- What authentication mechanism is enforced? (JWT, Session, OAuth, etc.)
- What authorization model applies? (RBAC, ABAC?)
- Is this multi-tenant? If yes, how is tenant isolation enforced? If single-tenant, state "N/A — single-tenant" so the `{{TENANT_ISOLATION_SPEC}}` token is flagged rather than left ambiguous.
- What input validation engine is used? (e.g. Zod, Pydantic, FormRequests, DTOs/Schemas)
- Are rate limits or anti-bot protections required?

---

## 6. DevOps & Execution
> Feeds: `Deployment_Protocol.md` + `Testing_Standards.md`

- What is the deployment environment? (Docker, VPS, Vercel, AWS, etc.)
- What command runs the local dev server?
- What command runs the test suite?
- What command runs type checking? (And linting, if separate/combined)
- What is the staging deploy process?
- What is the production deploy process?
