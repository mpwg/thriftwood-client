# Branching & Deployment Strategy

This document describes the Git branching strategy and CI/CD deployment flow for the Thriftwood Client project.

## 🌳 Branch Structure

### Main Branches

#### `main`
- **Purpose**: Production-ready code
- **Protection**: Protected branch, requires PR reviews
- **Merge Strategy**: Squash and merge from `develop`
- **Automatic Actions**:
  - ✅ Build validation (`fastlane build`)
  - ✅ TestFlight deployment (`fastlane beta`)
  - ✅ Increment build number automatically
  - ✅ Upload artifacts (90-day retention)

#### `develop` 
- **Purpose**: Integration branch for new features
- **Protection**: Protected branch, requires PR reviews
- **Merge Strategy**: Merge commits from feature branches
- **Automatic Actions**:
  - ✅ Build validation (`fastlane build`)
  - ✅ Development build (`fastlane dev`)
  - ✅ Upload development artifacts (7-day retention)

### Supporting Branches

#### `feature/*`
- **Purpose**: Individual feature development
- **Naming**: `feature/feature-name` or `feature/JIRA-123`
- **Lifetime**: Created from `develop`, merged back to `develop`
- **Automatic Actions** (via PR only):
  - ✅ Build validation (`fastlane build`)
  - ❌ No deployment or artifacts

#### `hotfix/*`
- **Purpose**: Critical production fixes
- **Naming**: `hotfix/fix-description` or `hotfix/v1.2.1`
- **Lifetime**: Created from `main`, merged to both `main` and `develop`
- **Automatic Actions** (via PR only):
  - ✅ Build validation (`fastlane build`)
  - ❌ No deployment (requires manual tag creation)

#### `release/*`
- **Purpose**: Release preparation and stabilization
- **Naming**: `release/v1.2.0`
- **Lifetime**: Created from `develop`, merged to `main`
- **Automatic Actions** (via PR only):
  - ✅ Build validation (`fastlane build`)
  - ❌ No deployment (deploy after merge to `main`)

## 🏷️ Tag Strategy

### Version Tags

#### Format: `v{major}.{minor}.{patch}`
- **Examples**: `v1.0.0`, `v1.2.3`, `v2.0.0`
- **Creation**: Manual, from `main` branch only
- **Automatic Actions**:
  - ✅ Build validation (`fastlane build`)
  - ✅ App Store deployment (`fastlane release`)
  - ✅ Increment version number automatically
  - ✅ Increment build number automatically
  - ✅ Create Git tag with new version
  - ✅ Create GitHub release
  - ✅ Upload App Store artifacts (365-day retention)

#### Pre-release Tags: `v{major}.{minor}.{patch}-{prerelease}`
- **Examples**: `v2.0.0-alpha.1`, `v2.0.0-beta.1`, `v1.3.0-rc.1`
- **Creation**: Manual, typically from `develop` or `release/*`
- **Automatic Actions**: Same as version tags

### Creating Version Tags

```bash
# 1. Ensure you're on main branch
git checkout main
git pull origin main

# 2. Create and push version tag
git tag v1.2.3
git push origin v1.2.3

# 3. Or create annotated tag with changelog
git tag -a v1.2.3 -m "Release v1.2.3

- Fixed authentication bug
- Improved dashboard performance
- Updated localization for Spanish"

git push origin v1.2.3
```

## 🚀 CI/CD Workflow Matrix

| Trigger | Branch/Tag | Build Validation | Development Build | TestFlight | App Store | Artifacts |
|---------|------------|-----------------|-------------------|------------|-----------|-----------|
| **PR → develop** | `feature/*` | ✅ | ❌ | ❌ | ❌ | ❌ |
| **PR → main** | `develop`, `release/*`, `hotfix/*` | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Push → develop** | `develop` | ✅ | ✅ | ❌ | ❌ | ✅ (7 days) |
| **Push → main** | `main` | ✅ | ❌ | ✅ | ❌ | ✅ (90 days) |
| **Tag creation** | `v*` | ✅ | ❌ | ❌ | ✅ | ✅ (365 days) |
| **Manual: Beta** | Any branch | ✅ | ❌ | ✅ | ❌ | ✅ (90 days) |
| **Manual: Production** | Any branch | ✅ | ❌ | ❌ | ✅ | ✅ (365 days) |

## 🔄 Development Workflow

### Feature Development
```bash
# 1. Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/new-dashboard

# 2. Develop and commit changes
git add .
git commit -m "Add new dashboard component"
git push origin feature/new-dashboard

# 3. Create PR to develop
# → Triggers: Build validation only

# 4. After PR approval and merge
# → Triggers: Build validation + Development build + Artifacts
```

### Release Process
```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Finalize release (update version, changelog, etc.)
git add .
git commit -m "Prepare release v1.2.0"
git push origin release/v1.2.0

# 3. Create PR to main
# → Triggers: Build validation only

# 4. After PR approval and merge to main
# → Triggers: Build validation + TestFlight deployment

# 5. Create version tag from main
git checkout main
git pull origin main
git tag v1.2.0
git push origin v1.2.0
# → Triggers: Build validation + App Store deployment

# 6. Merge release branch back to develop
git checkout develop
git merge release/v1.2.0
git push origin develop
git branch -d release/v1.2.0
```

### Hotfix Process
```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-auth-fix

# 2. Fix the issue
git add .
git commit -m "Fix critical authentication bug"
git push origin hotfix/critical-auth-fix

# 3. Create PR to main
# → Triggers: Build validation only

# 4. After PR approval and merge to main
# → Triggers: Build validation + TestFlight deployment

# 5. Create hotfix version tag
git checkout main
git pull origin main
git tag v1.2.1
git push origin v1.2.1
# → Triggers: Build validation + App Store deployment

# 6. Merge hotfix back to develop
git checkout develop
git merge hotfix/critical-auth-fix
git push origin develop
git branch -d hotfix/critical-auth-fix
```

## 🎯 Manual Deployments

### TestFlight (Beta) Deployment
- **When**: Testing new features before App Store release
- **How**: GitHub Actions → "Run workflow" → Choose "beta"
- **From**: Any branch (typically `main` or `release/*`)
- **Result**: App uploaded to TestFlight for internal/external testing

### App Store (Production) Deployment
- **When**: Ready for public release (should use version tags instead)
- **How**: GitHub Actions → "Run workflow" → Choose "production"  
- **From**: Any branch (but should be `main` with proper testing)
- **Result**: App uploaded to App Store (requires manual submission)

## ⚠️ Important Notes

### Branch Protection Rules
- **main**: Require PR reviews, require status checks, restrict pushes
- **develop**: Require PR reviews, require status checks
- **feature/**: No restrictions (delete after merge)

### Version Management
- **Build numbers**: Auto-incremented by Fastlane based on TestFlight
- **Version numbers**: Auto-incremented by `fastlane release` (patch level)
- **Manual version bumps**: Use Fastlane actions or Xcode project settings

### Artifact Retention
- **Development builds**: 7 days (frequent builds, short-term testing)
- **TestFlight builds**: 90 days (beta testing period)
- **App Store builds**: 365 days (production releases, audit trail)

### Emergency Procedures
- **Critical hotfix**: Use hotfix branch → main → create tag immediately
- **Rollback**: Create new hotfix with revert, do not delete tags
- **Failed deployment**: Check Fastlane logs, verify certificates, retry manually