# ADR 001: Background Timer Reliability with Screen Lock

## Status

Proposed

## Context

The multi-timer application uses `Future.delayed()` to wait for specific durations (5 minutes, 1 minute, etc.) before playing a gong sound. During testing on iPhone, it was discovered that the gong sound does not play after 5 minutes when the device screen locks automatically after 30 seconds of inactivity.

### Problem Analysis

#### iOS Behavior

When the iPhone screen locks:

- iOS suspends the app to conserve battery
- The Flutter engine is paused
- `Future.delayed()` timers stop counting because they depend on the active Dart isolate
- The app "freezes" at approximately 30 seconds into the timer
- After 5 minutes of wall clock time, only ~30 seconds have elapsed from the app's perspective
- The gong never plays because the timer never completes

#### Android Behavior

Android devices exhibit similar issues but with more variability:

- **Doze Mode** (Android 6.0+): When screen is off and device stationary, apps are suspended
- `Future.delayed()` timers also stop in Doze mode
- Behavior varies by manufacturer (Samsung, Xiaomi, Huawei have aggressive battery optimizations)
- May work for several minutes before Doze activates, but unreliable
- No guarantees the timer will complete

#### Root Cause

The current implementation lacks:

- Background execution permissions
- OS-native timing mechanisms that work when app is suspended
- Any wake locks or foreground services
- Local notification scheduling

## Decision Drivers

- **Reliability**: Timer alerts must work consistently when device screen is locked
- **Cross-platform compatibility**: Solution must work on both iOS and Android
- **Battery efficiency**: Solution should minimize battery drain
- **User experience**: Minimal disruption to users (e.g., screen should be allowed to lock)
- **Development complexity**: Implementation should be maintainable and well-supported

## Considered Options

### Option 1: Implement Local Notifications with `flutter_local_notifications`

Schedule OS-native notifications at the required times when user starts the timer.

#### Technical Details

- Use `flutter_local_notifications` package (v9.5.3+1 or later)
- Schedule all 7 notifications upfront at calculated times
- Each notification configured with custom gong sound
- OS handles timing and delivery, independent of app state

#### Positive Consequences

- Highly reliable on both iOS and Android
- Works when app is suspended, backgrounded, or even terminated
- Minimal battery impact (OS-managed)
- Well-established pattern used by most timer apps
- Strong community support and documentation
- Can schedule notifications with custom sounds
- `androidAllowWhileIdle: true` ensures delivery even in Doze mode

#### Negative Consequences

- Requires platform-specific configuration (AndroidManifest.xml, Info.plist)
- Need to manage notification permissions (request from user)
- iOS limits to 64 pending notifications per app
- Sound file format requirements differ by platform (MP3 for Android, AIFF for iOS)
- Notifications appear in notification tray (may be seen as intrusive by some users)
- Requires timezone package dependency for accurate scheduling
- Implementation more complex than simple timer

#### Mitigations for Negative Consequences

- **Platform-specific configuration**: One-time setup with clear documentation and examples available from package maintainer
- **Notification permissions**: Request permission at app launch with clear explanation of why it's needed; standard practice for timer apps
- **iOS 64 notification limit**: Not a concern for this app (only 7 notifications per timer session); can cancel previous notifications if user restarts timer
- **Sound file format differences**: Convert gong sound to both formats once during development; automated tooling available
- **Notifications in tray**: This is expected behavior for timer apps; allows users to see remaining timers at a glance; can be configured as non-persistent
- **Timezone dependency**: Lightweight package (~1MB); widely used and maintained
- **Implementation complexity**: Well-documented package with extensive examples; complexity is one-time investment for reliable functionality

### Option 2: Use `awesome_notifications` Package

Alternative notification package with more features and customization.

#### Technical Details

- Use `awesome_notifications` package
- Schedule notifications with advanced UI customization
- Similar OS-native notification approach

#### Positive Consequences

- More customization options for notification appearance
- Rich notification UI capabilities
- Cross-platform support
- Scheduled notifications work when app suspended

#### Negative Consequences

- Heavier package (larger app size)
- More complex API and setup
- Less widely adopted than `flutter_local_notifications`
- May be overkill for simple timer requirements
- Steeper learning curve

#### Mitigations for Negative Consequences

- **Package size**: While heavier, modern devices handle this easily; can evaluate if app size becomes critical concern
- **Complex API**: Documentation is comprehensive; invest time upfront in learning the API
- **Less adoption**: Still has active maintenance and community; viable option if additional features needed
- **Overkill for simple timers**: Consider only if need advanced notification features beyond basic sound alerts
- **Learning curve**: Prototype with simpler `flutter_local_notifications` first; migrate only if advanced features prove necessary

### Option 3: Keep Screen Awake with `wakelock_plus`

Prevent device screen from locking so current timer implementation continues to work.

#### Technical Details

- Use `wakelock_plus` package
- Acquire wake lock when timer starts
- Release when timer completes or user stops
- Current `Future.delayed()` implementation remains unchanged

