import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/player_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersCount = ref.watch(playerNotifierProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'Account'),
          _SettingsTile(
            icon: LucideIcons.user,
            title: 'Ospite',
            subtitle: 'Accedi per salvare lo storico',
            trailing: TextButton(
              onPressed: () {
                // To be implemented with Firebase Auth
              },
              child: const Text('Login'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          _SectionTitle(title: 'Aspetto'),
          _SettingsTile(
            icon: LucideIcons.moon,
            title: 'Tema Scuro',
            subtitle: 'Attiva o disattiva il dark mode',
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // Placeholder for theme toggle logic (requires a theme provider)
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          _SectionTitle(title: 'Dati'),
          _SettingsTile(
            icon: LucideIcons.trash2,
            iconColor: Colors.red,
            title: 'Svuota tutto',
            subtitle: 'Rimuove tutti i giocatori',
            trailing: TextButton(
              onPressed: playersCount > 0 ? () {
                ref.read(playerNotifierProvider.notifier).clearPlayers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tutti i giocatori sono stati rimossi'), behavior: SnackBarBehavior.floating),
                );
              } : null,
              child: const Text('Svuota', style: TextStyle(color: Colors.red)),
            ),
          ),
          
          const SizedBox(height: 24),
          
          _SectionTitle(title: 'Info'),
          const _SettingsTile(
            icon: LucideIcons.info,
            title: 'Random Teams Generator',
            subtitle: 'Versione 1.0.0 (Ported from React)',
          ),
          const _SettingsTile(
            icon: LucideIcons.github,
            title: 'Codice Sorgente',
            subtitle: 'GitHub Repository',
          ),
        ],
      ),
    );
  }
}

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
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
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
      ),
    );
  }
}
