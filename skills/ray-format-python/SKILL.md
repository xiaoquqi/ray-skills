---
name: ray-format-python
description: Use for Python formatting-only cleanup. Trigger on import order, whitespace, line length, naming clarity, docstrings, comments, and logging style when behavior must not change.
---

# Ray Format Python

Use this skill for Python cleanup that must not change behavior.

## Trigger Signals

- "format this Python file"
- "clean up Python style"
- "fix imports/docstrings/comments"
- "make this Python code more readable"
- "rename for clarity without changing behavior"

## Scope

Apply only to hand-written Python code.

Relax strict formatting checks for:

- migrations
- generated code
- vendored third-party code
- trivial `__init__.py` re-exports
- large fixture or data files

## Core Standards

- Max line length: 79 characters.
- Imports at file top only, grouped as stdlib/third-party/local,
  alphabetized.
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

## Allowed Edits

Focus on safe, non-logical edits:

- import ordering and grouping
- line length and whitespace
- naming clarity
- docstring and comment wording
- logging style and message clarity

## Do Not Change

- business logic changes
- behavior changes
- API changes
- broad refactors that alter control flow

## NOTE/TODO/FIXME Rules

For special blocks, use exactly one marker above the block:

- `NOTE(Ray):` rationale/constraint
- `TODO(Ray):` planned follow-up
- `FIXME(Ray):` known defect or temporary workaround

## Workflow

1. Use `git diff --name-only` or an equivalent git command to find all
   changed files in scope.
2. Review the full Python file, not just the changed hunk, one file at a time.
3. Apply the smallest safe formatting cleanup.
4. Keep edits localized and reversible.
5. If a change would affect behavior, stop and defer to `ray-review-code`.

## Output

When reporting back, describe only the formatting and readability changes made.
