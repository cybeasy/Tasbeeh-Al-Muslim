# Testing Standards & Quality Assurance — tsbeh (Flutter Tasbeeh Al Muslim)

> **Agent Directive:** Populate testing framework commands and scopes below based on detected project configuration.

## 1. Test Suite Hierarchy
- **Unit Tests:** flutter_test (BLoC/Cubit, models, helper logic under test/)
- **Integration Tests:** Widget tests (testWidgets under test/)
- **E2E / UI Tests:** Flutter integration_test suite

## 2. Test Coverage Mandates
- Business domain logic and critical security paths MUST be fully covered by automated tests.
- API endpoints MUST test success paths, unauthorized access, and invalid input validation errors.

## 3. Execution Commands
- **Run Tests:** `fvm flutter test`
- **Type Checking:** `fvm flutter analyze`

## 4. Test Verification Workflow
Before marking any task as completed:
1. Execute `fvm flutter test` and verify zero failures.
2. Confirm zero regressions in existing test suite.
3. Add new test cases covering any added functionality or bug fix.
