# TestFlight Deployment Guide

This guide documents the complete process for deploying Multi Timer to Apple TestFlight for beta testing.

## Prerequisites

Before starting the TestFlight deployment process, ensure you have:

- Paid Apple Developer Program membership ($99/year)
- macOS with Xcode installed (version 14.0 or later recommended)
- App Store Connect access with your Apple Developer account
- Flutter project with all features complete and tested
- App icons prepared (including 1024x1024 for App Store)

## App Configuration

### Bundle Identifier

- **Bundle ID**: `systems.boos.multiTimer`
- **Registered in**: Apple Developer Portal

### App Store Connect

- **App Name**: "Multi Timer für Atempraxis"
- **Local Display Name**: "Multi Timer" (in Info.plist)
- **Primary Category**: Health & Fitness
- **Version**: 1.0.0+1

### App Icons

Complete icon set located in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Required sizes:
- 1024x1024 (App Store)
- All iOS app icon sizes as specified by Xcode

## Deployment Process

### Step 1: Create App Record in App Store Connect

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps**
3. Click the **+** button and select **New App**
4. Fill in the app information:
   - **Platform**: iOS
   - **Name**: Multi Timer für Atempraxis (or your preferred name)
   - **Primary Language**: German (or your preference)
   - **Bundle ID**: Select your registered bundle ID from dropdown
   - **SKU**: Enter a unique identifier (e.g., `multi-timer-001`)
5. Click **Create**

### Step 2: Set Up Distribution Certificate in Xcode

1. Open Xcode
2. Go to **Settings** (or **Preferences** in older Xcode versions)
3. Select **Accounts** tab
4. Ensure your Apple ID is added and signed in
5. Select your team/account
6. Click **Manage Certificates**
7. Verify **Apple Distribution** certificate exists
   - If not, click **+** and select **Apple Distribution**

### Step 3: Configure Xcode Project Signing

1. Navigate to your project's `ios` folder
2. Open `Runner.xcworkspace` (NOT `Runner.xcodeproj`)
3. In the left sidebar, select the **Runner** project (blue icon)
4. Select the **Runner** target in the main view
5. Go to **Signing & Capabilities** tab
6. Configure signing for all configurations:
   - Enable **Automatically manage signing**
   - Select your **Team** from the dropdown
   - Verify the **Bundle Identifier** matches your registered ID
7. Check both **Debug** and **Release** configurations
8. Ensure no signing errors appear

### Step 4: Build and Archive

This step requires running Flutter build before creating the Xcode archive.

#### 4.1: Run Flutter Build

**Important**: This step is critical for CocoaPods integration. Skipping it will cause archive failures.

```bash
cd /path/to/multi-timer
flutter build ios --release
```

This command:
- Builds the release version
- Generates necessary Flutter framework files
- Ensures CocoaPods dependencies are properly integrated

#### 4.2: Create Archive in Xcode

1. In Xcode (with `Runner.xcworkspace` open)
2. Select **Any iOS Device (arm64)** as the destination
   - Do NOT select a simulator
   - Do NOT select a physical device
3. Go to **Product** → **Archive**
4. Wait for the build to complete (may take several minutes)
5. The **Organizer** window opens automatically showing your archive

**Optional but Recommended**: Tag the source code version

```bash
git tag -a v1 -m "TestFlight build 1"
git push origin v1
```

This helps track which source code corresponds to which TestFlight build.

### Step 5: Upload Archive to TestFlight

#### 5.1: Distribute the Archive

1. In the **Organizer** window, select your archive
2. Click **Distribute App**
3. Select **App Store Connect** → **Next**
4. Select **Upload** → **Next**
5. Review distribution options:
   - **App Thinning**: All compatible device variants (recommended)
   - **Rebuild from Bitcode**: Yes (if available)
   - **Strip Swift symbols**: Yes
6. Click **Next**
7. Review signing configuration (should be automatic)
8. Click **Upload**

#### 5.2: Troubleshooting Upload Failures

If upload fails with validation errors about MinimumOSVersion, see the troubleshooting section below.

### Step 6: Wait for Apple Build Processing

1. After successful upload, go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps** → Your App → **TestFlight** tab
3. You'll see your build with status "Processing"
4. Processing typically takes 5-30 minutes
5. You'll receive an email when processing completes
6. Refresh the page to see status change to "Ready to Submit" or "Missing Compliance"

### Step 7: Export Compliance Information

If prompted for export compliance:

1. In TestFlight tab, click on your build
2. Answer the export compliance questions:
   - **Does your app use encryption?** No (for this app)
   - Follow the prompts based on your app's actual encryption use
3. Save the compliance information

