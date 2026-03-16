# ADR 002: Testing Strategy for Notification-Based Timer Redesign

## Status

Accepted

## Context

The app is replacing `Future.delayed()` with OS-native scheduled
notifications to fix the screen-lock timer failure (ADR-001).
This is a risky architectural change affecting core timing, audio
delivery, UI state, and notification handling.

There are no automated tests in the codebase. The redesign
creates a need for a safety net before and during the change.

**Key constraint:** Automated tests cannot verify locked-screen
notification delivery — the primary feature. This is a
fundamental platform limitation; test frameworks cannot
programmatically lock the device screen.

## Decision Drivers

1. **Safety net during redesign** — catch regressions in timing,
   audio, UI, and session sequence
2. **Fast feedback loop** — tests must run quickly during
   development (< 1 minute for unit and widget tests)
3. **Regression detection** — verify notification scheduling
   logic even if locked-screen delivery requires manual testing
4. **Maintainability** — sustainable for a solo developer
5. **Development environment** — primary development happens in
   a Linux VM without a device or simulator attached

## Considered Options

| Option | Safety Net | Fast Feedback | Regression | Maintainability | Total |
|--------|-----------|---------------|------------|-----------------|-------|
| **1. Unit Tests Only** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | 13/20 |
| **2. Widget Tests Only** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | 14/20 |
| **3. Integration Tests** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 15/20 |
| **4. Three-Layer Approach** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 17/20 |

### Option 1: Unit Tests Only

Test timing calculations and session scheduling in isolation
with mocked dependencies. Fast and deterministic but misses
real timing issues, audio race conditions, and UI behaviour.

### Option 2: Widget Tests Only

Test UI state transitions with Flutter's `WidgetTester` and
mocked audio. Catches UI regressions but cannot verify timing
logic or notification scheduling correctness.

### Option 3: Integration Tests with Debug Timing

Run full app end-to-end on a real device or simulator using
debug-mode timing (~2 minutes). Tests real audio playback and
can inspect scheduled notifications via the plugin API.
Requires a device or simulator; not available in the Linux VM
development environment.

### Option 4: Three-Layer Approach (chosen)

Combine unit tests, widget tests, and a manual test protocol:

- **Unit tests** — timing arithmetic and notification schedule
  calculation; runs in milliseconds
- **Widget tests** — UI state transitions with mocked audio and
  controlled time; runs in seconds
- **Manual protocol** — screen lock and background execution on
  real devices; required regardless of automation level

## Decision

**Option 4: Three-Layer Approach.**

This is a focused variant of a traditional test pyramid that
replaces automated integration tests with a manual protocol.
Reasons for this choice:

- Integration tests require a device or simulator. The primary
  development environment is a Linux VM where neither is
  available.
- Extracting timing logic into `TimerSchedule` makes
  notification scheduling testable as pure unit tests — the
  same `buildEvents()` output that generates `PlaybackEvent`
  offsets also verifies notification fire times (300 s, 360 s,
  660 s, 720 s, 1020 s, 1140 s, 1200 s from ADR-001).
- The critical locked-screen path cannot be automated regardless
  of which automated testing approach is chosen.

See `docs/architecture/concepts/test-strategy.md` for
implementation details: required refactoring, tool choices,
example tests, and the manual test protocol.

## Testability Gap

Automated tests can verify:

- Notification scheduling (correct times, sounds, count)
- Timing arithmetic and session sequencing
- UI state transitions and regression detection
- Existing functionality preservation (audio, progress bar)

Automated tests **cannot** verify:

- Notifications firing when the device screen is locked
- iOS/Android OS power-management behaviour
- Manufacturer-specific battery management (Samsung, Xiaomi, …)

Manual testing on real devices remains mandatory before every
release.

## Consequences

### Positive

- Fast feedback during development: unit and widget tests run
  in seconds, not minutes
- `TimerSchedule` extraction creates a reusable module for both
  testing and notification schedule calculation
- Manual protocol catches the one thing automated tests cannot
- Low maintenance burden for a solo developer
- No device or simulator required to run the automated tests

### Negative

- Manual protocol requires discipline before each release
- No CI-based regression detection for background execution
- Requires refactoring before tests can be written:
  `TimerSchedule` extraction and `AudioPlayer` injection (see
  test-strategy.md)

## Related Decisions

- **ADR-001: Background Timer Reliability with Screen Lock** —
  documents the architectural change this testing strategy
  supports
