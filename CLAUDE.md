# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Approach is a Flutter mobile application configured for cross-platform deployment (iOS, Android, Web, macOS, Linux, Windows). The project is set up with a complete CI/CD pipeline using GitHub Actions and Google Cloud Build, with Firebase App Distribution for testing deployments.

**Bundle ID**: `com.iazogu.approach`  
**App Name**: "Approach"

## Development Commands

### Basic Development
```bash
# Install dependencies
flutter pub get

# Run app on connected device/simulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (during development)
# Press 'r' in terminal or save files in IDE

# Run tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Building
```bash
# Build for all platforms (using local script)
./build.sh

# Build iOS (unsigned for simulator)
flutter build ios --release --no-codesign

# Build iOS (for device - requires signing)
flutter build ios --release

# Build Android APK
flutter build apk --release

# Build Android App Bundle (for Play Store)
flutter build appbundle --release

# Build for web
flutter build web

# Build for macOS
flutter build macos --release
```

### Device Management
```bash
# List available devices and emulators
flutter devices

# List available emulators
flutter emulators

# Launch iOS simulator
flutter emulators --launch apple_ios_simulator

# Launch Android emulator
flutter emulators --launch <emulator-id>
```

### Debugging and Analysis
```bash
# Check Flutter installation and setup
flutter doctor

# Analyze code for issues
flutter analyze

# Check for dependency updates
flutter pub outdated

# Upgrade dependencies (with version constraints)
flutter pub upgrade
```

## Project Architecture

### Core Structure
- **`lib/main.dart`**: Entry point with `MyApp` (StatelessWidget) and `MyHomePage` (StatefulWidget counter demo)
- **`test/`**: Widget tests using Flutter's testing framework
- **`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`**: Platform-specific configurations and build files

### CI/CD Pipeline Architecture
The project implements a multi-stage deployment pipeline:

1. **GitHub Actions** (`.github/workflows/ci-cd.yml`):
   - Parallel builds for iOS (macOS runner) and Android (Ubuntu runner)
   - Automated testing on all builds
   - Artifact storage for deployment
   - Firebase App Distribution deployment on main branch

2. **Google Cloud Build** (`cloudbuild.yaml`):
   - Flutter installation and setup in cloud environment
   - Cross-platform builds with artifact storage in GCS bucket `gs://approach-app-builds`
   - Timeout: 1200s, Machine: E2_HIGHCPU_8

3. **Local Build Script** (`build.sh`):
   - Validates Flutter installation
   - Runs full test suite
   - Builds unsigned iOS and release Android APK
   - Provides build artifact locations

### Configuration Files
- **`pubspec.yaml`**: Flutter 3.8.1+, uses Material Design, flutter_lints for code quality
- **`firebase.json`**: Configured for web hosting and App Distribution
- **iOS Bundle ID**: Updated to `com.iazogu.approach` to match developer account

## Device Testing Setup

### iOS Simulator Testing
The app runs successfully on iOS simulator. For device testing:
1. Configure signing certificates in Xcode
2. Update provisioning profiles
3. Build with: `flutter build ios --release`

### Android Testing
APK builds are ready for sideloading or distribution via Firebase App Distribution.

## CI/CD Requirements

### GitHub Secrets (for Actions)
- `FIREBASE_TOKEN`: Firebase CLI token for app distribution
- `FIREBASE_ANDROID_APP_ID`: Firebase Android app identifier

### GCP Setup
- Project ID: `approach-flutter-app` (configurable via substitutions)
- Requires Cloud Build API enabled
- Storage bucket for artifacts: `gs://approach-app-builds`

## Flutter Version
- **Target**: Flutter 3.32.6 (stable channel)
- **Dart SDK**: ^3.8.1
- **Key Dependencies**: cupertino_icons, flutter_lints for development