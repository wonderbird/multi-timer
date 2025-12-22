# Multi Timer für Atempraxis

An iOS app that guides you through a 20-minute breathing exercise. The breathing technique comes from shamanic and yoga traditions.

## What is this app for?

This app helps you practice a specific breathing exercise. The exercise takes 20 minutes and uses different breathing patterns. This technique can help you feel better emotionally and grow personally.

## How does it work?

### Simple to use

The app is very simple. You only see a "Start" button. No settings to configure, nothing to learn.

### 7 exercise sections

When you tap "Start", the app automatically runs through these 7 sections:

1. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
2. **Atem Halten** (Breath Holding) - 1 minute
3. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
4. **Atem Halten** (Breath Holding) - 1 minute
5. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
6. **Wellenatmen** (Wave Breathing) - 2 minutes
7. **Nachspüren** (Sensing/Feeling After) - 1 minute

**Total Duration**: 20 minutes

### Audio instructions

- Before each section, you hear a short instruction in German
- At the end of each section, a gong sound plays
- You don't need to look at the screen, the audio guides you

### The screen turns black

**Important**: The screen turns black during the exercise. This is not a bug, it's on purpose. Why?

- You won't get distracted by images
- You can focus better on your breathing
- Your battery lasts longer
- A small progress bar shows you how far along you are

The black screen helps you stay focused and pay attention only to your breath.

### Everything runs automatically

The app moves through all sections by itself. You hear the instructions and gong at the right times. After the 20 minutes are done, you return to the start screen.

## For developers

### What you need

- Flutter SDK (version 3.0.0 or newer)
- Dart SDK
- macOS and Xcode (if you want to build for iOS)

### Getting started

1. Clone this repository
2. Install the required packages:

```bash
flutter pub get
```

### Running the app

Run on an emulator or physical device:

```bash
flutter run
```

### Running on iPhone

To run on your iPhone (you need a free Apple Developer account):

1. **Open in Xcode**:
    * Open the `ios` folder
    * Double-click `Runner.xcworkspace`

2. **Set up signing**:
    * In the left sidebar, click **Runner** (blue icon)
    * Select the **Runner** target
    * Go to **Signing & Capabilities**
    * Under **Team**, click **Add an Account...** and sign in with your Apple ID
    * Select your **Personal Team** from the dropdown
    * Change the **Bundle Identifier** to something unique (like `com.yourname.multitimer`)

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

3. **Start an emulator**:
    * Go to **Tools > Device Manager**
    * If you don't have an emulator yet, click **Create Device** and follow the steps
    * Click the **Play** button next to your emulator

4. **Run the app**:
    * Wait for the emulator to start up completely
    * Select your emulator from the device dropdown
    * Click the **Run** button (or press **Shift + F10**)

### Syncing from development VM to Mac

I run AI agents in a Linux virtual machine to keep my main computer safe. I copy the project to my MacBook regularly using this command to check what would be copied:

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
