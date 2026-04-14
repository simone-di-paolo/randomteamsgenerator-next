import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:random_teams_generator/providers/player_provider.dart';
import 'package:random_teams_generator/ui/widgets/team_setup_bottom_sheet.dart';
import 'package:random_teams_generator/data/models/player_model.dart';

class PlayerManagementScreen extends ConsumerStatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  ConsumerState<PlayerManagementScreen> createState() =>
      _PlayerManagementScreenState();
}

class _PlayerManagementScreenState
    extends ConsumerState<PlayerManagementScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// Appends a new player to the list if the name is valid and doesn't exist.
  void _addPlayer() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      if (kDebugMode) {
        print('PlayerManagementScreen: Adding player "$name"');
      }
      try {
        ref.read(playerNotifierProvider.notifier).addPlayer(name);
        _controller.clear();
        _focusNode.requestFocus(); // Re-focus after adding
        HapticFeedback.lightImpact();
      } catch (e) {
        if (kDebugMode) {
          print('PlayerManagementScreen: Error adding player - $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playerNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Gestisci Giocatori'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ), // end of AppBar (Management Header)
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true, // Auto-open keyboard on entry
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addPlayer(), // Add player on Enter key
                    decoration: InputDecoration(
                      hintText: 'Nome giocatore...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ), // end of TextField (Player Name Input)
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addPlayer,
                  icon: const Icon(LucideIcons.plus),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ), // end of IconButton (Add Player button)
              ],
            ), // end of Row (Input Container)
          ), // end of Padding (Input Section)

          // Player List
          Expanded(
            child: players.isEmpty
                ? const _EmptyStateView()
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: players.length,
                    onReorder: (oldIndex, newIndex) {
                      if (kDebugMode) {
                        print('PlayerManagementScreen: Reordering players from $oldIndex to $newIndex');
                      }
                      ref
                          .read(playerNotifierProvider.notifier)
                          .reorderPlayers(oldIndex, newIndex);
                      HapticFeedback.selectionClick();
                    },
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return _PlayerTile(
                        key: ValueKey(player.id),
                        player: player,
                        onDelete: () {
                          if (kDebugMode) {
                            print('PlayerManagementScreen: Deleting player ${player.name}');
                          }
                          ref
                            .read(playerNotifierProvider.notifier)
                            .removePlayer(player.id);
                        },
                      );
                    },
                  ), // end of ReorderableListView.builder
          ), // end of Expanded (List Container)
        ],
      ), // end of Column (Main Content)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: players.length >= 3
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (kDebugMode) {
                      print('PlayerManagementScreen: Proceeding to Team Setup');
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const TeamSetupBottomSheet(),
                    );
                  },
                  label: const Text(
                    'Genera Squadre',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(LucideIcons.play),
                ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack), // end of FloatingActionButton.extended
              ), // end of SizedBox
            ) // end of Padding (FAB Container)
          : null,
    ); // end of Scaffold (Management root)
  }
}

/// View displayed when the player list is empty.
class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Re-focus the input if user taps on the empty icon
            FocusScope.of(context).requestFocus(FocusNode()); 
          },
          child:
              Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.plus,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 1.seconds,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 1.seconds,
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1, 1),
                    curve: Curves.easeInOut,
                  ),
        ), // end of GestureDetector
        const SizedBox(height: 24),
        Text(
          'Aggiungi Giocatori',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ), // end of Text (Empty State title)
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Inserisci i nomi per iniziare a creare le squadre.',
            textAlign: TextAlign.center,
          ), // end of Text (Empty State description)
        ),
      ],
    ); // end of Column (Empty State)
  }
}

/// A single player tile with reorder handle and delete action.
class _PlayerTile extends StatelessWidget {
  final dynamic player;
  final VoidCallback onDelete;

  const _PlayerTile({super.key, required this.player, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(LucideIcons.gripVertical, size: 20),
        title: Text(
          player.name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(LucideIcons.trash2, size: 20, color: Colors.redAccent),
        ),
      ), // end of ListTile
    ); // end of Card (Player Tile)
  }
}
