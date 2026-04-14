import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/player_provider.dart';
import '../widgets/team_setup_bottom_sheet.dart';

class PlayerManagementScreen extends ConsumerStatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  ConsumerState<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends ConsumerState<PlayerManagementScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _addPlayer() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      try {
        ref.read(playerNotifierProvider.notifier).addPlayer(name);
        _controller.clear();
        HapticFeedback.mediumImpact();
      } catch (e) {
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
      appBar: AppBar(
        title: const Text('Giocatori'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Aggiungi un giocatore...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addPlayer,
                  icon: const Icon(LucideIcons.plus),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Player List
          Expanded(
            child: players.isEmpty
                ? _buildEmptyState()
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: players.length,
                    onReorder: (oldIndex, newIndex) {
                      ref.read(playerNotifierProvider.notifier).reorderPlayers(oldIndex, newIndex);
                      HapticFeedback.selectionClick();
                    },
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return _PlayerTile(
                        key: ValueKey(player.id),
                        player: player,
                        onDelete: () => ref.read(playerNotifierProvider.notifier).removePlayer(player.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: players.length >= 2
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const TeamSetupBottomSheet(),
                    );
                  },
                  label: const Text('Genera Squadre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  icon: const Icon(LucideIcons.play),
                ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _focusNode.requestFocus(),
            child: Container(
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
            ).animate(onPlay: (controller) => controller.repeat())
             .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1), curve: Curves.easeInOut)
             .then()
             .scale(duration: 1.seconds, begin: const Offset(1.1, 1.1), end: const Offset(1, 1), curve: Curves.easeInOut),
          ),
          const SizedBox(height: 24),
          Text(
            'Nessun giocatore',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Tocca il pulsante o usa il campo di testo in alto per aggiungere il tuo primo giocatore!',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.4),
            ),
          ),
        ],
      ).animate().fadeIn().moveY(begin: 20, end: 0),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final dynamic player;
  final VoidCallback onDelete;

  const _PlayerTile({
    super.key,
    required this.player,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(LucideIcons.gripVertical, color: Colors.grey),
        title: Text(
          player.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            onDelete();
          },
          icon: const Icon(LucideIcons.trash2, color: Colors.red),
        ),
      ),
    );
  }
}
