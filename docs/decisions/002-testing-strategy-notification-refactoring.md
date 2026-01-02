# ADR 002: Testing Strategy for Notification-Based Timer Redesign

## Status

Proposed

## Executive Summary

This ADR evaluates 9 testing approaches for implementing the notification-based timer (ADR-001 fix). The redesign replaces `Future.delayed()` with OS-native notifications, which is a risky architectural change affecting internal implementation. Key finding: **Option 4 (Hybrid Pyramid)** or **Option 3 (Integration Tests)** provide the best balance of safety, speed, and coverage.

**Critical constraint:** Automated tests cannot verify locked-screen notification delivery. Manual testing remains essential for the primary feature.

**Recommended:** Option 3 (Integration Tests) for time-constrained scenario (2-3 hours), or Option 4 (Hybrid Pyramid) for comprehensive coverage (5-6 hours).

## Context

The app is undergoing a significant architectural change to fix the screen lock issue (as documented in ADR-001). The current implementation uses `Future.delayed()` for timing, which will be replaced with OS-native scheduled notifications. This is a risky redesign that could break core functionality.

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

1. **Safety Net During Redesign**: Need confidence that existing functionality won't break during significant internal changes
2. **Fast Feedback Loop**: Tests must run quickly enough to use during development (< 1 minute for most tests)
3. **Regression Detection**: Must catch breaking changes to timing, audio, UI, and session sequence
4. **Platform Integration Coverage**: Must verify notification scheduling even if locked-screen delivery requires manual testing
5. **Maintainability**: Testing approach must be sustainable for a small team/solo developer

## Options Comparison Summary

Evaluation of each option against the decision drivers (⭐ = 1 point, max 5 stars per driver):

| Option | Safety Net | Fast Feedback | Regression Detection | Platform Integration | Maintainability | Total | Time Investment |
|--------|------------|---------------|----------------------|---------------------|-----------------|-------|-----------------|
| **1. Unit Tests** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐⭐ | 14/25 | 2-3 hours |
| **2. Widget Tests** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ | 15/25 | 3-4 hours |
| **3. Integration Tests** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 20/25 | 2-3 hours |
| **4. Hybrid Pyramid** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 21/25 | 5-6 hours |
| **5. Contract Tests** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 19/25 | 6-8 hours |
| **6. Golden Tests** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐ | 12/25 | 3-4 hours |
| **7. Smoke + Manual** | ⭐⭐ | ⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | 11/25 | 30 min |
| **8. No Testing** | ⭐ | ⭐ | ⭐ | ⭐ | ⭐⭐⭐⭐⭐ | 9/25 | 0 hours |
| **9. Testing Services** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | 15/25 | 4-6 hours + cost |

**Key Insights:**

- **Option 4 (Hybrid Pyramid)** scores highest overall (21/25)
- **Option 3 (Integration Tests)** is close second (20/25) with less time investment
- **Options 1, 6, 7, 8** score poorly on core drivers (safety net, regression detection, platform integration)
- **Options 4 and 5** require most upfront investment but provide strongest safety net

## Considered Options

1. **Pure Unit Tests with Mocked Time**
2. **Widget Tests with Time Control**
3. **Integration Tests with Debug Mode Timing** (Recommended for time-constrained)
4. **Hybrid Pyramid Approach** (Recommended for comprehensive coverage)
5. **Contract Tests with Abstracted Timer**
6. **Golden Tests + Timing Verification**
7. **Smoke Tests + Manual Beta Testing**
8. **No Automated Testing (Do Nothing)** (Not Recommended)
9. **Use Existing Testing Services/Tools**

## Detailed Options Analysis

### Option 1: Pure Unit Tests with Mocked Time

Extract business logic into testable functions and mock all dependencies (time, audio player, notifications).

#### Summary

Test timing calculations, session sequencing, and business logic in isolation using mocked dependencies. All platform-specific behavior (audio, notifications, UI) is mocked away for maximum speed.

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

#### Mitigations for Negative Consequences

- **Refactoring overhead**: Extract only the most critical logic (timing calculations, session sequencing); keep UI code integrated
- **Missing real issues**: Supplement with small number of integration tests (2-3) for critical paths
- **False confidence**: Document explicitly what unit tests do NOT cover; require integration tests before each release
- **Platform bugs**: Use integration tests or manual testing checklist for platform-specific verification

