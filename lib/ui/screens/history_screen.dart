import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:random_teams_generator/providers/history_provider.dart';
import 'package:random_teams_generator/providers/player_provider.dart';
import 'package:random_teams_generator/ui/widgets/team_flag.dart';
import 'package:random_teams_generator/core/l10n.dart';
import 'player_management_screen.dart';

/// Screen that displays the history of generated team sessions from the local database.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(AppStrings.of().history),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ), // end of AppBar (History Header)
      body: historyAsync.when(
        data: (sessions) => sessions.isEmpty
            ? const _EmptyHistoryView()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return _HistorySessionCard(session: session);
                },
              ), // end of ListView (History Items)
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore nel caricamento: $err')),
      ), // end of historyAsync body
    ); // end of Scaffold (History root)
  }
}

/// View displayed when no history is available.
class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.history,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.of().emptyHistory,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(AppStrings.of().savedTeamsWillAppearHere),
        ],
      ), // end of Column (Empty State)
    ); // end of Center
  }
}

/// A card representing a single generation session in history.
class _HistorySessionCard extends ConsumerWidget {
  final TeamGenerationSession session;

  const _HistorySessionCard({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(session.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Icon(LucideIcons.calendar, color: Theme.of(context).colorScheme.primary),
        title: Text(
          dateStr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${session.teams.length} ${AppStrings.of().teamsGeneratedCount}'),
        trailing: IconButton(
          icon: const Icon(LucideIcons.trash2, size: 20, color: Colors.redAccent),
          onPressed: () {
            if (kDebugMode) {
              print('HistoryScreen: Deleting session ${session.id}');
            }
            ref.read(historyNotifierProvider.notifier).deleteSession(session.id);
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...session.teams.map((team) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        TeamFlag(colors: team.colors, pattern: team.pattern, width: 40, height: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                team.players.map((p) => p.name).join(', '),
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      final allPlayerNames = session.teams
                          .expand((t) => t.players)
                          .map((p) => p.name)
                          .toList();
                      
                      if (kDebugMode) {
                        print('HistoryScreen: Reusing ${allPlayerNames.length} players from session ${session.id}');
                      }
                      
                      ref.read(playerNotifierProvider.notifier).setPlayersFromNames(allPlayerNames);
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PlayerManagementScreen(),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.users),
                    label: Text(AppStrings.of().reopenPlayerManagement),
                  ),
                ), // end of FilledButton.tonalIcon (Reuse Players)
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      if (kDebugMode) {
                        print('HistoryScreen: Sharing session ${session.id}');
                      }
                      final String text = session.teams
                          .map((t) => '🏁 ${t.name}:\n${t.players.map((p) => '- ${p.name}').join('\n')}')
                          .join('\n\n');
                      Share.share(text, subject: '${AppStrings.of().shareHistorySubject} ${DateFormat('dd/MM/yyyy').format(session.createdAt)}');
                    },
                    icon: const Icon(LucideIcons.share2),
                    label: Text(AppStrings.of().shareTeams),
                  ),
                ), // end of FilledButton.tonalIcon (Share History)
              ],
            ), // end of Column (Session Team List)
          ), // end of Padding
        ],
      ), // end of ExpansionTile (Session details)
    ); // end of Card (Session container)
  }
}
