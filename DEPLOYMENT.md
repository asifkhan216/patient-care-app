# Deployment Instructions

How to set up, run and install the **Patient Care – Nurse Connect** app on an Android phone.

## 1. Requirements

| Item | Details |
|------|---------|
| Flutter SDK | Installed and working (check with `flutter doctor`) |
| Android | Android Studio with the Android SDK, or a real phone with USB debugging turned on |
| Firebase | A free Google account to create a Firebase project |
| Git | To download the source code |

## 2. Get the Source Code

```bash
git clone https://github.com/asifkhan216/patient-care-app.git
cd patient-care-app
flutter pub get
```

`flutter pub get` downloads every package listed in `pubspec.yaml`.

## 3. Set Up Firebase

The app uses Firebase Authentication and Firebase Realtime Database.

1. Go to the [Firebase console](https://console.firebase.google.com) and click **Add project**.
2. Inside the project, click **Add app**, choose **Android**, and enter the app's package name. You can find it in `android/app/build.gradle` (the `applicationId` line).
3. Download `google-services.json` and place it in the folder `android/app/`.
4. Open **Authentication**, go to **Sign-in method**, and enable **Email/Password**.
5. Open **Realtime Database** and click **Create database**.
6. Open the **Rules** tab and set the following rules, so only logged-in users can read and write:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

7. If the nurse registration screen uploads photos to Firebase Storage, also enable **Storage** in the same project.

## 4. Run the App in Development

1. Connect a phone with USB debugging on, or start an Android emulator.
2. Run:

```bash
flutter run
```

## 5. Build and Install a Release Version

1. Build the APK file:

```bash
flutter build apk --release
```

2. The finished file is at `build/app/outputs/flutter-apk/app-release.apk`.
3. Copy it to an Android phone and open it to install. Android may ask you to allow installs from this source.

## 6. First-Time Use

1. Open the app and tap **Sign Up** to create an account.
2. To act as a **nurse**, log in and choose **Register as Nurse**, then fill in the profile.
3. To act as a **patient**, create a second account on another phone, tap **Find Nearby Nurse**, open a nurse and tap **Chat With Nurse**.
4. The nurse sees the conversation in the **Chats** tab and can reply.

## 7. Troubleshooting

| Problem | Likely cause and fix |
|---------|---------------------|
| App crashes at start-up | `google-services.json` is missing or in the wrong folder. Place it in `android/app/`. |
| Sign up or login fails | Email/Password sign-in is not enabled in Firebase Authentication. |
| "Could not load chats" or empty lists | Database rules block the request, or the user is not logged in. Check the rules in section 3. |
| Nurse does not appear in search | The nurse profile was not saved. Register again and check `Nurse/postlist` in the Realtime Database. |
| Nurse cannot see a patient's message | The nurse must log in with the same account she used to register, because the chat room ID uses her login ID. |
| `flutter` command not found | Flutter is not on the system path. Reinstall it or add it to the path, then run `flutter doctor`. |