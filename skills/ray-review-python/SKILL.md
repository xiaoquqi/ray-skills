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

- Default to Chinese.
- If the user asks for English, respond in English.
