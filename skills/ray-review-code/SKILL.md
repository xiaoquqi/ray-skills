---
name: ray-review-code
description: Use for language-agnostic code review focused on correctness, regression risk, compatibility, and maintainability. Trigger when the task is to review or critique behavior rather than format code.
---

# Ray Review Code

Use this skill for code review with a focus on logic and risk.

## Trigger Signals

- "review this code"
- "find bugs in this change"
- "check for regressions"
- "audit behavior and edge cases"
- "review this diff"

## Scope

Apply to any language unless the user narrows the scope further.

Use language-specific formatting helpers only when needed. For Python style-only
cleanup, prefer `ray-format-python`.

## Default Upstream Rules

When the review target includes Python files, also load and apply these
upstream review skills from this repository:

- `skills/python-expert/SKILL.md`
- `skills/python-code-review/SKILL.md`

Rule precedence:

1. Use Ray rules in this file as baseline constraints.
2. Merge upstream checks for code quality, security, and maintainability.
3. If any rule conflicts with Ray rules, always follow Ray rules.
4. Report conflicting upstream rules as "advisory" with brief rationale.

## Scope and Exceptions

When the review target includes Python files, relax or skip strict style checks
for:

- migrations (`migrations/`, Alembic `versions/`)
- generated code (protobuf, OpenAPI, codegen outputs)
- vendored third-party code
- trivial boilerplate (`__init__.py` re-export only)
- large fixture/data files

## Review Rules

- Review the full file and nearby context, not only the diff hunk.
- Focus on correctness, regressions, compatibility, coupling, and blast radius.
- Separate factual findings from assumptions.
- Raise open questions when evidence is insufficient.
- Do not make mechanical formatting the primary concern.

## Output Language

- Default to Chinese.
- If the user asks for English, respond in English.
- Keep the language consistent within one response.

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

## Review Workflow

1. Confirm the review scope.
2. Use `git diff --name-only` or an equivalent git command to find all
   changed files in scope.
3. Read the changed files and surrounding context, one file at a time.
4. Evaluate logic, edge cases, and downstream impact.
5. Check whether the change is necessary and minimal.
6. Summarize findings by severity.
7. Call out residual risks and missing tests.

## Output

When reporting back, lead with findings, then open questions, then a concise
risk summary.