#### Positive Consequences

- Simplest implementation (minimal code changes)
- No need to modify notification permissions
- Current timer logic works as-is
- Cross-platform support

#### Negative Consequences

- Significant battery drain (screen stays on continuously)
- Poor user experience (bright screen for 5+ minute durations)
- Users cannot use device normally during timer
- Not standard practice for timer applications
- Does not solve problem if user manually locks screen
- Increases device heat generation
- May cause screen burn-in on OLED displays with prolonged use

#### Mitigations for Negative Consequences

- **Battery drain**: Reduce screen brightness programmatically during timer; partial mitigation only
- **Bright screen UX**: Display dim timer countdown; still disruptive for users wanting to pocket device
- **Device usage restriction**: Cannot be fully mitigated; fundamental limitation of approach
- **Non-standard practice**: No mitigation; accept deviation from industry norms or choose different solution
- **Manual lock problem**: Display prominent warning to users not to lock screen; poor UX
- **Heat generation**: Unavoidable side effect of keeping screen on; reduces device lifespan
- **OLED burn-in**: Animate timer display to move pixels; only partial mitigation; risk remains

**Overall assessment**: Mitigations are insufficient; this approach has fundamental drawbacks that cannot be adequately addressed.

### Option 4: Do Nothing (Accept Current Behavior)

Continue with current implementation, accept that timer only works with screen unlocked.

#### Technical Details

- No code changes
- Document limitation for users

#### Positive Consequences

- Zero development effort
- No additional dependencies
- Simplest possible approach

#### Negative Consequences

- App does not meet basic user expectations for timer functionality
- Poor user reviews likely
- Users will uninstall or not use the app
- Timer is essentially non-functional for real-world use cases
- Defeats the purpose of having a timer app

#### Mitigations for Negative Consequences

- **User expectations**: Clearly document limitation in app description and first-run tutorial; still results in poor UX
- **Poor reviews**: Proactively explain limitation before users discover it; unlikely to prevent negative feedback
- **User churn**: No effective mitigation; users need working timer functionality
- **Non-functional for real use**: Cannot be mitigated without code changes
- **Defeats purpose**: No mitigation possible; fundamentally fails to solve the core problem

**Overall assessment**: No viable mitigations; this option makes the app unsuitable for its intended purpose.

### Option 5: Investigate Manual Workarounds

Document ways users can configure their devices to keep app running.

#### Technical Details

- Document iOS setting to increase auto-lock time
- Document Android battery optimization exemption process
- Instruct users to keep screen on manually

#### Positive Consequences

- No code changes required
- Transfers responsibility to users
- May work for technically savvy users

#### Negative Consequences

- Poor user experience (unreasonable burden on users)
- Workarounds may not persist across device restarts
- Different instructions needed per device manufacturer
- Not reliable (users forget, settings reset)
- Still requires screen to stay on (battery drain)
- Does not solve core problem
- Unprofessional solution for a published app

#### Mitigations for Negative Consequences

- **Poor UX**: Create detailed visual guides with screenshots; still places burden on users
- **Settings persistence**: Remind users to check settings periodically; unreliable
- **Manufacturer variations**: Maintain comprehensive documentation for major manufacturers (Samsung, Xiaomi, Huawei, OnePlus, etc.); high maintenance burden
- **Reliability issues**: Add in-app reminders and check settings programmatically; cannot force user compliance
- **Battery drain**: No mitigation; inherent to workaround approach
- **Core problem unsolved**: Combine with other options (e.g., also implement notifications); adds complexity
- **Unprofessional**: Cannot be mitigated; industry expects apps to "just work"

**Overall assessment**: Mitigations add complexity without achieving reliability; not recommended for production apps.

### Option 6: Purchase/Use Existing Timer App

Instead of building custom solution, use existing timer applications.

#### Technical Details

- Research existing timer apps:
  - Insight Timer (meditation app with interval timers)
  - Interval Timer - HIIT Workouts
  - MultiTimer by Jee Chul Kim
- Evaluate feature fit for specific use case (5-1-5-1-5-2-1 pattern)

#### Positive Consequences

- Zero development time
- Professional, tested solutions
- Regular updates and support
- Proven reliability
- Additional features may be available

#### Negative Consequences

- Loss of control over features and behavior
- May not match exact requirements (specific interval pattern)
- Ongoing cost if subscription-based
- Privacy concerns with third-party apps
- Cannot customize for specific needs
- Dependency on external vendor
- May include ads or unwanted features

#### Mitigations for Negative Consequences

- **Loss of control**: Evaluate apps thoroughly before committing; choose open-source options if available
- **Feature mismatch**: Test multiple apps to find closest match; may require accepting compromises
- **Ongoing costs**: Prefer one-time purchase or free apps; evaluate cost vs. development time savings
- **Privacy concerns**: Review privacy policies carefully; choose apps with strong privacy ratings
- **Limited customization**: Accept constraints or combine with minimal custom development
- **Vendor dependency**: Keep backup timer app identified; document alternatives
- **Ads/unwanted features**: Look for premium versions or ad-free options; factor cost into decision

