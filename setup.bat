@echo off
echo ================================================
echo   BhadaBook - Flutter Project Setup
echo ================================================
echo.

:: Check Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter not found in PATH.
    echo Please install Flutter from https://flutter.dev/docs/get-started/install/windows
    echo Then add flutter\bin to your PATH and re-run this script.
    pause
    exit /b 1
)

echo [1/3] Flutter found. Getting packages...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] flutter pub get failed.
    pause
    exit /b 1
)

echo.
echo [2/3] Checking connected devices...
flutter devices

echo.
echo [3/3] Setup complete!
echo.
echo To run the app:
echo   Web  (localhost):  flutter run -d chrome
echo   Android emulator:  flutter run -d android
echo   iOS simulator:     flutter run -d ios   (Mac only)
echo   All devices:       flutter run
echo.
pause
