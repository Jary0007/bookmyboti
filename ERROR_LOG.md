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