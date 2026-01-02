# Product Context

## Problem Statement

A specific breathing exercise technique, rooted in shamanic and yoga traditions, supports personal well-being and self-exploration through a structured sequence of breathing patterns. This traditional practice helps users develop greater body awareness and emotional balance.

## Solution

Multi Timer provides a guided audio and timed framework for executing this breathing exercise sequence. The app removes the need for users to:

- Watch a clock during exercises
- Remember the sequence order
- Manually play audio instructions
- Calculate remaining time

By automating the timing and audio cues, practitioners can focus entirely on the breathing exercises without distraction.

## User Experience Goals

### Simplicity

- Single "Start" button - no complex configuration
- No learning curve - immediately usable
- Minimal interface during exercise (black screen with subtle progress bar)

### Focus

- Remove all distractions during 20-minute practice
- Automatic progression through sessions
- Clear audio cues guide transitions

### Reliability

- Consistent timing across sessions
- Reliable audio playback
- Predictable behavior

## User Journey

1. **Start**: User opens app and sees "Start" button
2. **Begin**: User taps button; screen goes black with progress indicator
3. **Session Sequence**: For each of 7 sessions:
   - Hear German audio instruction (technique name)
   - Practice breathing technique during timed interval
   - Hear gong sound marking session end
4. **Complete**: After final gong, app returns to start screen
5. **Repeat**: User can start another session or close app

## Current User Workaround

**Screen Lock Issue**: Users must disable auto-lock in device Settings before each practice session (Settings → Display & Brightness → Auto-Lock → "Never"), then remember to re-enable it afterwards to protect their device. This creates friction and security risk (users may forget to re-enable). Initial beta documented this workaround in TestFlight instructions with security warning.

## Success Metrics (Beta Phase)

1. Completion rate: Can users complete full 20-minute sequence?
2. Audio clarity: Are instructions and gongs audible and clear?
3. Timing accuracy: Do sessions feel properly timed?
4. User feedback: What improvements do testers suggest?
5. Screen lock workaround: How burdensome is keeping screen unlocked?

## Future Considerations

Decisions pending beta feedback:

- Screen lock issue - implementing notifications approach based on beta feedback (v1.1.0)
- Is there demand for public App Store release?
- Do users want additional breathing programs?
- Should timing be customizable?
- Is progress tracking/history valuable?

