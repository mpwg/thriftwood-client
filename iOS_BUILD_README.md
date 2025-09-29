# Building LunaSea for iOS

This guide provides step-by-step instructions for building the LunaSea Flutter app for iOS devices.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher)
- **Xcode** (latest version recommended)
- **CocoaPods** (for iOS dependency management)
- **Dart SDK** (included with Flutter)

### System Requirements

- macOS (required for iOS development)
- iOS deployment target: 12.0+
- Xcode Command Line Tools

## Setup Instructions

### 1. Clone and Navigate to Project

```bash
git clone <repository-url>
cd lunasea
```

### 2. Install Flutter Dependencies

First, you need to resolve the Flutter dependencies. Due to version conflicts, specific versions are required:

```bash
flutter pub get
```

**Note**: If you encounter dependency conflicts, the following versions are known to work:

- `retrofit_generator: ^8.1.0`
- `json_serializable: ^6.8.0`

### 3. Generate Required Code

The project uses code generation for JSON serialization and environment configuration. Run these commands:

#### Generate JSON Serialization Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### Generate Environment Configuration

```bash
dart run environment_config:generate
```

This creates the required `lib/system/environment.dart` file.

### 4. Install iOS Dependencies

Navigate to the iOS directory and install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

**Expected Output**: Pod installation should complete successfully, though you may see warnings about iOS deployment targets.

### 5. Build the iOS App

Build the iOS app using Flutter:

```bash
flutter build ios --no-codesign
```

**Note**: The `--no-codesign` flag builds the app without code signing, which is suitable for development and testing.

## Build Output

Upon successful completion, you'll find:

- **Build Location**: `build/ios/iphoneos/Runner.app`
- **Typical Size**: ~27MB
- **Build Time**: 30-60 seconds (depending on your machine)

## Troubleshooting

### Common Issues and Solutions

#### 1. Dependency Version Conflicts

**Error**: Version solving failed due to conflicting dependencies

**Solution**: Update your `pubspec.yaml` with compatible versions:

```yaml
dev_dependencies:
  retrofit_generator: ^8.1.0
  json_serializable: ^6.8.0
```

#### 2. Missing Generated Files

**Error**: `Error when reading 'lib/system/environment.dart': No such file or directory`

**Solution**: Run the code generation commands:

```bash
dart run environment_config:generate
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Missing JSON Serialization Methods

**Error**: `The method '_$SomeClassFromJson' isn't defined`

**Solution**: Run the build runner:

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. CocoaPods Issues

**Error**: Pod installation fails

**Solution**:

```bash
cd ios
pod repo update
pod install
cd ..
```

#### 5. iOS Deployment Target Warnings

**Warning**: iOS deployment target version conflicts

**Note**: These warnings don't prevent successful builds. The app targets iOS 12.0+ which is compatible with modern devices.

## Code Signing and Distribution

### For Development/Testing

The build process uses `--no-codesign` which is perfect for:

- Development builds
- Simulator testing
- Internal testing

### For App Store Distribution

For production releases, you'll need to:

1. Set up proper code signing in Xcode
2. Configure your Apple Developer account
3. Build with code signing enabled:

   ```bash
   flutter build ios --release
   ```

## Project Configuration

### Key Configuration Files

- **`pubspec.yaml`**: Flutter dependencies and project metadata
- **`ios/Podfile`**: iOS native dependencies
- **`ios/Runner/Info.plist`**: iOS app configuration
- **`environment_config.yaml`**: Environment variable configuration

### Build Flavors

The app supports different build flavors:

- `edge` (development)
- `beta` (testing)
- `stable` (production)

Set the flavor using environment variables:

```bash
export FLAVOR=stable
flutter build ios --no-codesign
```

## Performance Notes

### Build Times

- **Clean Build**: 1-2 minutes
- **Incremental Build**: 30-60 seconds
- **Code Generation**: 30-40 seconds

### Optimization Tips

1. Use `flutter build ios --release` for production builds
2. Enable build caching for faster subsequent builds
3. Close unnecessary applications during build to free up system resources

## Continuous Integration

For automated builds in CI/CD pipelines:

```bash
# Install dependencies
flutter pub get

# Generate required code
dart run environment_config:generate
dart run build_runner build --delete-conflicting-outputs

# Install iOS dependencies
cd ios && pod install && cd ..

# Build
flutter build ios --no-codesign --release
```

## Additional Resources

- [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- [CocoaPods Installation](https://cocoapods.org/)
- [Xcode Documentation](https://developer.apple.com/xcode/)

## Support

If you encounter issues not covered in this guide:

1. Check the Flutter doctor: `flutter doctor -v`
2. Verify Xcode installation: `xcode-select --print-path`
3. Ensure CocoaPods is properly installed: `pod --version`
4. Review the full build logs for specific error messages

---

**Last Updated**: September 2025  
**Flutter Version**: 3.0.0+  
**iOS Target**: 12.0+