### Option 2: Widget Tests with Time Control

Use Flutter's `WidgetTester` with `binding.pump()` to fast-forward time and test UI state changes.

#### Summary

Test UI behavior and state transitions using Flutter's widget testing framework. Time is controlled via `pump()` methods to avoid waiting for real delays. Audio can be mocked for speed.

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

#### Mitigations for Negative Consequences

- **Mocked audio**: Add 1-2 integration tests with real audio to catch playback issues
- **No notification platform**: Use integration tests (Option 3) for notification verification
- **Time manipulation differences**: Keep widget test durations short; validate timing with integration tests
- **Implementation complexity**: Use Flutter's official testing documentation and examples; start with simple tests

### Option 3: Integration Tests with Debug Mode Timing

Run full app with debug mode timing (2 minutes) on real device/simulator with actual audio playback and notification scheduling.

#### Summary

Test complete app behavior end-to-end on real device/simulator using debug mode's shortened timings. Verifies real audio playback, notification scheduling, and full session sequence. Can inspect platform notification APIs to verify scheduling correctness.

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

#### Mitigations for Negative Consequences

- **Slow tests**: Run only before commits, not after every code change; use widget tests for rapid iteration
- **Development speed**: Keep number of integration tests small (2-5); focus on critical paths only
- **Flaky audio**: Run integration tests locally on developer machine, not in CI initially
- **Device requirement**: Use simulator for faster execution; reserve physical device for pre-release testing
- **Locked-screen gap**: Maintain manual testing checklist; run before each beta/release

### Option 4: Hybrid Pyramid Approach

Combine multiple testing layers:

- **Unit tests**: Fast logic tests with mocks (many tests)
- **Widget tests**: UI state tests with time control (moderate tests)
- **Integration tests**: Critical path tests with debug timing (few tests)

#### Summary

Implement a balanced testing strategy with three layers. Unit tests provide fast feedback for logic changes, widget tests verify UI behavior, and integration tests ensure critical paths work end-to-end. Follows industry best practices for test pyramid distribution.

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

#### Mitigations for Negative Consequences

- **Maintenance burden**: Keep total test count reasonable (15-20 tests); favor quality over quantity
- **Setup investment**: Implement incrementally; start with integration tests (highest value), add widget tests later
- **Understanding strategy**: Document testing approach in README; use clear test names that explain what they verify
- **Complexity**: Standard approach in industry; many examples available; worth investment for risky redesign

### Option 5: Contract Tests with Abstracted Timer

Create a `TimerStrategy` interface with two implementations:

- `DelayBasedTimerStrategy` (current `Future.delayed()` approach)
- `NotificationBasedTimerStrategy` (new notification approach)

Test that both implementations satisfy the same contract (observable behavior).

#### Summary

Extract timer logic behind an interface to enable testing both old and new implementations against the same contract. Tests verify observable behavior rather than implementation details. Enables side-by-side comparison and instant rollback capability.

#### Positive Consequences

- Both implementations validated against same requirements
- Can keep old implementation working during development
- Easy to switch between implementations via feature flag
- Instant rollback if notification approach fails
- Tests verify observable behavior, not implementation details
- Excellent for validating risky redesigns
- Fake timer can complete instantly for fast tests

#### Negative Consequences

- Requires significant code restructuring (architectural change)
- More abstractions to understand and maintain
- Higher upfront investment
- Contract tests might not catch real-world platform issues

#### Mitigations for Negative Consequences

- **Restructuring effort**: Abstraction provides long-term benefits (testability, flexibility); worthwhile for core functionality
- **Abstraction complexity**: Keep interface simple; document with clear examples; common pattern in software design
- **Upfront cost**: Amortized over project lifetime; enables faster changes in future
- **Missing platform issues**: Combine with integration tests that verify platform behavior; contract verifies logic correctness

### Option 6: Golden Tests + Timing Verification

Use Flutter golden tests for UI snapshots and separate timing accuracy tests.

#### Summary

Capture pixel-perfect screenshots of UI states for visual regression testing. Combine with timing verification tests that measure actual durations. Focuses on detecting unintended visual changes rather than behavior changes.

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

#### Mitigations for Negative Consequences

