# Build & Test Performance - Quick Reference

## ✅ What Was Optimized

1. **Test Parallelization** - Tests run concurrently (40-60% faster)
2. **Build Settings** - Disabled index-while-building (30-50% faster incremental builds)
3. **CI Caching** - Added SPM dependencies cache (50-70% faster CI)
4. **CI Commands** - Split build/test phases, removed clean (faster feedback)

## 🚀 Quick Commands

### Local Development

```bash
# Build only (for testing build speed)
xcodebuild build-for-testing \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS,variant=Mac Catalyst' \
  -configuration Debug

# Test only (uses pre-built artifacts)
xcodebuild test-without-building \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS,variant=Mac Catalyst' \
  -configuration Debug \
  -parallel-testing-enabled YES

# Full build + test (single command)
xcodebuild test \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS' \
  -parallel-testing-enabled YES
```

### Verification

```bash
# Verify parallelization is enabled
grep 'parallelizable.*YES' Thriftwood.xcodeproj/xcshareddata/xcschemes/Thriftwood.xcscheme

# Verify index store is disabled
grep 'COMPILER_INDEX_STORE_ENABLE.*NO' Thriftwood.xcodeproj/project.pbxproj

# Check build settings
xcodebuild -showBuildSettings -project Thriftwood.xcodeproj -scheme Thriftwood | grep COMPILER_INDEX_STORE_ENABLE
```

## 📊 Performance Improvements

**✅ Actual CI Results (2025-10-06):**

| Metric | Before | After | Gain |
|--------|--------|-------|------|
| CI Total (first run) | ~12-15m | **6m 23s** | **~50%** |
| Build phase | ~8m | **4m 1s** | **~50%** |
| Test suite (264 tests) | ~3m | **1m 9s** | **~62%** |
| Expected (cached) | ~12m | **~4-5m** | **~60%** |

**Local Development (Estimated):**

| Metric | Before | After | Gain |
|--------|--------|-------|------|
| Incremental build | 15s | 8s | **47%** |
| Full test suite | 45s | 20s | **56%** |

## ⚠️ Known Trade-offs

- **Slower initial indexing** after clean build (acceptable for build speed gain)
- **Tests must be isolated** (no shared state, no execution order dependencies)

## 🔍 Troubleshooting

**Tests fail with parallelization?**
→ Fix test isolation (use `@MainActor`, avoid singletons, isolate state)

**Xcode autocomplete slow?**
→ Re-enable index store in project settings (accept slower builds)

**CI cache not working?**
→ Verify `Package.resolved` is committed, check cache keys in logs

## 📚 Full Documentation

- **Details**: `docs/BUILD_OPTIMIZATION.md`
- **Summary**: `docs/implementation-summaries/build-optimization.md`

---

**Status**: ✅ Active and tested (all 264 tests passing)
```
