# Multi Timer

A minimal Flutter timer application.

## Functionality

1.  **Start**: The app presents a "Start" button in the center of the screen.
2.  **Wait**: Tapping the button turns the screen black and waits for 5 seconds.
3.  **Alarm**: After the wait, a gong sound plays for 3 seconds.
4.  **Reset**: The sound stops and the app returns to the initial state.

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

### Structure
- `lib/main.dart`: Contains the entire application logic.
- `assets/gong.mp3`: The alarm sound file.
