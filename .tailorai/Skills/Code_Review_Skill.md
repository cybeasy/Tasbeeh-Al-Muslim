# Skill: Systematic Code Review (/code-review)

## Purpose
Perform thorough, objective code reviews to catch bugs, security issues, architectural drift, and maintainability concerns.

## Review Steps
1. **Architectural Compliance:** Does the change follow the project's layered architecture and domain organization?
2. **Clean Code & SRP:** Are functions concise (< 20 lines) and components modular (< 150 lines)?
3. **Security Check:** Is input validated, output sanitized, and authorization enforced?
4. **Performance Check:** Are there any query bottlenecks, unindexed fields, or memory leaks?
5. **Test Coverage:** Are unit or integration tests included for the new logic?
6. **Task Alignment:** Do the changes match the objective described in the task file in `.tailorai/Tasks/`?
