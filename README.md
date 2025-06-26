# biometric_app
A Flutter app demonstrating secure biometric authentication and local data storage.

## Features

- Biometric authentication (Fingerprint, Face ID)
- Secure local storage for sensitive data
- Simple and clean user interface
- Cross-platform support (Android & iOS)

## Note

- This app does not allow to record screen fingerprint or pin while authentication . I have provided link so you can download apk and check features manually.



## Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/biometric_app.git
    cd biometric_app
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

3. **Run the app:**
    ```bash
    flutter run
    ```

## Usage

- Launch the app on your device or emulator.
- Follow the on-screen instructions to enable and use biometric authentication.
- The app will prompt for fingerprint or face authentication based on your device's capabilities.

## Project Structure

```
lib/
├── main.dart           # Entry point of the application
├── screens/            # UI screens
├── providers/           # providers 

```

## Dependencies

- [`local_auth`](https://pub.dev/packages/local_auth): For biometric authentication
- [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage): For secure data storage

## Contributing

Contributions are welcome! Please open issues and submit pull requests for improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
