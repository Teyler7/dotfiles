# Personal Preferences

## Commits
- Never add a `Co-Authored-By: Claude` (or any Claude/Anthropic co-author) trailer to commits.

## Version Control
- I use `jj` (Jujutsu) most of the time, not `git`. Prefer `jj` commands.
- If a repo has no `jj` (no `.jj` directory), don't silently fall back to `git` for VCS operations — tell me, and prompt me to run `jj git init` (or `jj init`) first.

## Comments
- Don't over-comment. Let method and function names carry the intent.
- When a comment is genuinely needed, keep it to 1–2 lines at most.

## PR Descriptions
- Write normal, human PR descriptions. Skip the agentic "What / Why / Background / Summary of Changes" section scaffolding.
- A short prose description of the change is enough.
