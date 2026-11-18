# Patient Care – Nurse Connect App

A mobile app that connects patients with nurses. Patients can find a nearby nurse, view her profile, and chat with her directly. Nurses can register, receive messages from patients, and reply, all inside the app.

> Built with Flutter and Firebase.

---

## Team Members

| Name | Role | GitHub |
|------|------|--------|
| Your Name | Team Lead / Flutter Developer | [@asifkhan216](https://github.com/asifkhan216) |
| Member 2 | UI/UX Designer | [@username](https://github.com/username) |
| Member 3 | Backend (Firebase) Developer | [@username](https://github.com/username) |
| Member 4 | Tester / Documentation | [@username](https://github.com/username) |

> Replace the names, roles and usernames with your real team.

---

## Problem Statement

Finding a trusted nurse for home care is difficult. Patients usually depend on word of mouth or phone calls, and there is no simple place to see which nurses are available nearby, what their qualifications are, or how to contact them quickly. Nurses, in turn, have no easy way to present their skills and reach patients who need them.

This project solves that by giving patients and nurses one shared app where nurses can register a profile, patients can search by location, and both sides can talk through a built-in chat.

---

## Project Goals

- Let nurses **register** with their name, education, location, contact details and photo.
- Let patients **search nearby nurses** by location and view full nurse profiles.
- Provide **real-time chat** between a patient and a nurse (WhatsApp-style).
- Give every user a **Chats list** so they can return to earlier conversations.
- Keep sign-up and login **simple and secure** using Firebase Authentication.
- Deliver a clean, consistent, easy-to-use mobile interface.

---

## Features

- Animated splash screen
- Sign up and login (Firebase Authentication)
- Home screen with Home and Chats tabs
- Nurse registration
- Search the nearest nurse by location
- Nurse profile screen
- Real-time chat between patient and nurse
- Chats list for both patients and nurses

---

## Tech Stack

| Area | Technology |
|------|-----------|
| Mobile app | Flutter (Dart) |
| Authentication | Firebase Authentication (email + password) |
| Database | Firebase Realtime Database |
| Version control | Git and GitHub |
| Project management | GitHub Projects |

---

## Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install).
2. Clone the repository:
   ```bash
   git clone https://github.com/asifkhan216/patient-care-app.git
   cd patient-care-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Connect your own Firebase project (Authentication and Realtime Database) and add the Firebase config files for your platform.
5. Run the app:
   ```bash
   flutter run
   ```

---

## Project Structure

```
lib/
├── main.dart                   # App entry point
├── splash_screen.dart          # Animated splash screen
├── login_screen.dart           # Login
├── sign_up_page.dart           # Sign up
├── home_screen.dart            # Home + Chats tabs
├── nurse_registertion.dart     # Nurse registration
├── recive_nurse_data.dart      # Search nearest nurse
├── search_nearset_nurse.dart   # Nurse profile
├── chats_list_screen.dart      # List of conversations
├── chat_room_screen.dart       # Chat conversation
└── chat_screen.dart            # Opens a chat from a nurse profile
```

---

## Documentation

- [Architecture overview](ARCHITECTURE.md)
- Project board: [Patient Care Board](https://github.com/users/asifkhan216/projects/12)