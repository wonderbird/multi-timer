# Project Brief: Multi Timer

## Overview

Multi Timer is a Flutter mobile application designed to guide users through a specific breathing exercise sequence aimed at resolving psychological armors developed in early life stages.

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
   - Impact: Users must keep screen on during 20-minute sequence
   - Status: Accepted for initial beta release; will gather feedback before implementing fix

## Success Criteria

1. ✅ App successfully deploys to Apple TestFlight
2. ⏳ Two beta testers (friends) can install and use the app
3. ⏳ Complete 20-minute breathing exercise sequence executes correctly with screen unlocked
4. ⏳ Audio instructions and gongs play at appropriate times
5. ⏳ Gather user feedback to inform future development decisions

## Target Audience

- Primary: Friends (initial beta testers)
- Future: To be determined based on beta feedback

## Scope Boundaries

### In Scope

- iOS TestFlight deployment
- Current breathing exercise sequence
- Existing audio recordings
- Basic timer and audio playback functionality

### Out of Scope (for current iteration)

- Android deployment
- Fixing screen lock timer issue
- Customizable timer sequences
- Multiple breathing exercise programs
- User accounts or data persistence
- Analytics or usage tracking

## Product Vision

The long-term vision for Multi Timer is undecided and will be informed by initial beta testing feedback. Options include:

- Keeping as private/personal tool
- Publishing to App Store for broader audience
- Adding additional breathing exercise programs
- Remaining focused on this single specific technique

