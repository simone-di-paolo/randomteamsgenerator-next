import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:random_teams_generator/core/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_teams_generator/providers/player_provider.dart';
import 'package:random_teams_generator/providers/theme_provider.dart';

/// Screen for managing application settings and display preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Opens the project's source code on GitHub.
  Future<void> _launchGitHub(BuildContext context) async {
    final Uri url = Uri.parse('https://github.com/simone-di-paolo/randomteamsgenerator-next');
    if (kDebugMode) {
      print('SettingsScreen: Attempting to launch $url');
    }
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nell\'apertura del link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersCount = ref.watch(playerNotifierProvider).length;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark || 
                      (themeMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of().settings),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ), // end of AppBar (Settings Header)
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: AppStrings.of().appearance),
          _SettingsTile(
            icon: LucideIcons.moon,
            title: AppStrings.of().darkMode,
            subtitle: AppStrings.of().darkModeSubtitle,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                if (kDebugMode) {
                  print('SettingsScreen: Dark mode toggled to $value');
                }
                HapticFeedback.selectionClick();
                ref.read(themeNotifierProvider.notifier).toggleTheme(value);
              },
            ),
          ), // end of _SettingsTile (Dark Mode)
          
          const SizedBox(height: 24),
          
          _SectionTitle(title: AppStrings.of().clearData),
          _SettingsTile(
            icon: LucideIcons.trash2,
            iconColor: Colors.red,
            title: AppStrings.of().clearData,
            subtitle: AppStrings.of().clearDataSubtitle,
            trailing: TextButton(
              onPressed: playersCount > 0 ? () {
                if (kDebugMode) {
                  print('SettingsScreen: Clearing all players requested');
                }
                ref.read(playerNotifierProvider.notifier).clearPlayers();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.of().clearDataSuccess), behavior: SnackBarBehavior.floating),
                );
              } : null,
              child: Text(AppStrings.of().clearDataAction, style: const TextStyle(color: Colors.red)),
            ),
          ), // end of _SettingsTile (Clear Data)
          
          const SizedBox(height: 24),
          
          _SectionTitle(title: AppStrings.of().info),
          _SettingsTile(
            icon: LucideIcons.info,
            title: 'Random Teams Generator',
            subtitle: AppStrings.of().version,
          ), // end of _SettingsTile (Version)
          
          _SettingsTile(
            icon: LucideIcons.github,
            title: AppStrings.of().sourceCode,
            subtitle: 'GitHub Repository',
            onTap: () => _launchGitHub(context),
          ), // end of _SettingsTile (GitHub)
        ],
      ), // end of ListView (Settings sections)
    ); // end of Scaffold (Settings root)
  }
}

/// Stylized section header for setting categories.
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ), // end of Text (Section Header)
    ); // end of Padding
  }
}

/// A standard list tile for each setting option.
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: trailing,
      ), // end of ListTile
    ); // end of Card (Settings Item)
  }
}
