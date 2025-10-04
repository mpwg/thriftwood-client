# Dependabot Configuration

Thriftwood uses [Dependabot](https://docs.github.com/en/code-security/dependabot) to automatically monitor and update dependencies, helping keep the project secure and up-to-date.

## Monitored Dependencies

### Swift Package Manager (SPM)

- **Location**: Xcode project dependencies
- **Packages**: Swinject, and other Swift packages added via Xcode
- **Schedule**: Weekly on Mondays at 9:00 AM EST
- **PR Limit**: Up to 5 open PRs at a time
- **Grouping**: Minor and patch updates are grouped together to reduce PR noise

### GitHub Actions

- **Location**: `.github/workflows/`
- **Actions Monitored**:
  - `actions/checkout`
  - `actions/cache`
  - `actions/upload-artifact`
  - `maxim-lobanov/setup-xcode`
- **Schedule**: Weekly on Mondays at 9:00 AM EST
- **PR Limit**: Up to 5 open PRs at a time
- **Grouping**: All GitHub Actions updates are grouped together

## How It Works

1. **Automatic Checks**: Dependabot runs weekly to check for updates
2. **Pull Requests**: Creates PRs for outdated dependencies
3. **Labels**: Automatically labels PRs with `dependencies` and ecosystem-specific labels
4. **Reviewers**: Assigns `@mpwg` as reviewer
5. **Commit Messages**: Uses conventional commit format (`chore(deps): ...`)
6. **CI Integration**: All PRs trigger the CI pipeline for validation

## Handling Dependabot PRs

### Review Process

1. **Check the PR**: Review the changelog and breaking changes
2. **Review CI Results**: Ensure all CI checks pass
3. **Test Locally** (for major updates):
   ```bash
   gh pr checkout <PR-NUMBER>
   xcodebuild build -project Thriftwood.xcodeproj -scheme Thriftwood
   xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood
   ```
4. **Merge**: Approve and merge if everything looks good

### Auto-Merge (Optional)

For minor and patch updates that pass CI, you can enable auto-merge:

```bash
gh pr merge <PR-NUMBER> --auto --squash
```

## Configuration

The Dependabot configuration is located at `.github/dependabot.yml`.

### Key Settings

- **Update Schedule**: Weekly (Mondays at 9:00 AM EST)
- **Open PR Limit**: 5 per ecosystem
- **Grouping Strategy**: 
  - Swift: Minor and patch updates grouped
  - GitHub Actions: All updates grouped
- **Labels**: Automatic labeling for easy filtering
- **Reviewers**: Auto-assign maintainers

## Security Updates

Dependabot also monitors for security vulnerabilities and creates pull requests immediately (not waiting for the weekly schedule) when security issues are detected.

## Disabling Updates (Temporarily)

To temporarily pause Dependabot updates:

1. Go to repository **Settings** → **Security & analysis**
2. Find **Dependabot version updates**
3. Click **Disable**

To re-enable, click **Enable** in the same location.

## Customizing Configuration

To modify the configuration:

1. Edit `.github/dependabot.yml`
2. Commit and push changes
3. Dependabot will use the new configuration on the next scheduled run

## Additional Resources

- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [Configuration Options](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)
- [Swift Ecosystem Support](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem)
