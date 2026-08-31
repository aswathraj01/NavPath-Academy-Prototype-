# NavPath Academy — Developer Evaluation Submission

A full-stack prototype for **NavPath Academy** — India's dedicated IMU CET & Merchant Navy exam preparation platform.

This submission covers: **Working Web Prototype** · **Mobile App Prototype** · **Technical Documentation** · **ASO Strategy** · **App Store Content**

---

## Repository Structure

```
NavPath-Academy-Prototype-/
├── Web/                          # Django web platform (full-stack prototype)
│   ├── core/                     # Public pages, notifications, support
│   ├── courses/                  # Course catalog, lessons, mock tests, study materials
│   ├── enrollments/              # Enrollment logic, checkout
│   ├── users/                    # Auth, dashboard, profile, settings
│   └── templates/                # All HTML templates
│
├── frontend/navpath_academy/     # Flutter mobile app prototype
│   └── lib/screens/              # 14 screens covering full student journey
│
├── NavPath_Academy_Web_Technical_Documentation.md   # Web platform (Section 8)
├── NavPath_Academy_Technical_Documentation.md       # Mobile app concept (Sections 3 & 8)
├── ASO_Documentation.md                             # ASO strategy + app listing fields A–K (Sections 5, 6, 7)
├── App_Store_Content.md                             # Play Store copy & submission fields
└── render.yaml                                      # Deployment config (Render)
```

---

## Web Prototype (Django)

A **functional full-stack Django web application** connected to a Supabase PostgreSQL database.

**Key Features (all implemented with real DB persistence):**
- User registration, login, logout (session-based)
- Course catalog with category filtering & search
- Course detail with lesson list and enrolment status
- Enrolment & checkout flow
- Video lesson player with lesson completion tracking
- Progress percentage updated in real-time
- Interactive mock tests with scoring & result history
- Study materials per course
- Notifications, Support tickets, Messages, Settings, Profile edit
- Django Admin panel for full content management
- `seed_data` management command for fresh-install setup

**To run locally:**
```bash
cd Web
pip install -r requirements.txt
python manage.py migrate
python manage.py seed_data   # populates courses, lessons, questions
python manage.py runserver
```

**To deploy (Render):** Push to GitHub → Render auto-runs build + migrate via `render.yaml`.

---

## Mobile App Prototype (Flutter)

A **high-fidelity Flutter prototype** demonstrating the full student journey on Android/iOS.

**Screens implemented:**
Dashboard · Course Catalog · Course Detail · Checkout · My Courses · Video Lesson · Study Materials · Mock Test · Test Results · Notifications · Account Settings · Edit Profile · Login

**To run:**
```bash
cd frontend/navpath_academy
flutter pub get
flutter run
```

---

## Documentation

| Document | Coverage |
|----------|----------|
| [`NavPath_Academy_Web_Technical_Documentation.md`](NavPath_Academy_Web_Technical_Documentation.md) | Django architecture, models, views, URLs, deployment, testing |
| [`NavPath_Academy_Technical_Documentation.md`](NavPath_Academy_Technical_Documentation.md) | Flutter prototype + full production mobile app concept (Learnyst, payments, DRM, FCM) |
| [`ASO_Documentation.md`](ASO_Documentation.md) | Keyword research, competitor analysis, ASO strategy, all listing fields A–K, store graphics |
| [`App_Store_Content.md`](App_Store_Content.md) | Complete Play Store submission copy (name, tagline, short/long description, all URLs) |

---

*Submission for NavPath Academy Final Developer Evaluation — 31 August 2026*