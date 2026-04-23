---
name: ray-review-python
description: Compatibility alias for Python cleanup and review prompts. Prefer ray-format-python for formatting-only work and ray-review-code for logic-focused review.
---

# Ray Review Python

Apply this skill only as a compatibility wrapper.

## Routing

- For formatting-only Python work, use `ray-format-python`.
- For logic-focused review, use `ray-review-code`.
- If a user asks for both, do formatting first and then review code.

## Workflow Note

When using this alias, first enumerate all changed files with `git`, then
process them one by one.

## Output Language

- Match the user's input language when it is clear.
- If the user's language is unclear or mixed, default to Chinese.
- If the user explicitly asks for English, respond in English.
- Keep code snippets, identifiers, comments, and docstrings in English when
  they are part of the reviewed Python code.
