---
name: ray-git-commit
description: Generate a high-quality English commit message from staged changes only, then commit automatically in a specified repository. Use when the user asks to draft commit text from `git diff --cached`, enforce strict commit formatting, and create the commit without touching unstaged files.
---

# Ray Git Commit

Use this skill when the user wants an auto-generated commit message and an
immediate commit from staged changes.

## Trigger Signals

- "generate commit message from staged changes"
- "commit current staged diff"
- "write commit log and commit"

If the user asks for message drafting only, generate the message but skip
`git commit`.

## Required Inputs

- Repository path (`<repo_dir>`)

If repo path is unclear, stop and ask for it.

## Hard Constraints

- Run all git commands as `git -C <repo_dir> ...`.
- Analyze only `git -C <repo_dir> diff --cached --no-color`.
- Never include unstaged or untracked changes.
- Do not run `git add` unless explicitly requested.
- Do not amend commits unless explicitly requested.
- Use `/tmp` for temporary message files.

## Commit Message Contract

Format exactly:

1. Subject line:
   - imperative mood
   - <= 50 chars
   - no trailing punctuation
2. Blank second line
3. Body:
   - explain changes by logical area, then by key files
   - include intent and behavioral/implementation impact
   - <= 79 chars per line
   - professional engineering English

## Workflow

1. Validate repo:
   - `git -C <repo_dir> rev-parse --is-inside-work-tree`
2. Read staged diff:
   - `git -C <repo_dir> diff --cached --no-color`
3. If no staged changes, stop and report it.
4. Draft commit message from staged diff only.
5. If user requested commit:
   - write message to `/tmp/<file>.txt`
   - run `git -C <repo_dir> commit -F /tmp/<file>.txt`
   - remove temp file

## Final Response Contract

- If commit executed: return commit message text and short commit result.
- If draft-only: return commit message text only.