- **Brittleness**: Accept that golden tests need updating with UI changes; use for stable screens only
- **Audio/notification gaps**: Combine with other testing approaches for behavior verification
- **Update burden**: Use golden tests sparingly; focus on critical UI states only
- **Platform differences**: Generate separate golden files per platform; or use only on primary development platform
- **Behavior testing limitation**: Use golden tests only for regression detection, not for verifying redesign

### Option 7: Smoke Tests + Manual Beta Testing

Minimal automated tests (app launches, button works) plus heavy reliance on manual testing by beta testers.

#### Summary

Implement only basic automated smoke tests to verify app launches and core UI elements render. Rely primarily on manual testing by beta testers for functional validation. Minimal automation investment.

#### Positive Consequences

- Minimal automated test setup time
- Very simple to implement
- Real users test real scenarios
- Can test locked-screen behavior manually

#### Negative Consequences

- High risk of shipping bugs
- Slow feedback (hours/days instead of seconds)
- No safety net during redesign
- Edge cases easily missed
- Cannot rely on this during active development
- Regression detection requires careful manual comparison

#### Mitigations for Negative Consequences

- **Bug risk**: Develop comprehensive manual testing checklist; test systematically after each change
- **Slow feedback**: Keep changes very small; test immediately after each change
- **No safety net**: Make incremental commits; be prepared to roll back frequently
- **Missing edge cases**: Dedicate time to brainstorm edge cases; document them explicitly
- **Development reliability**: Consider this approach only if timeline is extremely tight and stakes are low
- **Regression detection**: Keep detailed notes of expected behavior; compare systematically

**Overall assessment**: Mitigations help but cannot fully address the fundamental risks. Not recommended for risky redesign work.

### Option 8: No Automated Testing (Do Nothing)

Proceed with redesign without implementing any new automated tests. Rely entirely on manual testing during development.

#### Summary

Skip automated testing entirely and proceed with the notification-based redesign using only manual verification. Each code change requires manual testing to verify correctness. Zero time investment in test infrastructure.

#### Positive Consequences

- Zero time investment in test infrastructure
- No learning curve for testing frameworks
- Can start redesign immediately
- Simplest possible approach

#### Negative Consequences

- No safety net during risky redesign
- High probability of introducing regressions
- Breaking changes discovered late (after manual testing)
- Difficult to verify that existing functionality still works
- Each code change requires extensive manual verification
- Redesign becomes much slower due to manual verification overhead
- Difficult to verify edge cases systematically
- No way to quickly verify fixes don't break other parts
- Fear of change leads to worse code quality over time
- Cannot confidently verify timing accuracy changes

#### Mitigations for Negative Consequences

- **No safety net**: Work in very small increments; commit working code frequently; maintain ability to roll back
- **Regression risk**: Manual testing after every small change; use beta testers for validation before merging
- **Late discovery**: Test continuously during development, not just at the end
- **Verification difficulty**: Create detailed checklist of expected behaviors; systematically verify each one
- **Manual overhead**: Accept that redesign will take longer; plan accordingly
- **Edge cases**: Document edge cases upfront; test them explicitly
- **Fear of change**: Make changes smaller and more isolated; reduce blast radius
- **Timing verification**: Use debug mode (shorter timings) for faster manual verification cycles

**Overall assessment**: Mitigations are labor-intensive and error-prone. Only suitable if testing investment is absolutely impossible.

### Option 9: Use Existing Testing Services/Tools

Adopt cloud-based testing services or testing frameworks specifically designed for mobile apps.

#### Summary

Leverage third-party testing infrastructure such as Firebase Test Lab, BrowserStack, or AWS Device Farm. Provides access to device farms, automated test execution, and professional testing tools. May include features like test recording and replay.

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

#### Mitigations for Negative Consequences

- **Subscription costs**: Use free tiers where available (Firebase Test Lab has limited free quota); evaluate ROI for small project
- **Learning curve**: Start with one service; use official tutorials and examples
- **Notification support**: Research notification testing capabilities before committing; supplement with local testing if needed
- **Service dependency**: Use primarily for pre-release validation, not for daily development feedback
- **Privacy**: Review service privacy policies; use services from reputable vendors (Google, Amazon, Microsoft)
- **Setup overhead**: Follow service quickstart guides; many provide Flutter-specific examples
- **Overkill concern**: Consider free tier for device diversity testing only; not for daily development
- **Test scenario work**: This is unavoidable regardless of testing approach; services don't eliminate the need for test design

