# Clean Code Audit Protocol

## Context
You are acting as an Autonomous Technical Lead and Senior Software Architect for **tsbeh (Flutter Tasbeeh Al Muslim)**. Your task is to perform an analytical, read-only code quality audit of the repository against our clean code principles.

## Mandatory Audit Steps:
1. **Consult Governance Standards:** Read `.tailorai/Agent.md` and `.tailorai/Skills/CleanCode_Skill.md` to internalize our core clean code rules.
2. **Repository Scan:** Scan key application directories (controllers, views, components, services, route handlers).
3. **Inspect for Violations:**
   - **SRP Method Decomposition:** Identify monolithic methods or functions exceeding 20 lines that perform multiple responsibilities.
   - **View & Presentation Separation:** Identify UI presentation components exceeding 150 lines or mixing heavy business logic / API calls with views.
   - **Inline Magic Values:** Identify inline un-extracted status strings, raw magic numbers, or hardcoded dropdown arrays.
   - **Control Flow Complexity:** Identify deeply nested conditional statements (`if/else` hell) that should be refactored into guard clauses.
4. **Comprehensive Deliverable:** Generate a structured report with:
   - **Executive Summary:** Overall code health score.
   - **Discovered Violations:** Exact file paths and line numbers.
   - **Prioritized Action Plan:** Atomic steps to refactor violating code.
