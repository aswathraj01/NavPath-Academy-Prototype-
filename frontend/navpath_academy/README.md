# NavPath Academy — Mobile App Prototype 🚢⚓

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-V1_Prototype-success.svg?style=for-the-badge)

NavPath Academy is a mobile application prototype designed for aspiring Merchant Navy candidates preparing for the IMU CET (Indian Maritime University Common Entrance Test). 

This repository contains the V1 Flutter prototype, a pixel-perfect conversion of the original Figma UI design into a fully interactive, mobile-responsive Flutter application.

## 📱 Features & Screens Implemented

The application currently features a complete UI navigation flow containing **12 fully implemented screens**:

- **Authentication:** Login Screen with simple validation UI.
- **Main Shell:** Custom `NavScaffold` implementing a standard bottom navigation bar with 4 main tabs (Home, Courses, My Courses, Profile).
- **Dashboard (Home):** Welcome cards, progress stat trackers, and recommended courses.
- **Courses:** Scrollable course discovery list with filtering chips.
- **Course Details:** Rich course overview page featuring curriculum lists, syllabus, and dynamic enrollment CTAs.
- **Checkout:** Mock payment selection flow and billing details summary.
- **My Courses:** Enrolled courses list displaying progress bars and completion percentages (updates dynamically upon mock enrollment).
- **Video Lesson:** Video player placeholder with tabs for Overview, Notes, Discussions, and Downloads.
- **Study Materials:** List of downloadable PDFs and presentation slides.
- **Mock Test:** Interactive Multiple Choice Question (MCQ) UI featuring progress bars and timers.
- **Test Results:** Post-test score summary highlighting correct/incorrect answers.
- **Profile / Settings:** Account settings options and an editable user profile form.

## 🎨 Design System

The app relies heavily on a centralized design system located in `lib/theme/app_theme.dart` to maintain consistency:
* **Primary Color:** `#0A2463` (Navy Blue)
* **Background Color:** `#F5F7FA`
* **Typography:** `Inter` (via Google Fonts)

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (Latest stable version)
* Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/aswathraj01/NavPath-Academy-Prototype-.git
```
2. Navigate to the project directory:
```bash
cd NavPath-Academy-Prototype-/frontend/navpath_academy
```
3. Fetch dependencies:
```bash
flutter pub get
```
4. Run the app:
```bash
flutter run
```
*(Note for Windows users: If building with plugins on Windows, ensure Developer Mode is enabled via `ms-settings:developers` to allow symlink creation.)*

## 📁 Project Structure

```text
lib/
├── main.dart                  # App entry point
├── models/                    # Data models (Course, Lesson, MockQuestion)
├── screens/                   # All 12 UI screens
├── state/                     # Lightweight ValueNotifier state (e.g., EnrollmentState)
├── theme/                     # Centralized design tokens and ThemeData
└── widgets/                   # Reusable components (Cards, Bottom Nav)
```
