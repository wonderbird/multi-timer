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

### Structure
- `lib/main.dart`: Contains the entire application logic.
- `assets/gong.mp3`: The alarm sound file.
