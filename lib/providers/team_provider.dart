import 'dart:math';
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
  /// Each team is assigned random colors, an adjective/animal name, and a pattern.
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

    // Now build the Team objects using the buckets
    final List<Team> newTeams = List.generate(numTeams, (i) {
      final color1 =
          TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      var color2 =
          TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      while (color1 == color2) {
        color2 =
            TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      }

      final adj = TeamConstants
          .adjectives[random.nextInt(TeamConstants.adjectives.length)];
      final animal =
          TeamConstants.animals[random.nextInt(TeamConstants.animals.length)];
      final pattern =
          TeamConstants.patterns[random.nextInt(TeamConstants.patterns.length)];

      if (kDebugMode) {
        print(
          'TeamNotifier: Building team "$adj $animal" with ${playerBuckets[i].length} players',
        );
      }

      return Team(
        id: 'team-$i',
        name: '$adj $animal',
        colors: [color1, color2],
        pattern: pattern,
        players: playerBuckets[i], // Assign the pre-filled list
      );
    });

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
}
