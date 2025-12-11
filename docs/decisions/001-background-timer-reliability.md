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

## Decision

[To be decided by stakeholder]

## Consequences

[To be completed after decision is made]

## Implementation Notes

[To be completed after decision is made]

