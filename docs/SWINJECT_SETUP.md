# Adding Swinject to Thriftwood

## Manual Setup (Required First Time)

Since we're using an Xcode project (not SPM), Swinject must be added via Xcode:

1. Open `Thriftwood.xcodeproj` in Xcode
2. Select the project in the navigator
3. Select the "Thriftwood" target
4. Go to "General" tab → "Frameworks, Libraries, and Embedded Content"
5. Click "+" button
6. Click "Add Package Dependency..."
7. Enter the URL: `https://github.com/Swinject/Swinject.git`
8. Select version: Up to Next Major (4.0.0)
9. Click "Add Package"
10. Select "Swinject" library
11. Click "Add Package"

## Verification

After adding, verify the package is listed in:

- Project Navigator → Package Dependencies → Swinject
- Target → General → Frameworks section shows Swinject

## Usage

Import Swinject in files that need dependency injection:

```swift
import Swinject
```

## Documentation

- [Swinject GitHub](https://github.com/Swinject/Swinject)
- [Swinject Documentation](https://github.com/Swinject/Swinject/tree/master/Documentation)
- [Basic Usage Guide](https://github.com/Swinject/Swinject/blob/master/Documentation/DIContainer.md)
