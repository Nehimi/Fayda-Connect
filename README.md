# Fayda Connect 🇪🇹
### Your Digital bridge to Ethiopian National ID (Fayda) Services

[![Version](https://img.shields.io/badge/Version-1.2.0-blue.svg?style=for-the-badge)](https://github.com/Nehimi/Fayda-Connect)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg?style=for-the-badge)](LICENSE)

---

## 🌟 Overview

**Fayda Connect** is a premium, state-of-the-art digital assistant designed to streamline the utility of the Ethiopian National ID (**Fayda**) across multiple sectors. Our mission is to bridge the gap between ID issuance and practical application in Banking, Immigration, Business, and Education.

With a focus on **accessibility, security, and simplicity**, Fayda Connect empowers users—from technology experts to first-time smartphone users—to navigate complex bureaucratic processes with ease.

---

## 🚀 Key Pillars

### 🔐 Security & Identity
- **Biometric Authentication:** Secure your sensitive documents and data using Fingerprint or Face ID.
- **Digital Document Vault:** Encrypted storage for your Fayda ID, Passport, and other critical documents.
- **Secure Auth:** Phone-based OTP verification for a seamless and secure login experience.

### 🏦 Banking & Finance
- **Bank Comparison:** Side-by-side comparison of services, interest rates, and Fayda-linked benefits across major Ethiopian banks (CBE, Dashen, Abyssinia, etc.).
- **Smart Linking:** Guided processes to link your National ID with your bank accounts for seamless transactions.

### 🛂 Immigration & Passport
- **Passport Concierge:** Step-by-step guides for new applications, renewals, and replacements.
- **Real-time Status Tracking:** Keep tabs on your application progress directly within the app.

### 🎓 Education & Academy
- **Exam & University Portals:** Integrated support for Grade 12 registrations and university admission processes.
- **Digital Literacy:** "How-To" guides and resources to help you understand your digital rights and utilities.

### 🛠️ Smart Utilities
- **OCR Scanner (Offline):** Instantly capture ID details using advanced AI-powered text recognition—works 100% offline.
- **Emergency QR:** Access critical medical or contact information via a secure QR code on your lock screen.
- **Reminders & Alerts:** Personalized notifications for document renewals and service deadlines.

---

## 💎 Premium Experience (Pro)

Upgrade to **Fayda Connect Pro** for the ultimate digital assistance:
- **Priority Assistance:** Priority support and personalized guidance.
- **Advanced AI Tools:** AI photo validation for passport/ID standards.
- **Ad-Free Interface:** A clean, focused experience.
- **Multi-Family Profiles:** Manage IDs and services for your entire household in one place.

---

## 🛠 Tech Stack

- **Frontend:** [Flutter](https://flutter.dev) (Dart) - Premium UI with Glassmorphism and Responsive Design.
- **Backend:** [Firebase](https://firebase.google.com) (Firestore, Cloud Functions, Auth).
- **State Management:** Riverpod.
- **AI/ML:** Google ML Kit for OCR and Face Detection.
- **Database:** Hive & SQLite for secure offline storage.
- **Localization:** Support for **Amharic (አማርኛ), Afan Oromo, Tigrinya (ትግርኛ), and English.**

---

## 📂 Project Structure

```text
lib/
├── models/         # Domain models (User, Service, Order, Bank)
├── providers/      # Riverpod state management & business logic
├── screens/        # Feature-rich UI Modules (Auth, Home, Vault, Scanner)
├── services/       # Core infrastructure (Firebase, API, Biometrics)
├── theme/          # Design system, colors, and global localization
├── utils/          # Responsive utilities and helper functions
├── widgets/        # Premium custom UI components (GlassCards, Spinners)
└── main.dart       # Application entry point
```

---

## 🔧 Installation & Setup

Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Nehimi/Fayda-Connect.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd Fayda-Connect
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Setup Firebase:**
   - Create a project on [Firebase Console](https://console.firebase.google.com/).
   - Add Android/iOS apps and download `google-services.json` and `GoogleService-Info.plist`.
   - Place them in the respective platform directories.

5. **Run the app:**
   ```bash
   flutter run
   ```

---

## ⚖️ Compliance & Disclaimer

**Fayda Connect** is an **Independent Service Provider**. 
- We are **NOT** affiliated with the National ID Program (NID) of Ethiopia or any government entity.
- Our platform provides assistance, guides, and tools to help users utilize their IDs more effectively.
- All official processing is conducted through authorized government and bank channels.

---

## 🤝 Support

For support, please contact us via:
- **Telegram:** [@Nehimi_Tech](https://t.me/Nehimi_Tech)
- **Email:** support@faydaconnect.com

---

Managed with ❤️ by **Nehimi Tech** | *Simplifying the Digital Future of Ethiopia.*