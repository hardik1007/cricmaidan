# CricMaidan

Cross-platform Flutter app (Android · iOS · Web) for cricket scoring and management with **Firebase Auth** + **Google Sign-In**, **Riverpod** state management, and **GoRouter** navigation.

---

## Tech stack

| Layer       | Package                    | Version  |
|-------------|----------------------------|----------|
| State       | flutter_riverpod           | ^2.5.1   |
| Navigation  | go_router                  | ^14.2.0  |
| Auth        | firebase_auth              | ^5.1.4   |
| Google SSO  | google_sign_in             | ^6.2.1   |
| Models      | freezed + freezed_annotation | ^2.5.2  |
| Network     | dio                        | ^5.4.3   |
| Storage     | flutter_secure_storage     | ^9.2.2   |

---

## Project structure

```
lib/
├── main.dart
├── firebase_options.dart          ← replace with flutterfire configure output
├── core/
│   ├── router/app_router.dart     ← GoRouter + redirect logic
│   ├── theme/app_theme.dart       ← Material 3 light + dark themes
│   └── utils/validators.dart      ← Form validators
└── features/
    ├── auth/
    │   ├── data/
    │   │   └── auth_repository.dart    ← Firebase + Google sign-in calls
    │   ├── domain/
    │   │   ├── auth_state.dart         ← Freezed sealed state
    │   │   └── auth_state.freezed.dart ← Pre-generated (no build_runner needed)
    │   └── presentation/
    │       ├── auth_notifier.dart      ← StateNotifier driving the UI
    │       ├── screens/
    │       │   ├── splash_screen.dart
    │       │   ├── login_screen.dart
    │       │   └── signup_screen.dart
    │       └── widgets/
    │           └── auth_widgets.dart   ← GoogleSignInButton, OrDivider, etc.
    └── home/
        └── presentation/
            └── home_screen.dart
```

---

## Setup

### 1. Prerequisites

```bash
flutter --version   # 3.19+
dart --version      # 3.3+
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase project

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → **Add project**
2. Under **Authentication → Sign-in method**, enable:
   - Email/Password
   - Google

### 4. FlutterFire CLI (generates firebase_options.dart)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites `lib/firebase_options.dart` with your real credentials.

### 5. Android — add SHA-1 fingerprint

Firebase Console → Project settings → Your Android app → Add fingerprint

```bash
# Get debug SHA-1
cd android
./gradlew signingReport
# Copy the SHA1 from "Variant: debug"
```

Download the updated `google-services.json` and place it at:
```
android/app/google-services.json
```

### 6. iOS — configure URL scheme

After `flutterfire configure`, open `ios/Runner/Info.plist` and replace
`REVERSED_CLIENT_ID_PLACEHOLDER` with the `REVERSED_CLIENT_ID` value from
your `GoogleService-Info.plist`.

```
REVERSED_CLIENT_ID = com.googleusercontent.apps.YOUR_CLIENT_ID
```

Then install pods:
```bash
cd ios && pod install
```

### 7. Web — Google client ID (externalized)

Web configuration is now externalized in `web/config.js` to keep secrets safe.
See **Step 8** below for setup.

---

### 8. Environment Configuration — Externalize API Keys

To keep sensitive credentials out of version control:

#### 8.1 Add `.env` file from template

```bash
cp .env.example .env
```

#### 8.3 Fill in your actual values in `.env`

```env
GOOGLE_CLIENT_ID=YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com
FIREBASE_WEB_API_KEY=YOUR_WEB_API_KEY
GOOGLE_CLIENT_SECRET=YOUR_CLIENT_SECRET
```

#### 8.4 For Web `web/config.js` for web deployment

Edit `web/config.js` and replace the placeholder with your actual Google Client ID:

```javascript
window.appConfig = {
  googleClientId: 'YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com',
};
```

> **Note:** For production web deployment to Firebase Hosting, you'll need to update `web/config.js` with your actual credentials. See the **Deploy** section below.

#### 8.5 Install dependencies

Install the dependency for environment variable loading:

```bash
flutter pub get
```

> ⚠️ **Security**: Never commit `.env` to GitHub. Only `.env.example` (with placeholder values) is committed. Your `.env` file is gitignored and stays on your local machine.

---

## Running

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# All connected devices
flutter run
```

---

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ios --release

# Web
flutter build web --release
```

> **For web builds**: Ensure `web/config.js` has your actual Google Client ID before building.

---

## Deploy

### Firebase Hosting (Web)

Deploy your Flutter web build to Firebase Hosting:

```bash
# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project (if not done)
firebase init hosting

# When prompted for public directory, use: build/web

# Deploy
firebase deploy --only hosting
```

Your web app will be live at: `https://<PROJECT_ID>.web.app`

### Firebase App Distribution (Android)

Distribute Android builds to testers via Firebase App Distribution:

```bash
# Build release APK first
flutter build apk --release

# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Upload to App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-app.apk \
  --app 1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID \
  --release-notes "Beta release" \
  --testers "tester@example.com"
```

Testers will receive an invite link to download and install the app.

### Google Play Store (Android)

For production Android releases:

1. **Create a signing key:**
   ```bash
   keytool -genkey -v -keystore ~/play-key.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload
   ```

2. **Build signed App Bundle:**
   ```bash
   flutter build appbundle --release
   ```

3. **Configure Play Store:**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create an app and add your signing key's certificate
   - Upload the App Bundle from `build/app/outputs/bundle/release/app-release.aab`

4. **Review and publish** from the Play Console dashboard

### Apple App Store (iOS)

For production iOS releases:

1. **Configure signing in Xcode:**
   ```bash
   cd ios
   open Runner.xcworkspace
   ```
   - Set Team ID and signing certificate in Xcode

2. **Build for App Store:**
   ```bash
   flutter build ipa --release
   ```

3. **Upload to App Store:**
   - Use [Transporter app](https://apps.apple.com/us/app/transporter/id1450874784) to upload `build/ios/ipa/cricmaidan.ipa`
   - Or use Xcode's archive uploader

4. **Submit for review** in [App Store Connect](https://appstoreconnect.apple.com)

---

## Auth flow overview

```
App start
  └── SplashScreen
        ├── Firebase authStateChanges stream fires
        ├── authenticated  → /home
        └── unauthenticated → /login

/login
  ├── Email + password  → Firebase signInWithEmailAndPassword
  ├── Google button     → GoogleSignIn → Firebase signInWithCredential
  └── "Sign up" link    → /signup

/signup
  ├── Google button (primary CTA)
  ├── Name + Email + Password + Confirm
  └── "Sign in" link    → /login

GoRouter redirect fires on every AuthState change — no manual navigation needed.
```

---

## Adding more providers later

The `AuthRepository` is the only file to touch. Add a method:

```dart
Future<UserCredential> signInWithApple() async { ... }
Future<UserCredential> signInWithGitHub() async { ... }
```

Then expose it in `AuthNotifier` and wire up a button — the router redirect
handles the rest automatically.

---

## Notes

- `auth_state.freezed.dart` is pre-generated so you can start without running
  `build_runner`. After changing `auth_state.dart` run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- `flutter_secure_storage` is included for storing additional tokens if your
  backend requires a separate JWT beyond Firebase's ID token.
- Minimum platform targets: **Android SDK 21**, **iOS 13**, **Chrome/Edge/Firefox** (latest).
