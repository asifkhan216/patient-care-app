# Testing Evidence – Milestone 3

**Project:** Patient Care – Nurse Connect App
**Author:** Asif Khan
**Repository:** https://github.com/asifkhan216/patient-care-app

This document shows how the app was tested: automated unit and widget tests, manual validation tests, manual end-to-end (integration) tests and simple performance measurements.

## 1. Test Environment

| Item | Details |
|------|---------|
| App | Flutter app using Firebase Authentication and Firebase Realtime Database |
| Test devices | Samsung SM-A325F and OnePlus CPH2621 (both real phones) |
| Automated tests | Run on the development computer with `flutter test` |
| Manual tests | Run by hand on both phones, using separate patient and nurse accounts |

## 2. Automated Tests (Unit and Widget)

File: `test/chat_helpers_test.dart`
Command: `flutter test`

Result:

```
00:29 +7: All tests passed!
```

| # | Type | Test | Result |
|---|------|------|--------|
| 1 | Unit | `formatChatTime` returns an empty string for an empty value | Pass |
| 2 | Unit | `formatChatTime` returns an empty string for an invalid date | Pass |
| 3 | Unit | `formatChatTime` shows HH:mm for a message sent today | Pass |
| 4 | Unit | `formatChatTime` shows dd/MM for an older message | Pass |
| 5 | Widget | `ChatAvatar` shows the first letter in capitals when there is no photo | Pass |
| 6 | Widget | `ChatAvatar` shows a question mark when the name is empty | Pass |
| 7 | Widget | `ChatAvatar` ignores a photo value of "null" and shows the letter | Pass |

These tests cover the helper code that does not depend on Firebase. Screens that talk to Firebase were tested manually (sections 3 and 4).

## 3. Manual Validation Tests

| ID | Test | Expected result | Result |
|----|------|-----------------|--------|
| V1 | Tap LOGIN with an empty email and password | "Please enter email" / "Please enter password" is shown | Pass |
| V2 | Sign up with two different passwords | "Passwords do not match" is shown | Pass |
| V3 | Log in with a correct email and a wrong password | An error message is shown and the user is not logged in | Pass |

## 4. Manual Integration Tests (End-to-End Workflow)

Tested on two phones with one nurse account and one patient account.

| ID | Test | Expected result | Result |
|----|------|-----------------|--------|
| I1 | Sign up with a new email | Account is created and the login page opens | Pass |
| I2 | Register a nurse | The nurse appears in Find Nearby Nurse | Pass |
| I3 | Search by typing a location | The list filters to matching nurses | Pass |
| I4 | Patient sends a message | The nurse sees it in her Chats tab | Pass |
| I5 | Nurse sends a reply | The patient sees the reply in the same chat | Pass |
| I6 | Close and reopen the app | Earlier messages are still there | Pass |

## 5. Performance Measurements

Measured by hand with a phone stopwatch.

| ID | What was measured | Result |
|----|-------------------|--------|
| P2 | Tap Send until the message appears on the other phone | about 1.0 second |
| P3 | Tap Find Nearby Nurse until the nurse cards are fully loaded | about 1.0 second |

App start-up time was not measured. Each value is a single hand-timed measurement, so treat it as an approximate result, not a precise benchmark.

## 6. Summary and Gaps

- All 7 automated tests and all 9 manual tests passed.
- Messages are delivered in about one second, and the nurse list loads in about one second.
- **Gaps:** screens that use Firebase directly are not yet covered by automated tests, there is no load testing with many users, and the performance figures are hand-timed. Mocking Firebase for widget tests, plus more precise timing, are planned next steps.