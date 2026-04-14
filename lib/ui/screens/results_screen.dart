import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:random_teams_generator/providers/team_provider.dart';
import '../widgets/team_flag.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  /// Navigates back and shares the generated teams as text.
  void _shareTeams(BuildContext context, dynamic teams) {
    if (kDebugMode) {
      print('ResultsScreen: Sharing teams text...');
    }
    final String text = teams.map((t) => '🏁 ${t.name}:\n${t.players.map((p) => '- ${p.name}').join('\n')}').join('\n\n');
    Share.share(text, subject: 'Le nostre Squadre!');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamNotifierProvider);

    if (kDebugMode) {
      print('ResultsScreen: BUILD triggered. Teams in state: ${teams.length}');
      for (var i = 0; i < teams.length; i++) {
        print(' - Team $i: ${teams[i].name} (${teams[i].players.length} players)');
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Le Squadre'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _shareTeams(context, teams);
            },
            icon: const Icon(LucideIcons.share2),
          ),
          IconButton(
            onPressed: teams.isEmpty ? null : () {
              if (kDebugMode) {
                print('ResultsScreen: Shuffle requested for ${teams.length} teams');
              }
              HapticFeedback.mediumImpact();
              ref.read(teamNotifierProvider.notifier).generateTeams(teams.length);
            },
            icon: const Icon(LucideIcons.shuffle),
          ),
          const SizedBox(width: 8),
        ],
      ), // end of AppBar (Results Header)
      body: teams.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.frown, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  const Text('Nessuna squadra generata.'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Torna indietro'),
                  ),
                ],
              ), // end of Column (Empty State messaging)
            ) // end of Center (Empty State container)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TeamFlag(colors: team.colors, pattern: team.pattern),
                            const SizedBox(width: 16),
                            Text(
                              team.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ), // end of Row (Team Header with Flag and Name)
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: team.players.map((player) {
                            return Chip(
                              label: Text(player.name),
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide.none,
                              ),
                            );
                          }).toList(),
                        ), // end of Wrap (Player List chips)
                      ],
                    ), // end of Column (Team Card structure)
                  ), // end of Padding (Card content spacing)
                ).animate().fadeIn(delay: (index * 100).ms).moveY(begin: 20, end: 0); // end of Card (Individual Team)
              },
            ), // end of ListView.builder (Main results list)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              if (kDebugMode) {
                print('ResultsScreen: Save teams clicked');
              }
              // Placeholder for Save functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Salvataggio non ancora implementato (richiede Firebase)'), behavior: SnackBarBehavior.floating),
              );
            },
            label: const Text('Salva Squadre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            icon: const Icon(LucideIcons.save),
          ), // end of FloatingActionButton.extended (Save Action)
        ), // end of SizedBox (Full Width FAB)
      ), // end of Padding (FAB bottom margin)
    ); // end of Scaffold (ResultsScreen root)
  }
}
