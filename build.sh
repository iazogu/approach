#!/bin/bash

# Approach Flutter App Build Script
echo "🚀 Building Approach Flutter App..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run tests
echo "🧪 Running tests..."
flutter test

# Build for iOS (unsigned - for simulator testing)
echo "🍎 Building iOS app..."
flutter build ios --release --no-codesign

# Build for Android
echo "🤖 Building Android APK..."
flutter build apk --release

echo "✅ Build completed successfully!"
echo "📱 iOS app: build/ios/iphoneos/Runner.app"
echo "📱 Android APK: build/app/outputs/flutter-apk/app-release.apk"