---
description: "Git workflow and branching strategy for Thriftwood development"
applyTo: "**"
---

# Git Workflow Instructions

## Branching Strategy

### ⚠️ CRITICAL RULE: Never Commit Directly to Main

**ALL changes MUST go through Pull Requests.**

- ❌ **NEVER** commit directly to the `main` branch
- ❌ **NEVER** push directly to `origin/main`
- ✅ **ALWAYS** create a feature branch
- ✅ **ALWAYS** create a Pull Request for review
- ✅ **ALWAYS** merge via PR (never fast-forward merge directly)

### Branch Naming Convention

Use descriptive branch names that reference the task or issue:

```bash
# Format: feature/<task-id>-<brief-description>
feature/M2-T4.1-radarr-openapi-spec
feature/Task-3.4--Main-App-Structure

# For bug fixes:
fix/<issue-number>-<brief-description>
fix/142-navigation-crash

# For documentation:
docs/<topic>
docs/api-documentation
```

### Standard Workflow

1. **Create Feature Branch**

   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/M2-T4.1-radarr-openapi
   ```

2. **Make Changes and Commit**

   ```bash
   # Make your changes
   git add <files>
   git commit -m "feat(scope): description"
   ```

3. **Push to Remote**

   ```bash
   git push origin feature/M2-T4.1-radarr-openapi
   ```

4. **Create Pull Request**

   - Use GitHub CLI: `gh pr create --base main --head feature/M2-T4.1-radarr-openapi`
   - Or use GitHub web interface
   - Fill in PR template with description and testing details

5. **After PR Approval and Merge**
   ```bash
   git checkout main
   git pull origin main
   git branch -d feature/M2-T4.1-radarr-openapi  # Delete local branch
   ```

## Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes

### Examples

```bash
feat(openapi): add Radarr v3 OpenAPI specification

- Download and convert Radarr v3 API spec from official GitHub repo
- Save as openapi/radarr-v3.yaml (OpenAPI 3.0.4, 8,504 lines)
- Create openapi-generator-config.yaml for Swift OpenAPI Generator

Closes #133
```

```bash
fix(navigation): resolve coordinator memory leak

- Fix retain cycle in TabCoordinator
- Add weak references to child coordinators
- Update coordinator lifecycle management

Fixes #142
```

## Pull Request Guidelines

### PR Title Format

Use the same format as commit messages:

```
[M2-T4.1] Add Radarr v3 OpenAPI Specification
[BUG] Fix navigation coordinator memory leak
[DOCS] Update architecture decision records
```

### PR Description Template

```markdown
## Summary

Brief description of what this PR does

## Changes

- List of specific changes
- Grouped by category if needed

## Testing

- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] No SwiftLint errors

## References

- Issue: #<number>
- ADR: (if applicable)
- Related PRs: (if applicable)
```

### PR Review Process

1. **Self-Review**: Review your own PR before requesting review
2. **Tests**: All tests must pass (CI will verify)
3. **Linting**: No SwiftLint errors allowed
4. **Documentation**: Update docs if needed
5. **Merge**: Only merge after approval and passing CI

## Protected Branches

### Main Branch Protection

The `main` branch is protected and requires:

- ✅ Pull request before merging
- ✅ At least 1 approval (for team projects; solo can self-approve after review)
- ✅ Status checks must pass (CI/CD)
- ✅ Branch must be up to date before merging

### Why These Rules?

1. **Code Quality**: PRs enable code review and discussion
2. **CI Validation**: Automated tests catch issues before merge
3. **Documentation**: PR descriptions document WHY changes were made
4. **History**: Clean git history with meaningful PR merge commits
5. **Rollback**: Easy to revert entire features via PR revert
6. **Collaboration**: Clear communication about what's being changed

## Emergency Hotfixes

Even for critical bugs, follow the PR process:

```bash
# Create hotfix branch
git checkout -b hotfix/critical-crash
# Fix the issue
git commit -m "fix(critical): resolve app crash on launch"
git push origin hotfix/critical-crash
# Create PR with [HOTFIX] tag
gh pr create --title "[HOTFIX] Fix critical app crash" --base main
# Merge after quick review (can be expedited)
```

## Git Commands Reference

### Undo Accidental Commit to Main

If you accidentally commit to `main` (DON'T!), here's how to fix it:

```bash
# 1. Create a feature branch with the changes
git branch feature/my-feature

# 2. Reset main to before your commit
git reset --hard HEAD~1

# 3. Switch to feature branch
git checkout feature/my-feature

# 4. Push both branches
git push origin feature/my-feature
git push origin main --force-with-lease  # Only if you pushed main by mistake
```

**Note**: Use `--force-with-lease` instead of `--force` for safety.

## Best Practices

### Do

- ✅ Keep feature branches small and focused
- ✅ Rebase on main before creating PR if behind
- ✅ Write descriptive commit messages
- ✅ Reference issues in commits and PRs
- ✅ Delete merged branches
- ✅ Keep commits atomic (one logical change per commit)

### Don't

- ❌ Commit directly to main
- ❌ Force push to shared branches (except your own feature branches)
- ❌ Create giant PRs with unrelated changes
- ❌ Commit commented-out code or debug logs
- ❌ Ignore CI failures
- ❌ Skip writing tests

## GitHub CLI Commands

Quick reference for common operations:

```bash
# Create PR
gh pr create --base main --head feature/my-branch

# View PR status
gh pr status

# List PRs
gh pr list

# Checkout PR locally
gh pr checkout <number>

# Merge PR (after approval)
gh pr merge <number> --squash  # or --merge or --rebase

# View PR in browser
gh pr view <number> --web
```

## Continuous Integration

All PRs must pass CI checks:

- ✅ Swift build succeeds
- ✅ All unit tests pass
- ✅ SwiftLint passes with no errors
- ✅ License headers present in all Swift files

See `.github/workflows/ci.yml` for CI configuration.

## Related Documentation

- `.github/instructions/conventional-commit.instructions.md` - Commit message format
- `.github/CI_README.md` - CI/CD pipeline documentation
- `.github/PULL_REQUEST_TEMPLATE.md` - PR template (create if needed)

---

**Remember**: Quality over speed. Taking time to follow proper git workflow ensures maintainable, reviewable, and reliable code.
