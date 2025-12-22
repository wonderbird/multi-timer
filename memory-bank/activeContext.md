# Active Context

## Current Iteration Goal

**Publish Multi Timer to Apple TestFlight for beta testing**

Enable two beta testers (friends) to install and test the breathing exercise app on their iPhones.

## Current Focus

Preparing the app for first-time TestFlight deployment including:

1. App Store Connect setup (first time)
2. iOS project configuration for release
3. App icon and metadata preparation
4. Build and archive creation
5. Upload to TestFlight
6. Beta tester invitation

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

## Next Immediate Steps

1. Verify Xcode project configuration
2. Update bundle identifier for App Store distribution
3. Configure code signing with distribution certificate
4. Create app icon set if not complete
5. Create app record in App Store Connect
6. Build and archive in Xcode
7. Upload to TestFlight
8. Add beta testers
9. Document screen lock workaround for testers

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

