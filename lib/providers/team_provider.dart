import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/team_model.dart';
import '../data/models/player_model.dart';
import '../core/constants.dart';
import 'player_provider.dart';

part 'team_provider.g.dart';

/// Notifier responsible for managing the state of generated teams.
/// Handles team generation logic, player distribution, and clearing teams.
@Riverpod(keepAlive: true)
class TeamNotifier extends _$TeamNotifier {
  @override
  List<Team> build() {
    if (kDebugMode) {
      print('TeamNotifier: INITIALIZING state (build)');
    }
    return [];
  }

  /// Generates [numTeams] random teams and distributes all players from PlayerProvider.
  ///
  /// Each team is assigned random colors (2 or 3), an adjective/animal name, and a pattern.
  /// If players list is empty or [numTeams] is less than 1, operation is aborted.
  void generateTeams(int numTeams) {
    final players = ref.read(playerNotifierProvider);

    if (kDebugMode) {
      print(
        'TeamNotifier: START generation. Players: ${players.length}, Teams requested: $numTeams',
      );
    }

    if (players.isEmpty || numTeams <= 0) {
      if (kDebugMode) {
        print(
          'TeamNotifier: ABORT. Reason: ${players.isEmpty ? "Empty player list" : "Invalid numTeams ($numTeams)"}',
        );
      }
      return;
    }

    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);

    // Create empty buckets for players
    final List<List<Player>> playerBuckets = List.generate(numTeams, (_) => []);

    // Distribute players into buckets
    for (var i = 0; i < shuffledPlayers.length; i++) {
      playerBuckets[i % numTeams].add(shuffledPlayers[i]);
    }

    final locale = ui.PlatformDispatcher.instance.locale.languageCode;
    final lang = (locale == 'it') ? 'it' : 'en';
    
    // Copy and shuffle available words to ensure no repetition within the same session
    final List<String> availableAdjectives = List<String>.from(TeamConstants.adjectives[lang]!)..shuffle(random);
    final List<String> availableNouns = List<String>.from(TeamConstants.nouns[lang]!)..shuffle(random);

    // Now build the Team objects using the buckets
    final List<Team> newTeams = [];
    for (var i = 0; i < numTeams; i++) {
      // Determine if team will have 2 or 3 colors
      final numColors = random.nextBool() ? 2 : 3;
      final List<String> teamColors = [];
      
      while (teamColors.length < numColors) {
        final color = TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
        if (!teamColors.contains(color)) {
          teamColors.add(color);
        }
      }

      String name;
      // Pick a unique adjective and noun pair if available
      if (availableAdjectives.isNotEmpty && availableNouns.isNotEmpty) {
        final adj = availableAdjectives.removeAt(0);
        final noun = availableNouns.removeAt(0);
        
        if (lang == 'it') {
          name = '${_capitalize(noun)} ${_capitalize(adj)}';
        } else {
          name = '${_capitalize(adj)} ${_capitalize(noun)}';
        }
      } else {
        // Fallback in the extremely rare case we run out of words
        final adj = TeamConstants.adjectives[lang]![random.nextInt(TeamConstants.adjectives[lang]!.length)];
        final noun = TeamConstants.nouns[lang]![random.nextInt(TeamConstants.nouns[lang]!.length)];
        name = (lang == 'it') ? '${_capitalize(noun)} ${_capitalize(adj)}' : '${_capitalize(adj)} ${_capitalize(noun)}';
      }

      final pattern =
          TeamConstants.patterns[random.nextInt(TeamConstants.patterns.length)];

      if (kDebugMode) {
        print(
          'TeamNotifier: Building team "$name" with ${playerBuckets[i].length} players and ${teamColors.length} colors',
        );
      }

      newTeams.add(Team(
        id: 'team-$i',
        name: name,
        colors: teamColors,
        pattern: pattern,
        players: playerBuckets[i],
      ));
    }

    if (kDebugMode) {
      print('TeamNotifier: FINISH. Total teams generated: ${newTeams.length}');
    }

    state = newTeams;
  }

  /// Resets the team list to an empty state.
  void clearTeams() {
    if (kDebugMode) {
      print('TeamNotifier: Clearing all teams');
    }
    state = [];
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
