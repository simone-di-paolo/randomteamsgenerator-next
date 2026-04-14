import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;

  Player({
    String? id,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  Player copyWith({
    String? id,
    String? name,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
