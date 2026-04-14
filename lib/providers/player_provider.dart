import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/player_model.dart';

part 'player_provider.g.dart';

@Riverpod(keepAlive: true)
class PlayerNotifier extends _$PlayerNotifier {
  @override
  List<Player> build() {
    return [];
  }

  void addPlayer(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    
    if (state.any((p) => p.name.toLowerCase() == trimmedName.toLowerCase())) {
      throw Exception('Player already exists');
    }
    
    state = [...state, Player(name: trimmedName)];
  }

  void removePlayer(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void reorderPlayers(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<Player> items = List.from(state);
    final Player item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = items;
  }

  void clearPlayers() {
    state = [];
  }
}
