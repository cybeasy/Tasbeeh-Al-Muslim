# Git Workflow & Commit Guidelines — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Branch Naming Conventions
- Feature: `feat/task-slug`
- Bugfix: `fix/issue-description`
- Refactor: `refactor/component-name`
- Chore/Maintenance: `chore/deps-update`

## 2. Commit Message Structure
All commits MUST be structured atomically and reference the associated task file in `.tailorai/Tasks/`:

```text
type(scope): concise description of changes

Detailed explanation of why the change was made, technical trade-offs, or decisions.

Ref: .tailorai/Tasks/[category]/YYYY-MM-DD_[task_slug].md
```

### Commit Types
- `feat`: New feature or functionality
- `fix`: Bug fix
- `refactor`: Code refactoring without functionality changes
- `test`: Adding or modifying automated tests
- `docs`: Documentation updates
- `style`: Formatting or visual tweaks without logic changes
- `chore`: Maintenance, dependency updates, or tooling tasks

## 3. Pull Request Guidelines
- PR titles MUST match the task title.
- Each PR must include a link to the corresponding `.tailorai/Tasks/` file.
- All automated checks (linting, static analysis, unit tests) MUST pass before merging.
