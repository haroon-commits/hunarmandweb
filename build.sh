#!/bin/bash

# Download Flutter
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable

# Add flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support (just in case)
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web app
flutter build web --release
