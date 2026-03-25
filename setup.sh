#!/bin/bash
echo "================================================"
echo "  BhadaBook - Flutter Project Setup"
echo "================================================"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "[ERROR] Flutter not found in PATH."
    echo "Install from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "[1/3] Flutter found. Getting packages..."
flutter pub get || { echo "[ERROR] flutter pub get failed."; exit 1; }

echo ""
echo "[2/3] Checking connected devices..."
flutter devices

echo ""
echo "[3/3] Setup complete!"
echo ""
echo "To run the app:"
echo "  Web  (localhost):  flutter run -d chrome"
echo "  Android emulator:  flutter run -d android"
echo "  iOS simulator:     flutter run -d ios"
echo ""
