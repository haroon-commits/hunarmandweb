#!/bin/bash
set -e  # Exit immediately on any error

echo "========================================="
echo " Hunarmand Kashmir - Vercel Build Script "
echo "========================================="

# Use a pinned stable Flutter version for reproducible builds
FLUTTER_VERSION="3.32.0"

echo "Downloading Flutter $FLUTTER_VERSION..."
git clone https://github.com/flutter/flutter.git -b stable --depth=1 flutter-sdk

# Add flutter to PATH for this session
export PATH="$PATH:$(pwd)/flutter-sdk/bin"

echo "Flutter version:"
flutter --version

# Enable web support
flutter config --enable-web

echo "Installing dependencies..."
flutter pub get

echo "Building web app (release)..."
flutter build web --release --web-renderer canvaskit

echo "Build complete! Output in build/web/"
