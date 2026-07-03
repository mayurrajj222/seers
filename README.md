# Dall — Peer Support & Library for New Fathers

Dall (also referred to as `seers` / `bookifie`) is a clean, minimal, and premium Flutter application designed specifically to support first-time fathers navigating the complex emotions, challenges, and milestones of early parenthood. Built with a focus on editorial aesthetics, typography, and interactive micro-animations.

---

## 📱 Features

### 1. **Personalized Dashboard (Home)**
- Dynamically adapts based on the user's active state (Normal, Onboarding, Check-In Completed, or Offline Simulation).
- Features a warm greeting hero utilizing a mixture of elegant serif, script, and sans-serif typography.

### 2. **Daily Check-In & Reflection**
- Interactive mood selector featuring tactile, responsive states (Calm, Energized, Excited, Tired, Overwhelmed).
- Journal entry log allowing fathers to note down daily challenges, sleep status, and thoughts.
- Submitting your check-in dynamically updates the application's overall state and displays beautiful micro-interactions.

### 3. **Dads Community Forum**
- A dedicated, secure community feed to read and share experiences with other fathers.
- Categories filter (All, Sleep, Relationships, First-Time) to quickly find relevant discussions.
- Interactive posting system allowing you to ask questions or share tips directly to the feed in real-time.
- Interactive "like" counts on posts.

### 4. **Dall Library & Resource Center**
- Premium collection of curated guides, articles, and peer support recordings (e.g., *The First Sleepless Month*, *You Can Love It and Still Struggle*).
- Interactive, full-screen reading overlay that opens smooth modal sheets for reading content without losing your page context.
- Segmented category navigation (Sleep, Relationships, Guides, First-Time).
- Clear indicators for Paid vs. Free/Community resources.

### 5. **Robust State & Demo Controller**
- **Offline Banner Simulation**: Simulates lost network connectivity with a beautiful low-contrast warning banner (responsive across the app).
- **Demo Reset Option**: Easily reset the application's state back to the onboarding phase to show or test the first-time user experience.
- **Preference Toggles**: Quick adjustments for daily reflection reminders and local settings.

---

## 🎨 Design System & Aesthetics
Dall is crafted using high-end, contemporary design guidelines:
- **Typography (Google Fonts)**:
  - `Newsreader`: Used for sophisticated serif headings, article titles, and card overlays.
  - `Caveat`: Hand-written cursive script for warm, comforting subtitles.
  - `Work Sans`: Standard geometric sans-serif for highly readable body copy, UI controls, and micro-text.
- **Color Palette**:
  - `Background`: Soft, non-glare off-white (`#F5F5F3`)
  - `Accent Gold`: Sophisticated deep gold (`#DCA037`)
  - `Text Primary`: Deep near-black charcoal (`#1E1E1E`)
  - `Text Secondary`: Warm muted gray (`#757470`)

---

## 🚀 Getting Started

### Prerequisites
Make sure you have Flutter installed on your machine.
- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.0.0`

### Setup Instructions
1. Clone this repository:
   ```bash
   git clone https://github.com/mayurrajj222/seers.git
   cd seers
   ```
2. Fetch package dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application locally (Edge, Android, or iOS):
   ```bash
   flutter run
   ```

---

## 📂 Directory Layout
```
lib/
├── main.dart                 # Application entrypoint & Theme setup
├── screens/
│   └── home_screen.dart      # Central Hub (Home, Check-In, Community, Library, Settings)
├── theme/
│   └── design_system.dart    # Shared colors, text styles, and Google Fonts config
└── widgets/
    ├── custom_bottom_nav.dart # Custom aesthetic navigation bar
    └── state_selector.dart    # Floating floating-action selector for demo states
```
