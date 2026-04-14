import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/team_model.dart';
import '../data/models/player_model.dart';
import '../core/constants.dart';
import 'player_provider.dart';

part 'team_provider.g.dart';

@riverpod
class TeamNotifier extends _$TeamNotifier {
  @override
  List<Team> build() {
    return [];
  }

  void generateTeams(int numTeams) {
    final players = ref.read(playerNotifierProvider);
    if (players.isEmpty || numTeams <= 0) return;

    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    
    final List<Team> newTeams = List.generate(numTeams, (i) {
      final color1 = TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      var color2 = TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      while (color1 == color2) {
        color2 = TeamConstants.colors[random.nextInt(TeamConstants.colors.length)];
      }

      final adj = TeamConstants.adjectives[random.nextInt(TeamConstants.adjectives.length)];
      final animal = TeamConstants.animals[random.nextInt(TeamConstants.animals.length)];
      final pattern = TeamConstants.patterns[random.nextInt(TeamConstants.patterns.length)];

      return Team(
        id: 'team-$i',
        name: '$adj $animal',
        colors: [color1, color2],
        pattern: pattern,
        players: [],
      );
    });

    for (var i = 0; i < shuffledPlayers.length; i++) {
      newTeams[i % numTeams].players.add(shuffledPlayers[i]);
    }

    state = newTeams;
  }

  void clearTeams() {
    state = [];
  }
}
