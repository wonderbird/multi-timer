# Project Brief: Multi Timer

## Overview

Multi Timer is a Flutter mobile application designed to guide users through a specific breathing exercise sequence for personal well-being and self-exploration, rooted in shamanic and yoga traditions.

## Core Requirements

### Functional Requirements

1. Simple single-button interface to start the breathing exercise sequence
2. Execute a fixed 7-session sequence with timed intervals:
   - Session 1: 5 minutes (Ganzkörperatmung - full body breathing)
   - Session 2: 1 minute (Atem halten - breath holding)
   - Session 3: 5 minutes (Ganzkörperatmung)
   - Session 4: 1 minute (Atem halten)
   - Session 5: 5 minutes (Ganzkörperatmung)
   - Session 6: 2 minutes (Wellenatmen - wave breathing)
   - Session 7: 1 minute (Nachspüren - sensing/feeling after)
3. Play German-language audio instructions before each session
4. Play gong sound at the end of each session
5. Display visual progress indicator during the sequence
6. Black screen during exercise to minimize distractions
7. Debug mode with shortened timings for development/testing

### Non-Functional Requirements

1. Cross-platform: iOS and Android support
2. Minimal, distraction-free user interface
3. Reliable audio playback
4. Battery-efficient operation

## Current Limitations

1. **Known Issue**: Timer stops when device screen locks (documented in ADR-001)
   - Impact: Users must disable auto-lock in Settings before practice, then re-enable after
   - **Security Risk**: Users may forget to re-enable auto-lock, leaving device unprotected
   - Status: ~~Accepted for initial beta~~ **Being fixed in version 1.1.0** based on beta feedback
   - Solution: Notification-based timing approach (implementation plan defined)

## Success Criteria

### Initial Beta (v1.0.0) ✅

1. ✅ App successfully deploys to Apple TestFlight
2. ✅ Two beta testers (friends) can install and use the app
3. ✅ Complete 20-minute breathing exercise sequence executes correctly with screen unlocked
4. ✅ Audio instructions and gongs play at appropriate times
5. ✅ Gather initial user feedback to inform next iteration
6. ⏳ Continue gathering user feedback for future development decisions

### Next Release (v1.1.0) ⏳

1. ⏳ Complete 20-minute sequence executes correctly **with screen locked**
2. ⏳ Automatic display sleep mode works during exercise
3. ⏳ Beta testers confirm screen lock fix meets their needs
4. ⏳ No regression in audio quality or timing accuracy

## Target Audience

- Primary: Friends (initial beta testers)
- Future: To be determined based on beta feedback

## Scope Boundaries

### In Scope (Current Iteration - v1.1.0)

- **Fix screen lock timer issue** (notification-based approach)
- iOS TestFlight deployment
- Current breathing exercise sequence
- Existing audio recordings
- Enhanced timer functionality with background support

### Out of Scope (for current iteration)

- Android deployment
- Customizable timer sequences
- Multiple breathing exercise programs
- User accounts or data persistence
- Analytics or usage tracking
- Public App Store release

## Product Vision

The long-term vision for Multi Timer is undecided and will be informed by initial beta testing feedback. Options include:

- Keeping as private/personal tool
- Publishing to App Store for broader audience
- Adding additional breathing exercise programs
- Remaining focused on this single specific technique