#### Example Services

- Firebase Test Lab (Google) - free tier available
- BrowserStack App Automate
- AWS Device Farm
- Sauce Labs
- Appium (open source framework, self-hosted)

## Decision

[To be decided by stakeholder]

## Consequences

[To be completed after decision is made]

## Related Decisions

- **ADR-001: Background Timer Reliability with Screen Lock** - Documents the architectural change this testing strategy supports

## Implementation Notes

### Top Recommendations

**For time-constrained scenario (2-3 hours):**

- Choose **Option 3 (Integration Tests)**
- Write 2-5 integration tests covering critical paths
- Verify notification scheduling via platform APIs
- Use manual checklist for locked-screen testing
- Provides 20/25 coverage score - sufficient safety net

**For comprehensive coverage (5-6 hours):**

- Choose **Option 4 (Hybrid Pyramid)**
- Combine integration, widget, and unit tests
- Best overall coverage (21/25 score)
- Fast feedback from widget/unit tests during development
- Integration tests for confidence before commits

### Recommended Approach Detail

Based on the analysis, **Option 4 (Hybrid Pyramid)** combined with elements of **Option 5 (Contract Tests)** provides the best balance for this specific redesign:

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
- Safety net for the redesign
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
- Option 3: 2-3 hours (recommended for time-constrained)
- Option 4: 5-6 hours (recommended for comprehensive)
- Option 5: 6-8 hours (includes code restructuring)
- Option 6: 3-4 hours
- Option 7: 30 minutes
- Option 8: 0 hours (not recommended)
- Option 9: 4-6 hours + ongoing subscription costs

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

### Success Criteria for Chosen Approach

Regardless of which option is selected, the testing strategy should demonstrate:

1. **No Regressions**: Existing functionality (audio playback, progress bar, session sequence) continues to work
2. **Notification Verification**: Can verify notifications are scheduled with correct times and sounds
3. **Fast Enough**: Provides feedback quickly enough to support active development
4. **Caught Bugs**: Demonstrates ability to catch actual bugs during development (not just theoretical coverage)
5. **Sustainable**: Can be maintained and extended as the app evolves

### Risk Assessment

**Highest Risk Options (not recommended):**

- Option 8 (No Testing): No safety net for risky redesign
- Option 7 (Smoke + Manual): Insufficient coverage for internal architectural change
- Option 6 (Golden Tests): Doesn't test behavior that's changing

**Moderate Risk Options:**

- Option 1 (Unit Tests): Misses platform integration bugs
- Option 2 (Widget Tests): Cannot verify notification system
- Option 9 (Testing Services): Setup overhead may not justify benefit for small app

**Lower Risk Options (recommended):**

- Option 3 (Integration Tests): Best single-layer approach
- Option 4 (Hybrid Pyramid): Most comprehensive
- Option 5 (Contract Tests): Excellent for redesign but requires restructuring

### Implementation Phases (if Option 4 or 5 chosen)

**Phase 1: Baseline (Week 1)**

- Set up test infrastructure
- Write 2-3 integration tests for current implementation
- Verify tests pass with existing code
- Establish baseline for comparison

**Phase 2: Development (Week 2-3)**

- Implement notification-based approach per ADR-001 plan
- Run tests after each step to catch regressions early
- Add new tests for notification-specific behavior

**Phase 3: Validation (Week 3-4)**

- Run full test suite
- Perform manual testing checklist for locked-screen behavior
- Deploy to TestFlight for beta validation

### Quick Start for Time-Constrained Scenario

If 5-8 hours for comprehensive testing is not feasible, **Option 3 (Integration Tests alone)** provides the best value:

- **Time investment:** 2-3 hours setup
- **Coverage score:** 20/25 (high)
- **What it tests:** Full app behavior, notification scheduling, timing accuracy, audio playback
- **What it catches:** Most regressions, platform integration bugs, timing issues
- **What it provides:** Sufficient safety net for redesign

**Implementation steps:**

1. Set up Flutter integration testing (30 min)
2. Write test for full sequence execution (45 min)
3. Add test for notification scheduling verification (30 min)
4. Add test for cancellation mid-sequence (30 min)
5. Document manual testing checklist (15 min)

Always combine with manual testing checklist for locked-screen verification.

