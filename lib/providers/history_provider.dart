import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/team_model.dart';
import 'database_provider.dart';

part 'history_provider.g.dart';

/// Data class representing a saved session of teams.
class TeamGenerationSession {
  final int id;
  final List<Team> teams;
  final DateTime createdAt;

  TeamGenerationSession({
    required this.id,
    required this.teams,
    required this.createdAt,
  });
}

/// Notifier that manages the history of generated teams stored in the local DB.
@Riverpod(keepAlive: true)
class HistoryNotifier extends _$HistoryNotifier {
  @override
  Future<List<TeamGenerationSession>> build() async {
    final db = ref.watch(databaseProvider);
    final records = await db.getAllGenerations();
    
    if (kDebugMode) {
      print('HistoryNotifier: Loaded ${records.length} saved sessions');
    }

    return records.map((record) {
      final List<dynamic> jsonList = jsonDecode(record.teamsJson);
      final teams = jsonList.map((item) => Team.fromMap(item as Map<String, dynamic>)).toList();
      return TeamGenerationSession(
        id: record.id,
        teams: teams,
        createdAt: record.createdAt,
      );
    }).toList();
  }

  /// Adds a new generation to the history.
  Future<void> saveSession(List<Team> teams) async {
    final db = ref.read(databaseProvider);
    final teamsJson = jsonEncode(teams.map((t) => t.toMap()).toList());
    
    await db.saveGeneration(teamsJson);
    if (kDebugMode) {
      print('HistoryNotifier: Session saved successfully');
    }
    
    // Refresh the list
    ref.invalidateSelf();
  }

  /// Removes a session from history.
  Future<void> deleteSession(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteGeneration(id);
    if (kDebugMode) {
      print('HistoryNotifier: Session $id deleted');
    }
    
    // Refresh the list
    ref.invalidateSelf();
  }
}
