<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Status-V1_Prototype-success?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge" alt="Platforms" />

  <h1>NavPath Academy ⚓</h1>
  <p><em>Chart your course to a career at sea.</em></p>
  <p>A comprehensive mobile application prototype designed for aspiring Merchant Navy candidates preparing for the IMU CET.</p>
</div>

---

## 📖 About The Project

NavPath Academy is an interactive UI prototype built entirely with **Flutter**. It transforms a high-fidelity Figma design into a pixel-perfect, responsive mobile application. The app showcases the complete student journey—from course discovery to interactive mock tests and enrollment flows.

This repository serves as the foundational UI architecture for the NavPath Academy platform.

## ✨ Key Features & UI Flows

The V1 prototype includes **12 fully implemented screens**, wired together with mock state management to provide a realistic app feel:

* 🔐 **Authentication:** Clean login flow for returning users.
* 🏠 **Dashboard:** Welcome overview featuring daily streaks, overall progress, and personalized course recommendations.
* 📚 **Course Discovery:** Scrollable course catalogs with dynamic category filter chips.
* 🎓 **Course Details:** Deep-dive curriculum views outlining video lessons, mock tests, and downloadable resources.
* 💳 **Seamless Checkout:** Integrated mock payment gateway UI (UPI, Cards, Net Banking) with real-time UI state updates (changes "Enrol now" to "Go to course").
* 🎒 **My Courses:** Dedicated library for enrolled courses, tracking lesson completion and percentage progress.
* 🎬 **Video Learning:** Interactive lesson interface with tabbed sections for Notes, Discussions, and Downloads.
* 📝 **Mock Testing Engine:** MCQ-style quiz interface featuring active timers, animated option selections, and live progress bars.
* 📊 **Test Results:** Comprehensive post-test analytics showing scores, correct/incorrect metrics, and detailed answer reviews.
* ⚙️ **Account Management:** User profile editing and global application settings.

## 🎨 Design System

The application is built on a robust, centralized design token system (`app_theme.dart`) to ensure visual consistency:

| Token | Hex Code | Usage |
| :--- | :--- | :--- |
| **Primary** | `#0A2463` | AppBars, prominent CTA buttons, primary text highlights |
| **Accent** | `#1E3FBF` | Text buttons, active states, wishlist links |
| **Background** | `#F5F7FA` | Global scaffold background |
| **Surface** | `#FFFFFF` | Elevated cards, bottom navigation, input fields |
| **Success** | `#10B981` | "FREE" badges, correct test answers, enrollment confirmation |
| **Error** | `#EF4444` | Incorrect test answers, destructive actions (Logout) |
| **Typography**| `Inter` | Primary typeface (Google Fonts) |

## 🚀 Getting Started

### Prerequisites

To run this project locally, you will need:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
* [Dart SDK](https://dart.dev/get-dart)
* Android Studio / Xcode (for device emulators)

### Installation & Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/aswathraj01/NavPath-Academy-Prototype-.git
   ```

2. **Navigate to the frontend directory**
   ```bash
   cd NavPath-Academy-Prototype-/frontend/navpath_academy
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

> ⚠️ **Note for Windows Users:** If you are building for the Windows desktop target and encounter symlink errors during the plugin build phase, please ensure **Developer Mode** is enabled in your Windows settings (`start ms-settings:developers`).

## 📁 Repository Structure

```text
📦 NavPath-Academy-Prototype-
 ┗ 📂 frontend
   ┗ 📂 navpath_academy
     ┣ 📂 lib
     ┃ ┣ 📂 models         # Core data structures (Course, Question, Material)
     ┃ ┣ 📂 screens        # All 12 primary UI views
     ┃ ┣ 📂 state          # Lightweight mock state (ValueNotifier)
     ┃ ┣ 📂 theme          # Centralized AppTheme and color palettes
     ┃ ┣ 📂 widgets        # Reusable UI components (NavScaffold, Cards)
     ┃ ┗ 📜 main.dart      # Application entry point
     ┣ 📜 pubspec.yaml     # Flutter dependencies (google_fonts, percent_indicator)
     ┗ 📜 README.md
```

## 🤝 Contributing

This is currently a prototype repository. If you'd like to contribute to the UI or integrate backend services:
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---
<div align="center">
  <i>Built with ❤️ using Flutter</i>
</div>