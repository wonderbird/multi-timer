# Multi Timer für Atempraxis

A guided breathing exercise application for iOS that helps users practice a specific meditative breathing technique rooted in shamanic and yoga traditions.

## Purpose

This app guides users through a structured 20-minute breathing exercise sequence that works with psychological patterns developed in early life stages. The technique uses specific breathing patterns (full body breathing, breath holding, wave breathing, and sensing) to support emotional well-being and personal growth.

## How It Works

### Simple Interface

The app provides a minimal, distraction-free interface with a single "Start" button. No configuration or learning curve required.

### 7-Session Guided Sequence

When the user taps "Start", the app executes a fixed sequence of 7 timed breathing sessions:

1. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
2. **Atem Halten** (Breath Holding) - 1 minute
3. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
4. **Atem Halten** (Breath Holding) - 1 minute
5. **Ganzkörperatmung** (Full Body Breathing) - 5 minutes
6. **Wellenatmen** (Wave Breathing) - 2 minutes
7. **Nachspüren** (Sensing/Feeling After) - 1 minute

**Total Duration**: 20 minutes

### Audio Guidance

- Before each session, the app plays a brief German-language audio instruction naming the technique
- At the end of each session, a gong sound marks the transition
- Audio guides practitioners without requiring them to watch the screen

### Intentional Black Screen

**Important for App Review**: The screen turns black during the exercise sequence *by design*, not as a bug. This intentional behavior:

- Minimizes visual distractions during practice
- Helps users focus on internal breathing experience
- Reduces battery consumption
- Includes a subtle progress bar for time awareness

The black screen is a core feature of the meditative practice, allowing practitioners to concentrate fully on their breathing without external visual stimuli.

### Automatic Progression

The app automatically progresses through all sessions, playing audio cues and gongs at appropriate times. After completing the final session, the app returns to the start screen.

## Developer Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- macOS and Xcode (required for iOS development)

### Setup
1.  Clone the repository.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Run
Run on an emulator or physical device:
```bash
flutter run
```

### Running on iOS (Physical Device)
To run on an iPhone using a free Apple Developer account:

1.  **Open Project in Xcode**:
    *   Open the `ios` folder.
    *   Double-click `Runner.xcworkspace`.

2.  **Configure Signing**:
    *   In the project navigator (left sidebar), select **Runner** (blue icon).
    *   Select the **Runner** target in the main view.
    *   Go to the **Signing & Capabilities** tab.
    *   Under **Team**, select **Add an Account...** and sign in with your Apple ID.
    *   Select your **Personal Team** from the dropdown.
    *   Update the **Bundle Identifier** to a unique value (e.g., `com.yourname.multitimer`).

3.  **Run**:
    *   Connect your iPhone via USB.
    *   Select your device in the top toolbar.
    *   Click the **Play** button (or `Cmd + R`).

4.  **Trust Developer**:
    *   If the app installs but won't launch, go to your iPhone's **Settings**.
    *   Navigate to **General > VPN & Device Management** (or Profiles).
    *   Tap your Apple ID email and select **Trust**.

### Running on Android (Simulator)

To run on an Android emulator:

1.  **Open Project in Android Studio**:
    *   Launch Android Studio.
    *   Select **File > Open**.
    *   Navigate to and select the entire project folder.

2.  **Configure Flutter SDK**:
    *   Go to **Settings** (or **Preferences** on Mac).
    *   Navigate to **Languages & Frameworks > Flutter**.
    *   Set the Flutter SDK path (e.g., `/Users/username/flutter`).
    *   Click **Apply** and **OK**.

3.  **Create/Start an Emulator**:
    *   Go to **Tools > Device Manager**.
    *   If no emulator exists, click **Create Device** and follow the wizard.
    *   Click the **Play** button next to your emulator to start it.

4.  **Run**:
    *   Wait for the emulator to fully boot.
    *   Select your emulator from the device dropdown in the toolbar.
    *   Click the **Run** button (or press **Shift + F10**).

### Synchronize Sandboxed Development Environment to Mac

To prevent an ai agent from corrupting my development computer, I run it inside a linux virtual machine. As a consequence, I frequently copy intermediate states of the repository over to my macBook.

I use the following command for checking which files would be transferred:

```shell
# Set the USER to the account you use on the sandbox
# Set IPV4_ADDRESS to the ip address of the sandbox
# Set the MULTI_TIMER_DIR to the directory of the project in the sandbox
echo "rsync multi-timer from sandbox"; \
    rsync --dry-run -avz --stats --progress \
          --exclude='.git' \
          --filter=':- .gitignore' \
          --filter=':- .rsyncignore' \
          $USER@$IPV4_ADDRESS:$MULTI_TIMER_DIR/ \
          ./
```

Then I remove the --dry-run parameter to actually perform the transfer.
