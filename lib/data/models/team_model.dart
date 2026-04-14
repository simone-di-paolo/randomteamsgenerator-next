import 'player_model.dart';
import 'package:uuid/uuid.dart';

enum TeamPattern { vertical, horizontal, diagonal }

class Team {
  final String id;
  final String name;
  final List<Player> players;
  final List<String> colors; // Typically 2 colors
  final TeamPattern pattern;

  Team({
    String? id,
    required this.name,
    required this.players,
    required this.colors,
    required this.pattern,
  }) : id = id ?? const Uuid().v4();

  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
    List<String>? colors,
    TeamPattern? pattern,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      colors: colors ?? this.colors,
      pattern: pattern ?? this.pattern,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'players': players.map((x) => x.toMap()).toList(),
      'colors': colors,
      'pattern': pattern.name,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      name: map['name'] as String,
      players: List<Player>.from(
        (map['players'] as List).map<Player>(
          (x) => Player.fromMap(x as Map<String, dynamic>),
        ),
      ),
      colors: List<String>.from(map['colors'] as List),
      pattern: TeamPattern.values.byName(map['pattern'] as String),
    );
  }
}
