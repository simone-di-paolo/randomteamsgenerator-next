# Porting Plan: React to Flutter (Random Teams Generator)

This document outlines the strategy for migrating the Random Teams Generator application from the existing React (Vite/TypeScript) codebase to a new Flutter implementation.

## 1. Feature Mapping

| Feature | React Implementation | Flutter Equivalent | Status |
| :--- | :--- | :--- | :--- |
| **State Management** | `Zustand` (TeamStore) | `Riverpod` | In Progress |
| **Player Management** | `players` state, add/remove/reorder | `PlayerNotifier` (Riverpod) | Not Started |
| **Team Generation** | `generateTeams` logic | `TeamGeneratorService` | Not Started |
| **Persistence (Auth)** | `firebase/auth` | `firebase_auth` | Not Started |
| **Persistence (Store)** | `firestore` | `cloud_firestore` / `drift` (Local) | Not Started |
| **UI Design System** | Material You (Custom CSS) | `ThemeData` (M3) | In Progress |
| **Animations** | `framer-motion` | `flutter_animate`, `Hero`, `Implicit` | Not Started |
| **Icons** | `lucide-react` | `lucide_icons` (pub.dev) | In Progress |
| **Drag & Drop** | `@hello-pangea/dnd` | `ReorderableListView` / `reorderables` | Not Started |
| **Sharing** | `navigator.share` | `share_plus` | Not Started |
| **Feedback/Haptics** | `navigator.vibrate` | `HapticFeedback` (Flutter) | Not Started |

## 2. Technical Stack (Flutter)

- **Framework**: Flutter (Material 3)
- **State Management**: Riverpod (v2.x with Code Generation)
- **Local Persistence**: Drift (SQLite) or Hive/SharedPrefs (User settings)
- **Remote Persistence**: Firebase (Firestore & Auth)
- **Navigation**: `GoRouter` or native `Navigator`
- **UI Components**: `CustomPainter` for flags, `BottomSheet`, `GoogleFonts` (Outfit)

## 3. Implementation Phases

### Phase 1: Setup & Data Layer
- [x] Add missing dependencies to `pubspec.yaml`
- [x] Initialize Project Structure
- [x] Define Data Models (`Player`, `Team`)
- [x] Implement `PlayerProvider` (Add, Remove, Reorder)
- [x] Implement `TeamGenerationProvider` (Logic for shuffling and grouping)

### Phase 2: Core UI Screens
- [x] **Home Screen**: Main entry point with clear CTA.
- [x] **Player Management**: List of players with drag-to-reorder.
- [x] **Team Setup**: BottomSheet to configure number of teams.
- [x] **Results Screen**: Carousel or Grid of teams with colors/flags.

### Phase 3: Advanced Features
- [ ] **History**: Fetch and display saved sessions from Firestore. (Requires Firebase Setup)
- [ ] **Authentication**: Login/Logout flow. (Requires Firebase Setup)
- [x] **Settings**: Dark mode toggle, Clear all, About/Info.
- [x] **Sharing**: Export team lists as text.

### Phase 4: Polish & Refinement
- [x] Add transitions between screens.
- [x] Implement haptic feedback for actions.
- [x] Visual polish for Team Flags (Patterns: vertical, horizontal, diagonal).
- [ ] Rating BottomSheet logic.

## 4. Current Progress
- Analyzed React codebase (`src/App.tsx`).
- Updated `pubspec.yaml` with required dependencies.
- Implemented core models and Riverpod state management.
- Built the entire UI flow from Home to Results.
- Added animations and haptic feedback.
