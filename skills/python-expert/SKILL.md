---
name: python-expert
description: Use this skill to write and review Python code with strong emphasis on readability, correctness, type safety, testing, and maintainability.
---

# Python Expert

Apply this skill when writing, refactoring, or reviewing Python code.

## Core Principles

- Readability first.
- Simplicity over cleverness.
- Prefer explicit behavior.
- Keep modules and functions focused.

## Style Rules

- Follow PEP 8 for formatting and naming.
- Keep line length within project limits.
- Keep import groups ordered: stdlib, third-party, local.
- Use descriptive names for functions, variables, and classes.
- Use docstrings for public modules, classes, and functions.
- Keep comments concise and useful.

## Type Hints

- Use type hints for function parameters and return values.
- Prefer modern syntax (`str | None`, `list[int]`, `dict[str, int]`) on Python 3.10+.
- Avoid `Any` when a concrete type is available.
- Use `Protocol`, `TypeVar`, and generics when they clarify intent.

## Code Quality

- Keep functions small and single-purpose.
- Avoid duplication; extract reusable logic.
- Prefer guard clauses to reduce nested conditionals.
- Raise specific exceptions; avoid bare `except`.
- Avoid mutable default arguments.
- Prefer context managers for resources.

## Security and Reliability

- Validate external input.
- Use parameterized SQL queries.
- Never hardcode secrets.
- Avoid unsafe dynamic execution (`eval`, `exec`) unless required and controlled.

## Testing

- Add or update tests for behavior changes.
- Test normal paths, edge cases, and failure paths.
- Keep tests deterministic and isolated.

## Review Output Format

When reviewing code, output in this order:

1. Findings sorted by severity.
2. File path and line reference for each finding.
3. For each finding, include:
   - `User Scenario`: concrete trigger scenario
   - `Impact`: what the caller, user, or operator will observe, whether the
     issue is user-visible, and the likely blast radius
   - `Cause`: code-level reason the issue occurs
   - `Suggested Fix`: direct repair approach, preferring the minimum viable fix
4. Open questions and assumptions.
5. Brief summary with residual risks and testing gaps.

If no issues are found, state that explicitly.

## Ray Compatibility

When this skill is used together with `ray-review-python`, Ray rules take
precedence for any conflicting requirement.
