# Active Context

## Current Iteration Goal

**Publish Multi Timer to Apple TestFlight for beta testing**

Enable two beta testers (friends) to install and test the breathing exercise app on their iPhones.

## Current Focus

**TestFlight Submission - Guided Manual Process**

Executing a step-by-step guided submission to Apple TestFlight. The AI provides instructions one at a time for manual execution on Mac, with memory bank updates after each step to enable session resumption if interrupted.

### TestFlight Submission Steps

1. ✅ **Step 0**: Document plan in memory bank (COMPLETED)
2. ✅ **Step 1**: Create app record in App Store Connect (COMPLETED)
   - Registered bundle ID: systems.boos.multiTimer
   - Created app record with name: "Multi Timer für Atempraxis"
   - Primary Category: Health & Fitness
3. ✅ **Step 2**: Set up distribution certificate in Xcode (COMPLETED)
   - Apple Distribution certificate confirmed
4. ✅ **Step 3**: Configure Xcode project signing (COMPLETED)
   - Automatic signing enabled for all configurations
   - No signing errors
5. ✅ **Step 4**: Build and archive (COMPLETED)
   - Fixed CocoaPods integration with `flutter build ios --release`
   - Archive created successfully in Xcode
   - Organizer window open with archive ready
   - Git tag: v4 (tracks source code version)
6. ✅ **Step 5a**: First upload attempt - validation failure (COMPLETED)
   - Upload failed with 3 validation errors
   - Root cause: Missing MinimumOSVersion key in AppFrameworkInfo.plist
   - Fixed by adding MinimumOSVersion = 26.0 to match iOS 26.0 deployment target
   - Commit: 383610b (fix: TestFlight upload failed due to missing MinimumOSVersion)
7. ✅ **Step 5b**: Rebuild archive with fix (COMPLETED)
   - Rebuilt with corrected AppFrameworkInfo.plist
   - Created new archive in Xcode
8. ✅ **Step 6**: Upload archive to TestFlight (COMPLETED)
   - Upload successful! Archive accepted by Apple
9. ✅ **Step 7**: Wait for Apple build processing (COMPLETED)
   - Processing completed successfully
   - Build is now ready for testing
10. ✅ **Step 8**: Invite beta testers in App Store Connect (COMPLETED)
   - Beta testers invited successfully
   - Testers will receive TestFlight invitation emails

### Current iOS Configuration

- Bundle identifier: `systems.boos.multiTimer` (registered in Apple Developer portal)
- App Store Connect name: "Multi Timer für Atempraxis"
- Local display name: "Multi Timer" (in Info.plist)
- Version: 1.0.0+1
- App icons: Complete set including 1024x1024 for App Store
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Workflow Pattern

Each step follows this pattern:
1. AI provides specific instruction
2. User executes on Mac
3. User reports result
4. AI updates memory bank with progress
5. AI provides next instruction

### Session Continuity

If session is interrupted, user can say "follow your custom instructions" and AI will:
1. Read memory bank
2. Identify completed steps
3. Continue from next uncompleted step

## Recent Changes

The git history shows steady development of the core breathing timer functionality:

- Latest feature: Added "Nachspüren" (sensing/feeling) session to complete the 7-session sequence
- Recent fixes: Audio playback reliability improvements
- Progress indicator: Visual feedback during exercise sequence
- Audio integration: German-language exercise instructions play before each session
- Debug mode: Shortened timings (16-17 seconds) for rapid development testing

## Active Decisions

### Accepted for Beta

- Publishing with known screen lock limitation
- Documenting workaround for testers
- Using "Multi Timer" as official app name
- Small, focused beta group (2 testers)

### Pending Beta Feedback

- Whether to implement notifications-based timer fix (ADR-001)
- Future product direction (private vs. public release)
- Additional features or breathing programs
- Timing customization needs

## Important Patterns

### Debug vs. Release Mode

The app uses Flutter's `kDebugMode` to switch between:

- **Debug**: 16-17 second sessions for quick testing
- **Release**: Full duration (300-60-300-60-300-120-60 seconds = 20 minutes total)

This pattern allows rapid iteration without waiting through 20-minute sequences.

### Audio File Organization

```
assets/
  - gong.mp3 (session end marker)
  - release/
    - ganzkoerperatmung.mp3 (full body breathing, ~8s)
    - atem-halten.mp3 (breath holding, ~8.7s)
    - wellenatmen.mp3 (wave breathing, ~9s)
    - nachspueren.mp3 (sensing, ~5.6s)
  - debug/ (not currently used in code)
```

German-language recordings provide exercise instructions before each timed session.

### Session Timing Architecture

Each session duration accounts for:

1. Audio instruction duration (pre-session)
2. Silent practice time (bulk of session)
3. Gong sound duration (6080ms, end of session)

The code subtracts audio and gong durations from total session time to achieve precise timing.

## Next Immediate Step

**TestFlight Deployment Complete - Awaiting Beta Feedback**

All TestFlight setup steps are complete:
- ✅ Build uploaded and processed by Apple
- ✅ Beta testers invited (2 testers)
- ✅ TestFlight invitations sent

Next actions:
1. **Monitor Tester Responses**: Wait for beta testers to receive invitation emails and install TestFlight
2. **First Beta Test**: Testers install app and complete 20-minute breathing sequence
3. **Gather Feedback**: Collect user feedback on:
   - Overall experience with the breathing sequence
   - Audio instruction clarity and timing
   - Progress bar usefulness
   - Screen lock workaround burden
   - Any bugs or issues encountered
4. **Evaluate Next Steps**: Based on feedback, decide:
   - Whether to fix screen lock issue (ADR-001)
   - Whether to pursue public App Store release
   - What improvements/features to prioritize

## Blockers

None identified. Prerequisites met:

- ✅ Paid Apple Developer account
- ✅ macOS with Xcode available
- ✅ App functionally complete for beta
- ✅ Audio assets prepared

## Project Insights

### Lean Approach

The project follows lean principles:

- MVP focused on single use case
- Small beta group for fast feedback
- Accepted known limitation to ship faster
- Clear decision point based on real usage data

### Development in Sandbox

Development occurs in a Linux VM to protect the host Mac from AI agent operations. Changes sync to Mac for iOS building via rsync with filters for .git, .gitignore, and .rsyncignore files.

### Shamanic and Yoga Practice Context

This is not a general-purpose timer app. It serves a specific breathing exercise rooted in self-healing principles from shamanic and yoga traditions. The fixed sequence and German audio instructions are intentional and core to this practice.