**Overall assessment**: Viable option if an existing app meets requirements; evaluate thoroughly before abandoning custom development.

## Options Comparison Matrix

| Criteria | Option 1: flutter_local_notifications | Option 2: awesome_notifications | Option 3: wakelock_plus | Option 4: Do Nothing | Option 5: Manual Workarounds | Option 6: Use Existing App |
|----------|--------------------------------------|--------------------------------|------------------------|---------------------|----------------------------|---------------------------|
| **Reliability** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐ Good (if screen stays on) | ⭐ Poor | ⭐⭐ Poor | ⭐⭐⭐⭐⭐ Excellent |
| **Cross-platform** | ⭐⭐⭐⭐⭐ Full support | ⭐⭐⭐⭐⭐ Full support | ⭐⭐⭐⭐⭐ Full support | ⭐⭐⭐⭐⭐ N/A | ⭐⭐ Platform-specific | ⭐⭐⭐⭐⭐ Full support |
| **Battery Efficiency** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent | ⭐ Very Poor | ⭐⭐⭐⭐⭐ N/A | ⭐ Very Poor | ⭐⭐⭐⭐⭐ Excellent |
| **User Experience** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐ Poor | ⭐ Unacceptable | ⭐⭐ Poor | ⭐⭐⭐⭐ Good (depends on app) |
| **Development Complexity** | ⭐⭐⭐ Moderate | ⭐⭐ Higher | ⭐⭐⭐⭐⭐ Very Simple | ⭐⭐⭐⭐⭐ None | ⭐⭐⭐⭐ Low Code | ⭐⭐⭐⭐⭐ None |
| **Maintenance Burden** | ⭐⭐⭐⭐ Low | ⭐⭐⭐ Moderate | ⭐⭐⭐⭐ Low | ⭐⭐⭐⭐⭐ None | ⭐ Very High | ⭐⭐⭐⭐⭐ None |
| **Industry Standard** | ⭐⭐⭐⭐⭐ Yes | ⭐⭐⭐⭐ Acceptable | ⭐⭐ Uncommon | ⭐ Unacceptable | ⭐ Unprofessional | ⭐⭐⭐⭐⭐ Standard |
| **Overall Recommendation** | **RECOMMENDED** | Alternative | Not Recommended | Not Viable | Not Recommended | Viable Alternative |

## Technical Considerations

### Current Timer Implementation

The app defines a sequence of 7 wait durations:

```dart
final List<int> _waitDurations = [300, 60, 300, 60, 300, 120, 60];
// Translates to: 5 min, 1 min, 5 min, 1 min, 5 min, 2 min, 1 min
```

### Sound Asset Requirements

- **Current format**: MP3 (`assets/gong.mp3`)
- **Android requirement**: MP3 or other Android-supported formats
- **iOS requirement**: AIFF, CAF, or other iOS-supported formats
- **Action needed**: Convert gong.mp3 to gong.aiff for iOS notifications

### Notification Scheduling Pattern

For Options 1 and 2, notifications would be scheduled at cumulative times:

| Notification | Time from Start | Cumulative Seconds |
|-------------|----------------|-------------------|
| 1 | 5 minutes | 300s |
| 2 | 6 minutes | 360s |
| 3 | 11 minutes | 660s |
| 4 | 12 minutes | 720s |
| 5 | 17 minutes | 1020s |
| 6 | 19 minutes | 1140s |
| 7 | 20 minutes | 1200s |

### Permission Requirements by Platform

#### iOS (Option 1 or 2)

- Request notification permission via `UNUserNotificationCenter`
- Users can deny; app must handle gracefully
- Add `UIBackgroundModes` key with `remote-notification` value (optional for better reliability)

#### Android (Option 1 or 2)

- Notification permission required for Android 13+ (API level 33+)
- Need to declare in AndroidManifest.xml:
  - `android.permission.POST_NOTIFICATIONS` (Android 13+)
  - `android.permission.SCHEDULE_EXACT_ALARM` (Android 12+)
  - `android.permission.USE_EXACT_ALARM` (Android 14+)

### Migration Path

If Option 1 is selected, suggested implementation phases:

1. **Phase 1**: Add dependencies and platform configuration
2. **Phase 2**: Implement notification initialization and permission request
3. **Phase 3**: Convert sound file to iOS-compatible format
4. **Phase 4**: Replace `Future.delayed()` loop with notification scheduling
5. **Phase 5**: Test on both iOS and Android with screen locked
6. **Phase 6**: Handle notification cancellation if user stops timer early

## Decision

[To be decided by stakeholder]

## Consequences

[To be completed after decision is made]

## Implementation Notes

[To be completed after decision is made]

