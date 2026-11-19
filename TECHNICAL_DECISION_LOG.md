# Technical Decision Log – Milestone 3

**Project:** Patient Care – Nurse Connect App
**Author:** Asif Khan

Each decision follows the format **Option → Trade-off → Decision → Reason**.

| ID | Decision | Chosen option |
|----|----------|---------------|
| D1 | Backend | Firebase (no custom server) |
| D2 | Database | Firebase Realtime Database |
| D3 | Chat room structure | One room per nurse and patient pair |
| D4 | Chats list for each user | Read all chats and filter on the device (for the MVP) |
| D5 | Chat screens | One reusable `ChatRoomScreen` for both roles |
| D6 | Navigation | Bottom bar with Home and Chats tabs |
| D7 | Splash screen | Custom Flutter animation, no extra packages |

---

## D1 – Backend

| Option | Trade-off |
|--------|-----------|
| A. Firebase (Authentication + database) | Fast to build and real-time updates are built in, but there is less control and security rules must be written carefully. |
| B. Custom server (for example Node.js with an SQL database) | Full control, but much more work to build, host and secure. |

**Decision:** Option A, Firebase.
**Reason:** The project needs login and real-time chat, and Firebase provides both without running a server. This lets the MVP be finished faster.

---

## D2 – Database

| Option | Trade-off |
|--------|-----------|
| A. Firebase Realtime Database | Very simple, with instant updates and a plain tree structure, but limited querying. |
| B. Cloud Firestore | Stronger queries and structure, but more setup and a more complex data model. |

**Decision:** Option A, Realtime Database.
**Reason:** The app only needs a list of nurses and chat messages, and Realtime Database delivers messages almost instantly with very little code.

---

## D3 – Chat Room Structure

| Option | Trade-off |
|--------|-----------|
| A. One room per nurse and patient pair, with the ID `<nurseUid>_<patientUid>` | Both users always open the same conversation, but a room ID can only be searched by its text. |
| B. One shared list of all messages | Simple to write, but every message must be filtered by sender and receiver. |

**Decision:** Option A.
**Reason:** The ID can be built from the two users' login IDs, so no extra lookup is needed, and both sides see exactly the same messages.

---

## D4 – Chats List for Each User

| Option | Trade-off |
|--------|-----------|
| A. Read all chats and keep only the user's own on the device | Works immediately with the existing data, but it downloads more data than needed and is not private enough for many users. |
| B. Keep a per-user chat index (for example `UserChats/<uid>`) with strict security rules | Scales and is more secure, but needs more code and a data migration. |

**Decision:** Option A for the MVP, with Option B planned.
**Reason:** It let the Chats tab work for both patients and nurses without changing the stored data. Option B is the planned fix and is listed as a risk in the project plan.

---

## D5 – Chat Screens

| Option | Trade-off |
|--------|-----------|
| A. Separate screens: a patient chat, a nurse inbox and a nurse reply screen | Each screen is simple, but code is duplicated and the nurse needs a separate button to find her messages. |
| B. One reusable `ChatRoomScreen` used by both roles | Less code to maintain and the same look for everyone, but the screen needs a few parameters. |

**Decision:** Option B.
**Reason:** The first version used separate inbox and reply screens, then they were replaced. One screen means a bug fix or design change only has to be made once.

---

## D6 – Navigation

| Option | Trade-off |
|--------|-----------|
| A. A "Patient Messages" button on the home screen | Easy to add, but it only suits nurses and feels unlike a normal messaging app. |
| B. A bottom bar with Home and Chats tabs | Familiar, like WhatsApp, and works the same for patients and nurses, but needs a small navigation structure. |

**Decision:** Option B.
**Reason:** Both user types need to reach their conversations from anywhere in the app, and a Chats tab is the pattern users already know.

---

## D7 – Splash Screen

| Option | Trade-off |
|--------|-----------|
| A. A package with a Lottie animation file | Quick, but it depends on extra packages and an asset file; a missing file caused an "Unable to load asset" error. |
| B. A custom Flutter animation with no extra assets | Needs a little more code, but it cannot fail because of a missing file. |

**Decision:** Option B.
**Reason:** The asset error showed the risk of depending on a file that may be missing, and the custom animation gives full control over the design.