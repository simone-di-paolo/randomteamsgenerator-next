import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:random_teams_generator/providers/player_provider.dart';
import 'package:random_teams_generator/ui/widgets/team_setup_bottom_sheet.dart';
import 'package:random_teams_generator/ui/screens/player_management_screen.dart';
import 'package:random_teams_generator/ui/screens/settings_screen.dart';

/// The main landing screen of the application.
/// Provides access to player management, settings, and team generation.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerCount = ref.watch(playerNotifierProvider).length;

    return Scaffold(
      body: Stack(
        children: [
          // Header Actions
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // History button placeholder (to be implemented with Auth)
                IconButton.filledTonal(
                  onPressed: () {
                    if (kDebugMode) {
                      print('HomeScreen: History button pressed');
                    }
                  },
                  icon: const Icon(LucideIcons.history),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    if (kDebugMode) {
                      print('HomeScreen: Navigating to Settings');
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.settings),
                ),
              ],
            ), // end of Row (Header Actions)
          ), // end of Positioned (Top Buttons)
          // Main Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  transform: Matrix4.rotationZ(0.1),
                  child: Icon(
                    LucideIcons.users,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ).animate().scale(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                ), // end of Container (App Icon)

                const SizedBox(height: 24),

                Text(
                      'Squadre Casuali',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                    )
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .moveY(begin: 10, end: 0), // end of Text (Title)

                const SizedBox(height: 8),

                Text(
                      'Equo, veloce e divertente.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .moveY(begin: 10, end: 0), // end of Text (Tagline)

                const SizedBox(height: 48),

                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      _ActionButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print(
                              'HomeScreen: Navigating to Player Management',
                            );
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PlayerManagementScreen(),
                            ),
                          );
                        },
                        icon: LucideIcons.users,
                        label: 'Gestisci Giocatori ($playerCount)',
                        isPrimary: true,
                      ), // end of _ActionButton (Manage Players)
                      const SizedBox(height: 16),
                      _ActionButton(
                        onPressed: playerCount >= 3
                            ? () {
                                if (kDebugMode) {
                                  print(
                                    'HomeScreen: Showing Team Setup BottomSheet',
                                  );
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      const TeamSetupBottomSheet(),
                                );
                              }
                            : null,
                        icon: LucideIcons.play,
                        label: 'Genera Squadre',
                        isPrimary: false,
                      ), // end of _ActionButton (Generate Teams)
                    ],
                  ), // end of Column (Action Buttons)
                ), // end of Padding (Actions Container)
              ],
            ), // end of Column (Hero Content)
          ), // end of Center (Main Landing)
        ],
      ), // end of Stack (Background + Content)
    ); // end of Scaffold (HomeScreen root)
  }
}

/// A custom stylized button for main actions in the HomeScreen.
class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: isPrimary
              ? colorScheme.primary
              : colorScheme.secondaryContainer,
          foregroundColor: isPrimary
              ? colorScheme.onPrimary
              : colorScheme.onSecondaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ), // end of FilledButton.icon
    ); // end of SizedBox (Full Width Button)
  }
}
