# Updated Project Plan – Milestone 3

**Project:** Patient Care – Nurse Connect App
**Author:** Asif Khan
**Board:** https://github.com/users/asifkhan216/projects/12

## 1. Current Status

The MVP works end to end: a nurse registers, a patient finds her by location, they chat in real time, and the nurse replies from her own account. Testing is documented in [TESTING_EVIDENCE.md](TESTING_EVIDENCE.md), and design choices are recorded in [TECHNICAL_DECISION_LOG.md](TECHNICAL_DECISION_LOG.md).

**Is the project still feasible?** Yes. The core functionality exists and has been tested on two real phones. The remaining work is made of small, separate improvements (security, notifications, better search, more tests) and does not require redesigning the app.

## 2. Work Completed

| Issue | Task | Status |
|-------|------|--------|
| #1 | Set up Flutter project and connect Firebase | Done |
| #2 | Design splash screen, login and sign up pages | Done |
| #3 | Implement Firebase login and sign up | Done |
| #4 | Build home screen with Home and Chats tabs | Done |
| #5 | Create nurse registration screen | Done |
| #6 | Add nurse search and nurse profile | Done |
| #7 | Build real-time chat between patient and nurse | Done |
| Extra | Unit and widget tests, testing evidence, decision log | Done |

## 3. Remaining Work

| Priority | Task | Linked issue | Status |
|----------|------|--------------|--------|
| 1 | Replace the "read all chats" approach with a per-user chat index and strict database security rules | To be created | Planned |
| 2 | Review the GitHub security alert and make sure no private keys are exposed | To be created | Planned |
| 3 | Add unread message counts and push notifications | To be created | Planned |
| 4 | Add GPS or map-based nearby nurse search | To be created | Planned |
| 5 | Add tests for Firebase screens (using mocks) and finish the documentation | #8 | Open |

## 4. Risk Register

| ID | Risk | Likelihood | Impact | Mitigation | Status |
|----|------|-----------|--------|------------|--------|
| R1 | Database rules are open for development, so any logged-in user could read other users' chats | High | High | Add strict rules together with the per-user chat index (see section 5) | Open |
| R2 | The Chats list downloads all chats and filters them on the device, which will be slow and not private with many users | Medium | High | Replace it with the per-user chat index | Open |
| R3 | A nurse's saved `uid` might not match her login ID, which would break her Chats tab | Medium | High | Save the logged-in user's ID at registration and test with a new nurse account | Mitigated in testing |
| R4 | No push notifications, so a nurse may not notice a new message | High | Medium | Add Firebase Cloud Messaging and unread counts | Open |
| R5 | GitHub shows one item under Security and quality, which may be an exposed Firebase key | Medium | Medium | Review the alert, restrict the key in the Firebase console and add platform restrictions | Open |
| R6 | Screens that use Firebase directly have no automated tests | Medium | Medium | Add widget tests with a mocked Firebase | Open |
| R7 | Nurse and home photos load from external links that may stop working | Low | Low | Fallback images already added; later host photos in Firebase Storage | Mitigated |
| R8 | Limited development time before the final demonstration | Medium | Medium | Work in the priority order above and keep each task small | Open |

## 5. Architecture Refinements Planned

The main refinement is a per-user chat index, so each user only reads their own conversations.

```
UserChats
└── <uid>
    └── <roomId>
        ├── otherUid
        ├── lastMessage
        └── lastTime
```

- When a message is sent, the app also updates `lastMessage` and `lastTime` for both users in `UserChats`.
- The Chats tab then reads only `UserChats/<myUid>` instead of the whole `Chats` list.
- Security rules can then allow each user to read and write only their own `UserChats` entries and only the chat rooms whose ID contains their own login ID.


