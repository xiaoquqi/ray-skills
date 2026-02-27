---
name: ray-review-python
description: Enforce Python readability and review standards for hand-written code. Use when writing, refactoring, or reviewing Python files, especially for style consistency, logging quality, and actionable code-review findings.
---

# Ray Review Python

Apply this skill when editing or reviewing Python code for quality, readability,
and maintainability.

## Default Upstream Rules

In addition to Ray-specific rules in this file, load and apply these upstream
review skills by default from this repository:

- `skills/python-expert/SKILL.md`
- `skills/python-code-review/SKILL.md`

Rule precedence:

1. Use Ray rules in this file as baseline constraints.
2. Merge upstream checks for code quality, security, and maintainability.
3. If any rule conflicts with Ray rules, always follow Ray rules.
4. Report conflicting upstream rules as "advisory" with brief rationale.

## Trigger Signals

- "review this Python code"
- "fix Python style"
- "refactor for readability"
- "improve logging/docstrings/imports"

## Scope and Exceptions

Apply strictly to hand-written Python code. Relax or skip strict style checks for:

- migrations (`migrations/`, Alembic `versions/`)
- generated code (protobuf, OpenAPI, codegen outputs)
- vendored third-party code
- trivial boilerplate (`__init__.py` re-export only)
- large fixture/data files

## Core Standards

- Max line length: 79 characters.
- Imports at file top only, grouped as stdlib/third-party/local, alphabetized.
- Prefer absolute imports; use relative imports only when necessary.
- Comments and docstrings must be English.
- Comments go above code, not inline.
- Public classes/functions require triple-quoted docstrings.
- Use short, precise names.
- For `print` and logging with variables, use f-strings.
- Keep functions focused; split functions over ~100 lines when practical.
- Separate logical blocks with one blank line.
- Add contextual logging with appropriate level.
- For long tasks, log paired "Starting <task>" and "Finished <task>".

## Review Output Format

When user asks for a review, output in this order:

1. Findings first, sorted by severity.
2. Each finding includes file path and line reference.
3. Then open questions/assumptions.
4. End with brief summary and residual risks/testing gaps.

If no issues are found, state that explicitly.

## NOTE/TODO/FIXME Rules

For special blocks, use exactly one marker above the block:

- `NOTE(Ray):` rationale/constraint
- `TODO(Ray):` planned follow-up
- `FIXME(Ray):` known defect or temporary workaround

## Review Record Output

If generating a saved review/optimization report:

- Directory: `docs/review_histories`
- Filename: `<rule_name>_<base_commit_6>.md`
- Example: `docs/review_histories/ray-review-python_a1b2c3.md`

Reuse the same file for same rule + base commit.
