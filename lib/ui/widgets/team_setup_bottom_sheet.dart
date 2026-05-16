import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:random_teams_generator/core/l10n.dart';
import 'package:random_teams_generator/providers/player_provider.dart';
import 'package:random_teams_generator/providers/team_provider.dart';
import 'package:random_teams_generator/ui/screens/results_screen.dart';

class TeamSetupBottomSheet extends ConsumerStatefulWidget {
  const TeamSetupBottomSheet({super.key});

  @override
  ConsumerState<TeamSetupBottomSheet> createState() => _TeamSetupBottomSheetState();
}

class _TeamSetupBottomSheetState extends ConsumerState<TeamSetupBottomSheet> {
  int _numTeams = 2;

  @override
  Widget build(BuildContext context) {
    final playerCount = ref.watch(playerNotifierProvider).length;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            AppStrings.of().generateTeams,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            AppStrings.of().numTeamsQuestion,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Counter Widget
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CounterButton(
                  icon: LucideIcons.minus,
                  onPressed: _numTeams > 2 ? () => setState(() => _numTeams--) : null,
                ),
                Text(
                  '$_numTeams',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _CounterButton(
                  icon: LucideIcons.plus,
                  onPressed: _numTeams < playerCount ? () => setState(() => _numTeams++) : null,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            AppStrings.of().playersPerTeam(playerCount ~/ _numTeams, (playerCount / _numTeams).ceil()),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 40),
          
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(teamNotifierProvider.notifier).generateTeams(_numTeams);
                Navigator.of(context).pop(); // Close bottom sheet
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ResultsScreen()),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(AppStrings.of().generateButton, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CounterButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
