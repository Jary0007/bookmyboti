# Error Log for bookmyboti_project

This file documents major build and configuration errors encountered in the project, along with their solutions.

---

## [2024-07-24] NDK source.properties Missing

**Error:**
```
NDK at .../ndk/27.0.12077973 did not have a source.properties file
```
**Context:**
Running `flutter build apk` after updating Firebase dependencies.

**Root Cause:**
NDK 27.0.12077973 was not fully installed.

**Solution:**
Installed NDK 27.0.12077973 via Android Studio SDK Manager.

**Status:**
Fixed

---

## [2024-07-24] google-services.json Package Name Mismatch

**Error:**
```
No matching client found for package name 'com.example.bookmyboti' in .../android/app/google-services.json
```
**Context:**
Running `flutter build apk` after configuring Firebase.

**Root Cause:**
`google-services.json` did not contain a client entry for the app's package name.

**Solution:**
Changed `applicationId` in `android/app/build.gradle.kts` to match the package name in `google-services.json` (`com.bookmyboti.app`).

**Status:**
Fixed

---

## [2024-07-24] minSdkVersion Too Low

**Error:**
```
uses-sdk:minSdkVersion 21 cannot be smaller than version 23 declared in library [com.google.firebase:firebase-auth:23.2.1]
```
**Context:**
Running `flutter build apk` after updating Firebase libraries.

**Root Cause:**
Firebase libraries require minSdkVersion 23, but project was set to 21.

**Solution:**
Set `minSdk = 23` in `android/app/build.gradle.kts`.

**Status:**
Fixed

---

## [2024-07-24] google_sign_in API/Version Issues

**Error:**
```
Error: Couldn't find constructor 'GoogleSignIn'.
Error: The method 'signIn' isn't defined for the class 'GoogleSignIn'.
Error: The getter 'accessToken' isn't defined for the class 'GoogleSignInAuthentication'.
```
**Context:**
Running `flutter build apk` after updating dependencies.

**Root Cause:**
Old version of `google_sign_in` package incompatible with code.

**Solution:**
Updated `google_sign_in` dependency to `^6.1.5` in `pubspec.yaml`.

**Status:**
Fixed

--- 

---

## How to Fix

### 1. **Start an Emulator**
- Open Android Studio.
- Go to **Tools > Device Manager** (or AVD Manager).
- Click the play ▶️ button next to your emulator (e.g., Pixel 9) to start it.
- Wait until the emulator is fully booted (you see the Android home screen).

### 2. **Check Device Connection**
- In your terminal, run:
  ```sh
  adb devices
  ```
- You should see a list of connected devices/emulators. Example:
  ```
  List of devices attached
  emulator-5554   device
  ```

### 3. **Install the APK Again**
- Once the emulator is running and detected, run:
  ```sh
  adb install build/app/outputs/flutter-apk/app-release.apk
  ```

---

**If you still see “no devices/emulators found”:**
- Make sure the emulator is running and not crashing.
- Try restarting the emulator and your computer if needed.
- If using a physical device, ensure USB debugging is enabled and the device is connected.

Let me know if you need help with any of these steps or if you get a different error! 