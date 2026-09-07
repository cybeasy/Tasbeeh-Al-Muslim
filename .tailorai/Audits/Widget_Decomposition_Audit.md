# Flutter Widget Decomposition & Performance Audit Protocol

## Context
You are acting as an Autonomous Flutter Architect and Performance Specialist for **tsbeh (Flutter Tasbeeh Al Muslim)**. Your task is to perform an analytical, read-only audit of UI screens and widgets to identify structural violations, unnecessary rebuild bottlenecks, missing resource disposals, and RTL directional defects.

## Mandatory Audit Steps:
1. **Consult Governance & Architecture Standards:**
   - Read `.tailorai/Agent.md`.
   - Read `.tailorai/Skills/Flutter_Clean_Arch_Skill.md`.
   - Read `.tailorai/Architecture/Visual_Identity.md`.

2. **Scan Screen Views & Custom Widgets:**
   - Inspect all UI files in `lib/screens/` and `lib/widget/`.

3. **Inspect for Violations:**
   - **Monolithic Build Methods:** Flag any `build()` method or widget file exceeding 150 lines.
   - **Private Helper Build Functions:** Flag occurrences of private widget-returning functions (e.g. `Widget _buildRow()`, `Widget _buildItem()`) instead of standalone `StatelessWidget` classes.
   - **Missing `const` Constructors:** Identify widgets that can be marked `const` to save memory and avoid element re-instantiation.
   - **Over-Broad BLoC Builders:** Identify `BlocBuilder` widgets wrapping entire screens or Scaffolds instead of targeted components.
   - **Resource Leaks:** Check that every `AnimationController`, `ScrollController`, `TextEditingController`, or `StreamSubscription` has a matching `.dispose()` or `.cancel()` in `dispose()`.
   - **Hardcoded Directionality:** Identify hardcoded `left` or `right` paddings/alignments that break RTL symmetry in Arabic mode.

4. **Generate Structured Audit Deliverable:**
   - **Executive Summary:** Overall Flutter architecture and UI health score (1–10).
   - **High-Risk Violations:** Direct file paths and exact line ranges.
   - **Performance Recommendations:** Specific code refactorings to boost FPS and reduce frame drops.
   - **Prioritized Remediation Checklist:** Atomic action steps for upcoming refactoring tasks.