### Step 8: Invite Beta Testers

#### 8.1: Add Internal Testers

1. In App Store Connect, go to **TestFlight** tab
2. Click **Internal Testing** in the left sidebar
3. Click the **+** next to **Testers**
4. Select or add testers (must have iTunes Connect access)
5. Select the build to test
6. Click **Add**

#### 8.2: Add External Testers

1. In TestFlight tab, click **External Testing** (if using external testers)
2. Create a new group or use default
3. Add testers by email address
4. Select the build
5. Submit for Beta App Review (required for external testing)

#### 8.3: Testers Install TestFlight

Testers will:
1. Receive an invitation email
2. Install the **TestFlight** app from App Store
3. Open the invitation link on their iOS device
4. Accept the invitation and install your app

## Troubleshooting

### Issue: CocoaPods Archive Failure

**Symptoms**: Archive creation in Xcode fails with CocoaPods-related errors

**Solution**: Run `flutter build ios --release` before archiving in Xcode

**Explanation**: Flutter needs to generate and integrate the iOS framework properly before Xcode can create an archive. The Flutter build command ensures CocoaPods dependencies are correctly set up.

### Issue: TestFlight Upload Validation Fails (MinimumOSVersion)

**Symptoms**: Upload fails with errors like:
- "Invalid MinimumOSVersion"
- "Missing Info.plist value for MinimumOSVersion key"
- "Invalid Bundle - doesn't support minimum OS Version"

**Root Cause**: Flutter's generated `AppFrameworkInfo.plist` is missing the `MinimumOSVersion` key required by Apple's validation.

**Solution**:

1. Open `ios/Flutter/AppFrameworkInfo.plist` in a text editor
2. Add the `MinimumOSVersion` key with value matching your deployment target:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>App</string>
  <key>CFBundleIdentifier</key>
  <string>io.flutter.flutter.app</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>App</string>
  <key>CFBundlePackageType</key>
  <string>FMWK</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>CFBundleVersion</key>
  <string>1.0</string>
  <key>MinimumOSVersion</key>
  <string>12.0</string>
</dict>
</plist>
```

3. The `MinimumOSVersion` value should match your `IPHONEOS_DEPLOYMENT_TARGET` in Xcode
4. To find your deployment target:
   - Open `Runner.xcworkspace` in Xcode
   - Select **Runner** project → **Runner** target
   - Go to **Build Settings** tab
   - Search for "iOS Deployment Target"
   - Use this value (e.g., `12.0`, `13.0`, etc.)
5. Save the file
6. Rebuild: `flutter build ios --release`
7. Create new archive in Xcode
8. Upload again

**Note**: This fix has been applied to the current Multi Timer project. The value must match your project's iOS deployment target setting in Xcode.

### Issue: Signing Errors in Xcode

**Symptoms**: Red errors about provisioning profiles or signing

**Solutions**:
- Ensure your Apple Developer account is active and paid
- Try disabling and re-enabling "Automatically manage signing"
- Clean build folder: **Product** → **Clean Build Folder**
- Restart Xcode

## Version Tracking

### Git Tags for Build Tracking

Use git tags to track which source code version corresponds to each TestFlight build:

```bash
# Create annotated tag for build version
git tag -a v1 -m "TestFlight build 1"

# Push tag to remote
git push origin v1

# List all tags
git tag -l
```

This allows you to:
- Quickly identify source code for any TestFlight build
- Roll back to specific versions if needed
- Track changes between builds

### Version Numbering

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
#        ^^^^^ ^
#        |     |
#        |     +-- Build number (increment for each TestFlight upload)
#        +-------- Version string (semantic versioning)
```

- Increment build number (+2, +3, etc.) for each new TestFlight upload
- Increment version (1.0.1, 1.1.0, etc.) for App Store releases

## Additional Resources

### App Store Assets

Located in `docs/appstore-submission-de-DE/`:

- `app-store-description.txt` - German app description for App Store listing
- `testflight-description.txt` - German testing instructions for beta testers

### Related Documentation

- Main project README: `../README.md`
- Architecture decisions: `../decisions/`

## Post-Deployment

After successful TestFlight deployment:

1. **Monitor tester feedback** through TestFlight Feedback in App Store Connect
2. **Track crash reports** in Xcode Organizer or App Store Connect
3. **Gather user feedback** directly from beta testers
4. **Iterate based on feedback** and upload new builds as needed
5. **Prepare for App Store release** when ready (separate process)

## Notes

- TestFlight builds expire after 90 days
- You can have up to 100 internal testers and 10,000 external testers
- External testing requires Beta App Review (1-2 days typically)
- Each build can be tested for up to 90 days after upload

