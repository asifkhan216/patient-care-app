# Progress Summary – Milestone 2 (MVP)

**Project:** Patient Care – Nurse Connect App
**Author:** Asif Khan
**Repository:** https://github.com/asifkhan216/patient-care-app
**Project board:** https://github.com/users/asifkhan216/projects/12

## Overview

Patient Care is a Flutter and Firebase mobile app that connects patients with nurses. The MVP delivers the core value of the project: a patient can find a nurse and talk to her, and the nurse can answer from her own account.

## What Works

- Animated splash screen, sign up and login with Firebase Authentication.
- Home screen with a bottom bar (Home and Chats tabs).
- Nurse registration with name, education, location, contact and photo.
- Search for the nearest nurse by typing a location.
- Full nurse profile page.
- Real-time chat between a patient and a nurse, with a Chats list for both roles so each person can return to earlier conversations.
- The complete workflow runs end to end on two devices: a nurse registers, a patient finds her and sends a message, the nurse replies and the patient sees the reply instantly.

## Current Limitations

- The Chats list reads all chats and filters them on the device, which will not scale to many users.
- Database security rules are still open for development.
- No unread message counts or push notifications.
- No automated tests yet.

## Next Development Goals

1. Tighten the Firebase security rules so users can only read their own chats.
2. Add a per-user chat index to replace the filter on the device.
3. Add unread counts and push notifications.
4. Complete payment process.
5. Write tests for the main screens and finish the documentation.


## GitHub Activity

All tasks are tracked as issues on the project board. Seven of eight issues are closed, and the remaining one (tests and final documentation) is open. The repository also contains the README, the initial architecture draft and this milestone's architecture update.