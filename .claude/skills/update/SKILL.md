---
name: update
description: Only invoke via /update.
---

# Update dependencies

## Branch & PR

- Branch name: `update-YYYY-MM-DD-HHMM` (today's date and time)
- PR title: `Update YYYY-MM-DD`

# Update all dependencies

Update all dependencies from GitHub Actions, Dockerfile, and package.json

## Verify

- Ensure that the entire codebase uses the newer approaches and APIs from the updates.
- Ensure that the conductor.json scripts are updated and works.
- Run all tests and checks.

## Create PR

- Run `git diff` to review uncommitted changes
- Commit them
- Push to origin
- Use `git diff origin/main...` to review the PR diff
- Use `gh pr create --base main` with the Report Summary as the PR description

## Watch CI and fix failures\*\* (max 5 fix attempts)

- Watch for CI checks: `gh pr checks <pr-number> --watch 2>&1`
- If all checks pass: Present the Report Summary to the user
- If checks fail:
  - Fetch failed check logs: `gh run view <run-id> --log-failed`
  - Analyze the failure and fix the issue
  - Commit the fix with message: `Fix CI: <description>`
  - Push to the branch
  - Repeat from the top (watch CI again)
- If checks have failed 5 times: Stop and report "CI failed after 5 fix attempts. Manual intervention required."

## Report Summary

| Category       | Status                 |
| -------------- | ---------------------- |
| Dockerfile     | X updated              |
| GitHub Actions | X updated              |
| package.json   | X updated              |
| Verification   | passed / failed        |
| PR             | Merged / Failed checks |

Present this summary upon completion and update the PR description with it.
