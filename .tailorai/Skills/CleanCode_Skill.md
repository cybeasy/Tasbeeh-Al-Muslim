# Skill: Clean Code & Architecture Enforcement (/clean-code)

## Purpose
Enforce clean code, DRY (Don't Repeat Yourself), KISS (Keep It Simple, Stupid), and Single Responsibility Principles (SRP) across the entire codebase regardless of the target programming language or framework.

## Directives & Best Practices

### 1. Single Responsibility Principle (SRP)
- **Method / Function Decomposition:** Methods MUST be decomposed into small, single-purpose helper functions under 20 lines. No single function should handle validation, business logic, persistence, and output formatting simultaneously.
- **Component / View Decomposition:** Presentational components or UI views MUST be decomposed into pure sub-components under 150 lines.

### 2. Elimination of Magic Values & Hardcoding
- Extract all inline magic numbers, status strings, dropdown lists, and fixed configurations into constants, configuration files, or enums.
- Use explicit status types/enums (e.g. a typed state value of `idle`, `loading`, `success`, `error`) rather than scattered boolean flags.

### 3. Guard Clauses & Control Flow
- Use early exit guard clauses instead of deeply nested `if/else` branches.
- Keep execution paths linear, predictable, and readable.

### 4. Colocation & Separation of Concerns
- Colocate feature-specific helpers, services, modules, domain logic, or types next to their feature directory.
- Keep UI views pure and free of direct data-fetching, state manipulation, or complex business logic.
