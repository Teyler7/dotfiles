# Personal Preferences

## Commits
- Commit proactively with `jj` as work progresses: one commit per logical change, including its tests (e.g. "add flow panel keyboard nav" is one commit with its test, not three). A refactor or rename that enables the change gets its own commit first. Don't split finer than that just for the sake of it.
- Never add a `Co-Authored-By: Claude` (or any Claude/Anthropic co-author) trailer to commits.
- When a commit fixes a Linear ticket, include the ticket reference in parentheses at the end of the commit title, e.g. `Fix piped text rendering (POLL-2111)`.

## Version Control
- I use `jj` (Jujutsu) most of the time, not `git`. Prefer `jj` commands.
- If a repo has no `jj` (no `.jj` directory), don't silently fall back to `git` for VCS operations — tell me, and prompt me to run `jj git init` (or `jj init`) first.
- Do work in a **new worktree by default**, not the repo's default/main workspace. Create it before touching any files unless I say otherwise, or the task is read-only (investigation, review, answering a question). In Artemis use `USE_JJ=true bin/worktree create <name> --base main` — plain `bin/worktree create` gives you a `.jj`-less git worktree. Elsewhere use `jj workspace add`. Tell me the worktree path when you create one.

## Comments
- Don't over-comment. Let method and function names carry the intent.
- When a comment is genuinely needed, keep it to 1–2 lines at most.

## PR Descriptions
- Write normal, human PR descriptions. Skip the agentic "What / Why / Background / Summary of Changes" section scaffolding.
- A short prose description of the change is enough.
- End every PR description with a final line: `Claude posting on behalf of Teyler`.

## Remote Rails Jobs (pogo)

Run one-off Rails code against a deployed environment with pogo, pinned to the
current `origin/main` revision:

```bash
pogo app job run -a artemis -e staging -n artemis \
  -s "$(git ls-remote origin refs/heads/main | cut -f1)" \
  -c 'env DD_TRACE_STARTUP_LOGS=false RAILS_LOG_LEVEL=warn bin/rails runner "CMD WE WANT TO RUN"'
```

The `env` prefix silences the Datadog startup banners and info-level boot
events (AnyCable config) so only the command's own output prints. Drop
`RAILS_LOG_LEVEL=warn` when the job relies on `Rails.logger.info` for progress.

The Ruby in `-c` sits inside single quotes inside double quotes, so it can
contain neither `'` nor `"`. Use `%q{}` for plain strings and `%{}` when you
need interpolation.

Wrap read-only work in `ApplicationRecord.with_replica { }`, and print CSV to
stdout so the output pastes straight into a sheet.
