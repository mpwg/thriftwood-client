# Fastlane Configuration for Thriftwood iOS

This directory contains the Fastlane configuration for building and deploying the Thriftwood iOS app using App Store Connect API Keys for secure, automated builds.

## Prerequisites

- Xcode installed and configured
- Ruby with Bundler
- Access to the Apple Developer Portal
- App Store Connect API Key
- Access to the private certificates repository

## Quick Setup

Run the setup script to get started:

```bash
./setup_fastlane.sh
```

## Manual Setup

### 1. Install Dependencies

```bash
cd ThriftwoodNative
bundle install
```

### 2. Configure Environment Variables

Copy the example environment file and fill in your details:

```bash
cp .env.example .env
```

Edit `.env` with your actual values:

- `APPLE_ID`: Your Apple Developer account email
- `ITUNES_TEAM_ID`: Your App Store Connect Team ID
- `APPSTORE_TEAM_ID`: Your Developer Portal Team ID
- `APP_STORE_CONNECT_API_KEY_*`: Your API key configuration
- `MATCH_PASSWORD`: Password for your certificates repository

### 3. App Store Connect API Key Setup

1. Log into [App Store Connect](https://appstoreconnect.apple.com)
2. Go to Users and Access > Keys
3. Create a new API key with Admin or Developer access
4. Download the `.p8` file
5. Copy the entire content of the `.p8` file (including the BEGIN/END lines)
6. Update your `.env` file with the key details:
   - `APP_STORE_CONNECT_API_KEY_KEY_ID`: The key ID from App Store Connect
   - `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: Your issuer ID
   - `APP_STORE_CONNECT_API_KEY_CONTENT`: The full content of your `.p8` file

#### Example of setting the key content

```bash
APP_STORE_CONNECT_API_KEY_CONTENT="-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
...your key content here...
-----END PRIVATE KEY-----"
```

### 4. Find Your Team IDs

You can find your team IDs in:

- **App Store Connect Team ID**: App Store Connect > Membership
- **Developer Portal Team ID**: Developer Portal > Membership

Or use Spaceship to list them:

```bash
bundle exec fastlane spaceship
```

## Available Lanes

### Building

```bash
# Build the app for App Store/TestFlight
bundle exec fastlane ios build
```

### TestFlight Deployment

```bash
# Build and upload to TestFlight
bundle exec fastlane ios beta
```

### App Store Release

```bash
# Build and upload to App Store (does not submit for review)
bundle exec fastlane ios release
```

### Code Signing

```bash
# Sync certificates and provisioning profiles
bundle exec fastlane ios certificates
```

### Metadata and Screenshots

```bash
# Update app metadata only
bundle exec fastlane ios metadata

# Take screenshots
bundle exec fastlane ios screenshots
```

## Troubleshooting

### Common Issues

1. **"Could not find certificate"**
   - Run `bundle exec fastlane ios certificates` first
   - Ensure your `MATCH_PASSWORD` is correct

2. **"Invalid API Key"**
   - Verify your API key file path and permissions
   - Check that the key ID and issuer ID are correct

3. **"Team ID not found"**
   - Verify your team IDs in the `.env` file
   - Use `bundle exec fastlane spaceship` to list available teams

### Debugging

Add `--verbose` to any command for detailed output:

```bash
bundle exec fastlane ios build --verbose
```

## Security Notes

- Never commit the `.env` file or `.p8` API key files
- The `private_keys/` directory is gitignored for security
- API keys are more secure than passwords for CI/CD environments

## File Structure

```text
iosnative/
├── .env.example          # Template for environment variables
├── .env                  # Your actual environment variables (gitignored)
├── private_keys/         # Directory for API key files (gitignored)
├── setup_fastlane.sh     # Setup script
├── fastlane/
│   ├── Appfile          # App configuration
│   ├── Fastfile         # Lane definitions
│   └── Matchfile        # Code signing configuration
└── ThriftwoodNative/
    └── Gemfile          # Ruby dependencies
```