# LingoBreeze 🌬️

A language-learning vocabulary app built with **Flutter**, **Node.js**, and **Firebase**.

Users can save vocabulary words they want to learn and view their saved words in a polished, modern interface.

---

## 📁 Project Structure

```
LingoBreeze/
├── flutter-app/          # Flutter mobile app
│   └── lib/
│       ├── core/         # Theme, constants, reusable widgets
│       └── features/
│           └── vocabulary/
│               ├── data/           # Models, datasources, repository
│               ├── domain/         # Entities (business objects)
│               └── presentation/   # Screens, widgets, providers
├── backend/              # Node.js Express API
│   ├── server.js         # GET /words endpoint
│   └── package.json
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter 3.32+ (Dart 3.8+) |
| State Management | Riverpod (AsyncNotifier) |
| Backend API | Node.js + Express |
| Database | Firebase Cloud Firestore |
| UI Design | Material 3, Glassmorphism, Google Fonts |

---

## 🏗️ Architecture

### Flutter App – Clean Architecture

```
Domain Layer    → Pure entities (Word)
Data Layer      → Models, Datasources (API + Firestore), Repository
Presentation    → Screens, Widgets, Riverpod Providers
```

### Data Flow

1. **Read words**: Flutter → Node.js API (`GET /words`) → Firestore → Response
2. **Add word**: Flutter → Firestore directly (via `cloud_firestore` SDK)
3. **Fallback**: If the API is unreachable, the app falls back to reading directly from Firestore

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.32+
- Node.js 18+
- A Firebase project with Firestore enabled

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Add your Firebase service account key
# Download from: Firebase Console → Project Settings → Service Accounts → Generate New Private Key
# Save as: backend/serviceAccountKey.json

# Start the server
npm start
```

The API will be available at `http://localhost:3000`.

### Flutter App Setup

```bash
cd flutter-app

# Install dependencies
flutter pub get

# Configure Firebase (requires FlutterFire CLI)
# npm install -g firebase-tools
# dart pub global activate flutterfire_cli
# flutterfire configure

# Run the app
flutter run
```

### API Configuration

Update the API base URL in `flutter-app/lib/core/constants/api_constants.dart`:

```dart
// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:3000';

// For iOS Simulator / Web:
static const String baseUrl = 'http://localhost:3000';

// For physical device (use your machine's IP):
static const String baseUrl = 'http://192.168.x.x:3000';
```

---

## 📡 API Endpoints

### GET /words

Retrieve all vocabulary words sorted by creation date (newest first).

**Response:**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "id": "abc123",
      "word": "Apple",
      "meaning": "A fruit",
      "translation": "Manzana",
      "createdAt": "2026-06-07T12:00:00.000Z"
    }
  ]
}
```

### GET /

Health check endpoint.

---

## ✨ Features

- **Create**: Add vocabulary words via a polished modal bottom sheet
- **Read**: View all saved words in an animated list
- **Loading State**: Shimmer skeleton loading animation
- **Empty State**: Friendly illustration with animated CTA
- **Error State**: Clear error message with retry button
- **Pull-to-Refresh**: Refresh the word list with a pull gesture
- **Delete**: Remove words with confirmation dialog

---

## 🎨 Design

- **Dark Theme**: Deep indigo-to-purple gradient backgrounds
- **Glassmorphism**: Frosted glass card effects with subtle borders
- **Animations**: Staggered slide-in for cards, elastic scale for FAB
- **Typography**: Outfit (headings) + Inter (body) from Google Fonts
- **Color Palette**: Teal/cyan accents on dark backgrounds

---

## 🤖 AI Contribution Estimate

```
UI/UX Design & Implementation:  75%
Backend API:                     60%
Architecture & State Management: Manual design, AI-assisted implementation
Firebase Integration:            50%
Code Organization:               Manual
```

---

## 📋 Evaluation

| Area | Implementation |
|------|---------------|
| UI/UX Quality | Premium dark theme with glassmorphism, animations, and Material 3 |
| Flutter Code Quality | Clean architecture, Riverpod state management, reusable widgets |
| Firebase Integration | Cloud Firestore for storage, direct SDK for writes |
| Node.js API Quality | Express with proper error handling, CORS, health check |
