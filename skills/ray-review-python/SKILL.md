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

When user provides one or more target directories, treat them as mandatory review
scope boundaries. Only collect and review changed files within those directories.

## Review Workflow

Always run this workflow before giving review conclusions:

1. Confirm review scope first:
   - If user provides target directory/directories, use them as scope.
   - Otherwise, use repository-level scope.
2. Use `git diff` to gather the complete changed file list in confirmed scope.
3. Phase 1 - Format/style review and fix:
   - For each changed Python file, review full file content for style issues.
   - Apply safe non-behavioral fixes first (formatting, naming clarity,
     docstring/comment language, line length, import ordering).
4. Phase 2 - Logic review only (no direct logic edits):
   - Review modified hunks and nearby context for logic quality and risk.
   - Do not directly change business logic in this phase.
5. Phase 3 - Impact evaluation for user decision:
   - Summarize behavior/compatibility/blast-radius impacts.
   - Propose options and trade-offs, then let user decide logic changes.
6. Merge findings, remove duplicates, and output by severity.

Do not review only snippets from the changed hunk. Always confirm whole-file
consistency to avoid missing latent issues outside edited lines.

## Core Standards

- Max line length: 79 characters.
- Imports at file top only, grouped as stdlib/third-party/local, alphabetized.
- Prefer absolute imports; use relative imports only when necessary.
- Comments and docstrings must be English.
- Comments go above code, not inline.
- Public classes/functions require triple-quoted docstrings.
- Use short, precise, and simple names/wording where possible.
- For `print` and logging with variables, use f-strings.
- Keep functions focused; split functions over ~100 lines when practical.
- Separate logical blocks with one blank line.
- Add contextual logging with appropriate level.
- For long tasks, log paired "Starting <task>" and "Finished <task>".

## Change-Focused Logic Review

For every meaningful modified block, explicitly assess these questions:

1. Why was this change made?
2. Is this change necessary, or can the same goal be achieved with less change?
3. Is this the minimal safe change?
4. What is the blast radius and regression risk?
5. Which upstream/downstream call paths may be impacted?
6. Is there hard-coded logic/data/path/config that should be parameterized?
7. Does this hurt future extensibility or increase coupling?
8. Assuming this function is already used in production, what behavior contracts
   might break for existing callers?
9. Under the same assumption, what migration/compatibility safeguards are needed
   (for example: backward-compatible defaults, deprecation window, adapter)?

If evidence is insufficient to answer, raise it as an open question instead of
guessing.

## Review Output Format

When user asks for a review, output in this order:

1. Findings first, sorted by severity.
2. Each finding includes file path and line reference.
3. List format/style fixes already applied in Phase 1.
4. Then open questions/assumptions from logic review.
5. Provide a risk-focused summary as prioritized plain-text items (no table).
6. End with brief summary and residual risks/testing gaps.

If no issues are found, state that explicitly.

## Risk Summary Output (Non-Table)

Do not use Markdown tables. Some clients cannot render them.

Always summarize risk as prioritized plain-text entries using this format:

- `[P0] <dimension>` Assessment: High concern | Evidence: ... | Impact: ... |
  Mitigation: ...
- `[P1] <dimension>` Assessment: Medium concern | Evidence: ... | Impact: ... |
  Mitigation: ...
- `[P2] <dimension>` Assessment: Low concern | Evidence: ... | Impact: ... |
  Mitigation: ...

Use these dimensions (order by real risk, not fixed order):

- Necessity of change
- Minimal-change compliance
- Blast radius
- Upstream/downstream coupling impact
- Existing-caller compatibility risk
- Hard-code and extensibility risk

If a dimension has no clear conclusion, set Assessment to `Unknown` and explain
what evidence is missing.

## NOTE/TODO/FIXME Rules

For special blocks, use exactly one marker above the block:

- `NOTE(Ray):` rationale/constraint
- `TODO(Ray):` planned follow-up
- `FIXME(Ray):` known defect or temporary workaround
