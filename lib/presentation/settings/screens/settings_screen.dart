import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:calculator_app/presentation/settings/providers/theme_notifier.dart';
import 'package:calculator_app/presentation/monetization/providers/premium_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeSystem),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) => _setTheme(ref, mode),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeLight),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) => _setTheme(ref, mode),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeDark),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) => _setTheme(ref, mode),
          ),
          const Divider(),
          _buildPremiumSection(context, ref),
        ],
      ),
    );
  }

  Widget _buildPremiumSection(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);
    final notifier = ref.read(premiumProvider.notifier);

    if (isPremium) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '👑 Premium Enabled (Ad-Free)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => notifier.buyPremium(),
            icon: const Icon(Icons.star),
            label: const Text('Go Premium (Remove Ads)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => notifier.restorePurchases(),
            child: const Text('Restore Purchases'),
          ),
        ],
      ),
    );
  }

  void _setTheme(WidgetRef ref, ThemeMode? mode) {
    if (mode != null) {
      ref.read(themeProvider.notifier).setThemeMode(mode);
    }
  }
}
