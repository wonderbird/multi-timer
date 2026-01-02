# ADR 002: Testing Strategy for Notification-Based Timer Implementation

## Status

Proposed

## Context

The app is undergoing a significant architectural change to fix the screen lock issue (as documented in ADR-001). The current implementation uses `Future.delayed()` for timing, which will be replaced with OS-native scheduled notifications. This is a risky refactoring that could break core functionality:

### Current Implementation

- Sequential async execution using `Future.delayed()`
- In-app audio playback for both instructions and gong sounds
- Progress bar updates every 500ms via periodic timer
- 7-session sequence with precise timing
- Debug mode (2 minutes) and release mode (20 minutes)

### Upcoming Changes

- Replace `Future.delayed()` with notification scheduling
- Gong sounds delivered via notification system (at minimum)
- App must handle background/foreground transitions
- Notification permissions required
- State restoration when returning from background
- Notification cancellation management

### Key Risks

1. **Timing accuracy**: Notifications might fire at wrong times
2. **Audio delivery**: Gong sounds might not play via notifications
3. **Session sequence**: Sessions might execute out of order
4. **Progress bar**: UI might crash when returning from background
5. **Permission handling**: App might crash if permissions denied
6. **Edge cases**: Multiple notification sets, early cancellation, rapid restarts

### Testing Challenge

There is a fundamental testability gap: automated tests cannot verify that notifications fire correctly when the device screen is locked, which is the primary feature being implemented. However, automated tests can verify notification scheduling, timing calculations, and that existing functionality doesn't break.

## Decision Drivers

1. **Safety Net During Refactoring**: Need confidence that existing functionality won't break during significant internal changes
2. **Fast Feedback Loop**: Tests must run quickly enough to use during development (< 1 minute for most tests)
3. **Regression Detection**: Must catch breaking changes to timing, audio, UI, and session sequence
4. **Platform Integration Coverage**: Must verify notification scheduling even if locked-screen delivery requires manual testing
5. **Maintainability**: Testing approach must be sustainable for a small team/solo developer

## Considered Options

### Option 1: Pure Unit Tests with Mocked Time

Extract business logic into testable functions and mock all dependencies (time, audio player, notifications).

#### Positive Consequences

- Extremely fast (< 1 second per test)
- Deterministic and reliable
- Easy to test edge cases
- No platform dependencies

#### Negative Consequences

- Requires significant refactoring to make code testable
- Won't catch real timing issues
- Won't catch audio playback race conditions
- Won't catch platform integration bugs
- Won't catch notification scheduling bugs
- Tests might pass while real app is broken

### Option 2: Widget Tests with Time Control

Use Flutter's `WidgetTester` with `binding.pump()` to fast-forward time and test UI state changes.

#### Positive Consequences

- Fast (5-10 seconds per test)
- Tests UI state transitions
- Tests button interactions
- Can mock audio to speed up tests
- Deterministic and repeatable

#### Negative Consequences

