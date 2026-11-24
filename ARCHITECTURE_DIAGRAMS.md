# Architecture Diagrams

All four diagrams for the **Patient Care – Nurse Connect** app in one place. GitHub draws them automatically.

1. [System Architecture](#1-system-architecture)
2. [Component Diagram](#2-component-diagram)
3. [Deployment Diagram](#3-deployment-diagram)
4. [Data Flow Diagram](#4-data-flow-diagram)

---

## 1. System Architecture

The Flutter app talks directly to Firebase. There is no custom server.

```mermaid
flowchart LR
    Patient["Patient"] --> App
    Nurse["Nurse"] --> App

    subgraph App["Flutter App"]
        UI["Screens (UI)"]
        Logic["Screen logic (StatefulWidgets)"]
        UI --> Logic
    end

    Logic --> Auth["Firebase Authentication"]
    Logic --> DB[("Firebase Realtime Database")]

    DB --> NurseData["Nurse/postlist"]
    DB --> ChatData["Chats"]
```

---

## 2. Component Diagram

The screens inside the app and the Firebase parts each one uses.

```mermaid
flowchart LR
    subgraph App["Flutter App"]
        Splash["Splash"] --> Login["Login / Sign up"]
        Login --> Shell["Home screen (Home + Chats tabs)"]

        Shell --> Register["Nurse registration"]
        Shell --> Search["Nurse search"]
        Search --> Profile["Nurse profile"]
        Profile --> Room["ChatRoomScreen"]
        Shell --> ChatsList["Chats list"]
        ChatsList --> Room
    end

    Login --> Auth["Firebase Authentication"]
    Register --> Nurses[("Nurse/postlist")]
    Search --> Nurses
    ChatsList --> Nurses
    ChatsList --> Chats[("Chats")]
    Room --> Chats
```

---

## 3. Deployment Diagram

How the app moves from the source code to users' phones, and which cloud services it connects to at run time.

```mermaid
flowchart LR
    subgraph Dev["Development computer"]
        Code["Source code (Flutter / Dart)"]
        Build["flutter build apk --release"]
        Code --> Build
    end

    GitHub["GitHub repository"]
    APK["app-release.apk"]

    Code -->|git push| GitHub
    Build --> APK

    subgraph PhoneP["Patient's Android phone"]
        AppP["Patient Care app"]
    end

    subgraph PhoneN["Nurse's Android phone"]
        AppN["Patient Care app"]
    end

    APK -->|install| AppP
    APK -->|install| AppN

    subgraph Cloud["Firebase (Google Cloud)"]
        Auth["Authentication"]
        DB[("Realtime Database")]
    end

    AppP <-->|internet / HTTPS| Auth
    AppP <-->|internet / HTTPS| DB
    AppN <-->|internet / HTTPS| Auth
    AppN <-->|internet / HTTPS| DB
```

| Node | What runs there |
|------|-----------------|
| Development computer | Flutter SDK, VS Code, Git, tests (`flutter test`) |
| GitHub | Source code, documentation and the project board |
| Android phones | The installed app (patient and nurse use the same app) |
| Firebase | User accounts (Authentication) and all stored data (Realtime Database) |

---

## 4. Data Flow Diagram

### 4.1 Overview: who sends what to which store

```mermaid
flowchart LR
    Patient(["Patient"])
    Nurse(["Nurse"])

    P1["Authenticate user"]
    P2["Register nurse"]
    P3["Search nurses"]
    P4["Chat"]

    D1[("Authentication users")]
    D2[("Nurse/postlist")]
    D3[("Chats")]

    Patient -->|email and password| P1
    Nurse -->|email and password| P1
    P1 <-->|check credentials| D1

    Nurse -->|profile details and photo| P2
    P2 -->|save profile| D2

    Patient -->|location text| P3
    D2 -->|matching profiles| P3
    P3 -->|nurse list and profile| Patient

    Patient -->|message| P4
    Nurse -->|reply| P4
    P4 <-->|save and read messages| D3
    P4 -->|conversation| Patient
    P4 -->|conversation| Nurse
```

### 4.2 Sending a message (step by step)

```mermaid
sequenceDiagram
    participant P as Patient app
    participant DB as Realtime Database (Chats/roomId)
    participant N as Nurse app

    P->>DB: save message (message, senderUid, senderEmail, time)
    DB-->>P: live update, message shown
    DB-->>N: live update, message appears in Chats tab
    N->>DB: save reply
    DB-->>N: live update, reply shown
    DB-->>P: live update, reply appears in the chat
```

The room ID is `<nurseUid>_<patientUid>`, so both users always read and write the same conversation.