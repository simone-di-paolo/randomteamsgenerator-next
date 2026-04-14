# Project Coding Guidelines & AI Instructions

This file contains specific directives for AI assistance (Antigravity) and development standards for the **Random Teams Generator** project.

## 1. UI Structure & Comments
- **Directive**: Every significant UI element (Widgets like `Column`, `Row`, `ListView`, `Container`, etc.) must end with a trailing comment in English indicating what it's closing and providing a brief context (e.g., section name).
- **Example**:
  ```dart
  Column(
    children: [
      Text('Hello'),
      Icon(Icons.add),
    ],
  ), // end of Column (Greetings section)
  ```

## 2. Documentation Standards
- **Directive**: Every function, method, and class must be preceded by a Dart documentation comment (`///`).
- **Required Info**: Briefly explain purpose, parameters (if not obvious), and return values.
- **Example**:
  ```dart
  /// Generates a list of random teams based on the provided [numTeams].
  /// Distributes players from PlayerProvider across these teams.
  void generateTeams(int numTeams) { ... }
  ```

## 3. Logging & Debugging
- **Directive**: Include descriptive logs at key steps of the logic (functional and non-functional).
- **Production Safety**: Use `debugPrint()` or wrap logs in a check for `kDebugMode` to ensure they don't affect performance or security in production.
- **Example Pattern**:
  ```dart
  import 'package:flutter/foundation.dart';
  
  if (kDebugMode) {
    print('TeamNotifier: Generating $numTeams teams for ${players.length} players');
  }
  ```

## 4. State Management (Riverpod)
- Use `@riverpod` annotation for code generation.
- Keep logic inside Notifiers and keep UI as thin as possible (`ConsumerWidget`).

## 5. Rich Aesthetics
- Always prioritize **Material 3** features and **Lucide Icons**.
- Use the `flutter_animate` package for micro-animations on screen transitions and card loading.
