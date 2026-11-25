# Technical Documentation

**Project:** Patient Care – Nurse Connect App
**Author:** Asif Khan
**Repository:** https://github.com/asifkhan216/patient-care-app

## 1. Project Overview

Patient Care is an Android app made with Flutter and Firebase. It connects patients with nurses. Nurses register a profile, patients search for a nurse by location, and both chat in real time.

**Problem:** Finding a trusted nurse for home care is hard, and patients and nurses have no simple way to reach each other.
**Solution:** One app where nurses present themselves and patients can find and message them.

## 2. Requirements

### Functional

| ID | Requirement |
|----|-------------|
| F1 | A user can sign up and log in with email and password. |
| F2 | A nurse can register a profile (name, education, location, contact, photo). |
| F3 | A patient can search nurses by location. |
| F4 | A patient can open a nurse profile. |
| F5 | A patient and a nurse can chat in real time. |
| F6 | Every user can see all their conversations in a Chats list. |

### Non-functional

| ID | Requirement |
|----|-------------|
| N1 | Only logged-in users can read or write data. |
| N2 | Messages should arrive in about one second. |
| N3 | All screens use one consistent design. |
| N4 | The app runs on Android phones. |

## 3. Architecture

The Flutter app talks directly to Firebase. There is no custom server.

- **Firebase Authentication** handles sign up and login.
- **Firebase Realtime Database** stores nurse profiles (`Nurse/postlist`) and chat messages (`Chats/<nurseUid>_<patientUid>`).
- Each nurse and patient pair has one chat room, so both always see the same conversation.

All four diagrams (system, component, deployment, data flow) are in [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md). More detail is in [ARCHITECTURE.md](ARCHITECTURE.md) and [ARCHITECTURE_UPDATE.md](ARCHITECTURE_UPDATE.md).

## 4. Technical Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Backend | Firebase, no custom server | Gives login and real-time data without running a server. |
| Database | Realtime Database | Simple and delivers messages almost instantly. |
| Chat rooms | One per nurse and patient pair | Both sides open the same conversation with no extra lookup. |
| Chat screens | One reusable `ChatRoomScreen` | Less code, same look for patients and nurses. |
| Navigation | Bottom bar with Home and Chats | Familiar, and works for both user types. |

The full log with options and trade-offs is in [TECHNICAL_DECISION_LOG.md](TECHNICAL_DECISION_LOG.md).

## 5. Testing

| Type | Result |
|------|--------|
| Unit and widget tests (7) | All passed (`flutter test`) |
| Validation and end-to-end tests (9) | All passed on two real phones |
| Security tests (4) | All passed: a user who is not logged in cannot read or write data |
| Performance | Messages arrive in about 1 second; the nurse list loads in about 1 second |

Details and screenshots are in [TESTING_EVIDENCE.md](TESTING_EVIDENCE.md).

## 6. Conclusions

**Achieved:** The app works end to end. A nurse registers, a patient finds her and sends a message, and the nurse replies from her own phone. The database now accepts only logged-in users.

**Limitations:**
- A logged-in user can still read other users' chats. The fix is a per-user chat index with stricter rules.
- No push notifications or unread counts.
- Search uses typed location text, not GPS.
- Screens that use Firebase directly have no automated tests yet.

**Next steps:** stricter database rules, push notifications, GPS search and more tests. See [PROJECT_PLAN.md](PROJECT_PLAN.md).

## 7. How to Run

See [DEPLOYMENT.md](DEPLOYMENT.md).