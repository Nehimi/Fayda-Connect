# Fayda-Connect (Digital Assistant)

![Version](https://img.shields.io/badge/Version-1.0-blue) ![Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B)

**Version:** 1.0 (2026 Strategy)  
**Developer Role:** Solo Developer (Flutter & Firebase)

Fayda-Connect is a comprehensive digital assistant designed to bridge the gap between the National ID (Fayda) issuance and its practical utility across various Ethiopian sectors. It serves as a unified platform for Banking, Immigration, Business, and Education services, streamlining processes and enhancing user accessibility.

---

## 📱 Features

### 🔐 Authentication
*   **Secure Login & Sign Up:** Phone number based authentication with OTP verification.
*   **Profile Management:** Edit and manage user profiles.

### 🏦 Banking & Finance
*   **Bank Comparison:** Compare services across different banks (Abyssinia, CBE, Dashen, etc.).
*   **Service Application:** Apply for accounts, loans, and link Fayda ID directly.

### 🛂 Immigration & Passport
*   **Passport Services:** Guides for new passports, renewals, and replacements.
*   **Status Tracking:** Track application status.
*   **Doc Vault:** Securely store and manage identification documents.

### 📚 Academy & Education
*   **Educational Resources:** "How-To" articles and verified information.
*   **Exam Registration:** Support for Grade 12 & University admissions.

### 🛠️ Utilities
*   **QR Scanner:** Built-in scanner for Fayda ID verification.
*   **Premium Services:** Subscription-based assistance and priority support.
*   **Reminders:** Custom reminders for renewals and deadlines.
*   **Help & Support:** Direct access to support channels.

---

## 🛠 Tech Stack

*   **Frontend:** Flutter (Dart) - Cross-platform (Android/iOS)
*   **Backend:** Firebase Firestore (NoSQL), Cloud Functions
*   **Design:** Custom Dark Theme, Glassmorphism elements
*   **Integrations:** Chapa / Telebirr (Payments), Telegram (Admin Bot)

---

## 📂 Project Structure

```
lib/
├── models/         # Data models (Order, User, Bank, Service)
├── providers/      # State management providers
├── screens/        # UI Screens
│   ├── auth/       # Authentication (Login, Signup, OTP)
│   ├── academy_screen.dart
│   ├── admin_dashboard_screen.dart
│   ├── home_screen.dart
│   ├── payment_screen.dart
│   ├── scanner_screen.dart
│   └── ...
├── theme/          # App theme, colors, and localization
├── widgets/        # Reusable custom widgets (Snackbar, Cards, etc.)
└── main.dart       # Application entry point
```

---

## 🚀 Installation & Setup

1.  **Clone the repository**
    ```bash
    git clone https://github.com/Nehimi/Fayda-Connect.git
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the application**
    ```bash
    flutter run
    ```

---

## 🏗️ Project Vision & Roadmap

### Core Objective
To bridge the gap between National ID (Fayda) issuance and practical utility across all Ethiopian sectors.

### Application Architecture
*   **Modular Design:** Sector-specific modules for easy updates.
*   **Language Support:** Amharic, Afan Oromo, English, Tigrinya.

### Sector-Specific Goals
*   **Banking (Revenue Core):** Account opening, Loan checks.
*   **Immigration (Traffic Driver):** Passport application simplification.
*   **Business (B2B Gateway):** TIN registration, License renewal.
*   **Education:** Student verification & Transcript security.

### Development Phases
*   **Phase 1 (Information Layer):** UI/UX Dashboard, Content Injection, Local Search.
*   **Phase 2 (Interaction Layer):** Authentication, Dynamic Forms, Payment Integration.
*   **Phase 3 (Business Layer):** Partner Dashboard, B2B Middleware for ID verification.

### Content Strategy
*   **Simplified:** Jargon-free "Grandmother-level" language.
*   **Visual:** Screen-record videos for guides.
*   **Offline-First:** Downloadable guides for offline access.

### Security & Compliance
*   **Encryption:** AES-256 for local data.
*   **Privacy:** Clear distinction as an Independent Assistant (not government official).

---

## 📄 License
This project is proprietary.

📄 Fayda-Connect: Revised Project Documentation (2026 Strategy)
1. Project Overview
Fayda-Connect iyetebale yemitekawekew yih app, be Ethiopia yefayda (National ID) agelglot ena be bankoch, be immigration ena be education mehal yalewun kefitet lemedfegn yetezegaje digital assistant new::

2. Core Vision & Objectives
Simplicity: "Grandmother-level" liron yemichil kelal aserrar::

Security: Be biometric (ashara) yetetebeke yegel dehennet::

Efficiency: Be camera (OCR) berekettalu mereja memulat::

Accessibility: Offline misrat ena be hager wist kuankuwoch tederash mehon::

3. Key Features (Yetekatitu Hasaboch)
A. Smart Interaction & AI
OCR-Quick Fill (Offline): Be camera yefayda kutrnin ena yebank accountn scan adrgo rasu yemimula (100% free & offline)::

AI Photo Validator: Le passport ena le fayda yemihonun photo tirat be AI check yemiyadrg::

Voice Instructions: Be Amharigna ena be Oromigna demts yemitasagezu memeriyawoch::

B. Security & Privacy
Biometric Lock: Appu siyekeft be ashara weyim be fit mewecha yemikutleper (Offline)::

Digital Document Vault: ID, Passport ena luloch senedochin be encrypted melk appu wist mekazen::

Emergency QR-Code: Slik sayekeft le accident gize yemihon yemeleyiya QR code::

C. Services & Utilities
Bank & Immigration Connect: Fayda IDn ke bank account gar mayayez (Be 50 birr agelglot):: Deadline: March 2026::

Status Tracker: Yepassport ena yefayda id dersetual weyim aldershum yemilutin meketatila::

Family Profile Management: Be and app wist yebeteseebn mereja mekazen::

D. Business & Growth
Agent Mode: Wotatoch lelochin bememezgep commission yemiyagenyubet aserrar (Multi-level growth)::

Referral System: Sewu liyagabizu ye mobile card shilmat yemiyagenyubet::

Telegram Bot Integration: Appun lemayichilu sewu be bot tomisay agelglot meshet::

4. Tech Stack (Technical Side)
Frontend: Flutter (Dart) - Cross-platform::

Backend: Firebase (Firestore, Cloud Functions, Auth)::

AI Engine: Google ML Kit (Text Recognition & Face Detection)::

Storage: Hive weyim SQLite (Offline secure storage)::

Payment: Chapa / Telebirr Integration::

5. Revenue Model (Gebi Megniya)
Service Fee: Le and mizuun weyim mayayez 50 birr mekpeel::

Commission: Ke Agent-based regestration yemigeny terf::

Ads: Google AdMob (Tebekamiw siyibez)::