- Audio is mocked (won't catch real playback issues)
- Cannot verify notification scheduling (no real platform)
- Time manipulation may not match real async behavior
- Moderate complexity to implement correctly

### Option 3: Integration Tests with Debug Mode Timing

Run full app with debug mode timing (2 minutes) on real device/simulator with actual audio playback and notification scheduling.

#### Positive Consequences

- Tests real app behavior end-to-end
- Real audio playback (catches race conditions)
- Can verify notifications are scheduled (inspect platform APIs)
- Can verify notification times, count, and sound configuration
- Real timing behavior
- Highest confidence in correctness
- Closest to production behavior

#### Negative Consequences

- Slow (2+ minutes per test run)
- Cannot run quickly during development
- Audio playback can be flaky in CI environments
- Requires device/simulator
- Still cannot test locked-screen delivery (automation limitation)

### Option 4: Hybrid Pyramid Approach

Combine multiple testing layers:

- **Unit tests**: Fast logic tests with mocks (many tests)
- **Widget tests**: UI state tests with time control (moderate tests)
- **Integration tests**: Critical path tests with debug timing (few tests)

#### Positive Consequences

- Majority of tests are fast (good development feedback)
- Comprehensive coverage across all layers
- Critical paths tested end-to-end
- Fast tests run often, slow tests run before commit
- Balanced approach provides safety without sacrificing speed

#### Negative Consequences

- Three test types to maintain
- More initial setup investment
- Team needs to understand testing strategy
- Higher complexity than single-layer approach

### Option 5: Contract Tests with Abstracted Timer

Create a `TimerStrategy` interface with two implementations:

- `DelayBasedTimerStrategy` (current `Future.delayed()` approach)
- `NotificationBasedTimerStrategy` (new notification approach)

Test that both implementations satisfy the same contract (observable behavior).

#### Positive Consequences

- Both implementations validated against same requirements
- Can keep old implementation working during development
- Easy to switch between implementations via feature flag
- Instant rollback if notification approach fails
- Tests verify observable behavior, not implementation details
- Excellent for validating risky refactorings
- Fake timer can complete instantly for fast tests

#### Negative Consequences

- Requires significant code restructuring (architectural change)
- More abstractions to understand and maintain
- Higher upfront investment
- Contract tests might not catch real-world platform issues

### Option 6: Golden Tests + Timing Verification

Use Flutter golden tests for UI snapshots and separate timing accuracy tests.

#### Positive Consequences

- Golden tests are very fast (< 1 second)
- Visual regression protection
- Can verify timing precision with millisecond accuracy
- Good for detecting unintended UI changes

#### Negative Consequences

- Brittle (break on any UI change)
- Won't catch audio issues
- Won't catch notification scheduling bugs
- Golden files need frequent updating
- Platform-specific (golden tests can differ across platforms)
- Not well-suited for testing behavior changes

### Option 7: Smoke Tests + Manual Beta Testing

Minimal automated tests (app launches, button works) plus heavy reliance on manual testing by beta testers.

#### Positive Consequences

- Minimal automated test setup time
- Very simple to implement
- Real users test real scenarios
- Can test locked-screen behavior manually

#### Negative Consequences

- High risk of shipping bugs
- Slow feedback (hours/days instead of seconds)
- No safety net during refactoring
- Edge cases easily missed
- Cannot rely on this during active development
- Regression detection requires careful manual comparison

### Option 8: No Automated Testing (Do Nothing)

Proceed with refactoring without implementing any new automated tests. Rely entirely on manual testing during development.

#### Positive Consequences

- Zero time investment in test infrastructure
- No learning curve for testing frameworks
- Can start refactoring immediately
- Simplest possible approach

#### Negative Consequences

- No safety net during risky refactoring
- High probability of introducing regressions
- Breaking changes discovered late (after manual testing)
- Difficult to verify that existing functionality still works
- Each code change requires extensive manual verification
- Refactoring becomes much slower due to manual verification overhead
- Difficult to verify edge cases systematically
- No way to quickly verify fixes don't break other parts
- Fear of refactoring leads to worse code quality over time
- Cannot confidently verify timing accuracy changes

### Option 9: Use Existing Testing Services/Tools

Adopt cloud-based testing services or testing frameworks specifically designed for mobile apps.

#### Positive Consequences

- Professional testing infrastructure
- May include device farms for testing on multiple devices
- Some services offer automated regression detection
- Can record and replay test sessions
- May include performance monitoring

#### Negative Consequences

- Ongoing subscription costs
- Learning curve for service-specific features
- May not support notification testing adequately
- Dependency on external service availability
- Privacy concerns (uploading app to third-party service)
- Setup overhead for integration
- May be overkill for small app with single developer
- Still requires writing test scenarios

#### Example Services

- Firebase Test Lab (Google)
- BrowserStack App Automate
- AWS Device Farm
- Sauce Labs
- Appium (open source framework)

## Decision

[To be decided by stakeholder]

## Consequences

[To be completed after decision is made]

## Notes

### Recommended Approach

Based on the analysis, **Option 4 (Hybrid Pyramid)** combined with elements of **Option 5 (Contract Tests)** provides the best balance for this specific refactoring:

1. Create `TimerStrategy` abstraction (Option 5)
2. Keep existing `Future.delayed` implementation working
3. Implement notification-based strategy alongside old code
4. Write integration tests that verify both strategies produce same behavior
5. Integration tests can inspect scheduled notifications (count, times, sounds)
6. Manual testing checklist for locked-screen behavior (automation gap)

This approach provides:

- Fast feedback during development
- Confidence in notification scheduling
- Ability to compare old vs new implementation
- Safety net for the refactoring
- Instant rollback capability

### Testing Pyramid Distribution (Recommended)

If Option 4 is chosen:

- **Integration tests** (slow, ~2-5 tests): Full sequence execution, notification scheduling verification, critical path
- **Widget tests** (medium, ~3-5 tests): UI state transitions, progress updates, button interactions
- **Unit tests** (fast, ~5-10 tests): Timing calculations, session data validation, edge cases

### Manual Testing Checklist (Required for All Options)

No automated approach can test the primary feature (locked-screen delivery). Manual testing must verify:

- Lock screen during first 5-minute session
- Verify gong plays at 5 minutes (via notification)
- Verify all 7 gongs play at correct times
- Verify instruction audio still plays when unlocking
- Test cancellation mid-sequence
- Test restarting sequence multiple times
- Verify battery usage over full 20-minute sequence

### Implementation Timeline Estimate

- Option 1: 2-3 hours
- Option 2: 3-4 hours
- Option 3: 2-3 hours
- Option 4: 5-6 hours
- Option 5: 6-8 hours (includes refactoring)
- Option 6: 3-4 hours
- Option 7: 30 minutes

### Platform-Specific Considerations

Integration tests can programmatically inspect scheduled notifications on both iOS and Android:

```dart
// Can verify in tests:
final pendingNotifications = await notificationPlugin.pendingNotificationRequests();
expect(pendingNotifications.length, 7);
expect(pendingNotifications[0].scheduledTime, expectedTime);
expect(pendingNotifications[0].soundFile, 'gong.aiff');
```

This allows automated verification of notification scheduling without requiring the screen to be locked.

