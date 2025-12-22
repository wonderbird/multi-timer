# Multi Timer für Atempraxis

An iOS app that guides you through a 20-minute breathing exercise rooted in shamanic and yoga traditions.

## What does this app do?

This app helps you practice a specific breathing technique that takes 20 minutes and uses different breathing patterns. It can support emotional well-being and personal growth.

## How does it work?

### Easy to use

The app is super simple—just one "Start" button. No settings to configure, nothing to learn.

### 7 breathing sessions

When you tap "Start", the app automatically runs through these 7 sessions:

1. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
2. **Atem Halten** (Breath Holding) - 1 minute
3. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
4. **Atem Halten** (Breath Holding) - 1 minute
5. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
6. **Wellenatmen** (Wave Breathing) - 2 minutes
7. **Nachspüren** (Sensing/Feeling After) - 1 minute

**Total Duration**: 20 minutes

### Audio guidance

- Before each session, you'll hear a short instruction in German
- At the end of each session, a gong sound marks the transition
- You don't need to look at the screen—the audio guides you through everything

### The screen turns black

**Important**: The screen turns black during the exercise. This is intentional, not a bug. Why?

- Eliminates visual distractions
- Helps you focus on your breathing
- Saves battery life
- A subtle progress bar shows where you are in the session

The black screen helps you stay fully focused on your breathing.

### Everything runs automatically

The app moves through all sessions automatically. You'll hear the instructions and gongs at the right times. When the 20 minutes are up, the app returns to the start screen.

## For Developers

### Requirements

- Flutter SDK (version 3.0.0 or newer)
- Dart SDK
- macOS and Xcode (for iOS development)

### Getting Started

1. Clone this repository
2. Install dependencies:

```bash
flutter pub get
```

### Running the App

Run on an emulator or physical device:

```bash
flutter run
```

### Running on iPhone

To run on your iPhone (requires a free Apple Developer account):

1. **Open in Xcode**:
    * Open the `ios` folder
    * Double-click `Runner.xcworkspace`

2. **Set up signing**:
    * In the left sidebar, select **Runner** (blue icon)
    * Select the **Runner** target in the main view
    * Go to the **Signing & Capabilities** tab
    * Under **Team**, click **Add an Account...** and sign in with your Apple ID
    * Select your **Personal Team** from the dropdown
    * Change the **Bundle Identifier** to something unique (e.g., `com.yourname.multitimer`)

3. **Run the app**:
    * Connect your iPhone with a USB cable
    * Select your device at the top
    * Click the **Play** button (or press `Cmd + R`)

4. **Trust the developer**:
    * If the app doesn't start, open **Settings** on your iPhone
    * Go to **General > VPN & Device Management** (or Profiles)
    * Tap your Apple ID and select **Trust**

### Running on Android

To run on an Android emulator:

1. **Open in Android Studio**:
    * Launch Android Studio
    * Select **File > Open**
    * Choose the project folder

2. **Set up Flutter**:
    * Go to **Settings** (or **Preferences** on Mac)
    * Go to **Languages & Frameworks > Flutter**
    * Enter your Flutter SDK path (like `/Users/username/flutter`)
    * Click **Apply** and **OK**

3. **Create and start an emulator**:
    * Go to **Tools > Device Manager**
    * If you don't have an emulator, click **Create Device** and follow the wizard
    * Click the **Play** button next to your emulator to start it

4. **Run the app**:
    * Wait for the emulator to fully boot
    * Select your emulator from the device dropdown in the toolbar
    * Click the **Run** button (or press **Shift + F10**)

### Syncing from Development VM to Mac

I run AI agents in a Linux virtual machine to protect my main computer. To sync the project to my MacBook, I use this command to preview what will be transferred:

```shell
# Set USER to your sandbox account name
# Set IPV4_ADDRESS to your sandbox IP address
# Set MULTI_TIMER_DIR to the project folder in the sandbox
echo "rsync multi-timer from sandbox"; \
    rsync --dry-run -avz --stats --progress \
          --exclude='.git' \
          --filter=':- .gitignore' \
          --filter=':- .rsyncignore' \
          $USER@$IPV4_ADDRESS:$MULTI_TIMER_DIR/ \
          ./
```

Remove the `--dry-run` flag to actually copy the files.
