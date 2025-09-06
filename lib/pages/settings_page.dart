import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageSection(context, settingsProvider, l10n),
              const SizedBox(height: 16),
              _buildThemeSection(context, settingsProvider, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, SettingsProvider provider, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            RadioListTile<Locale>(
              title: Text(l10n.chinese),
              value: const Locale('zh'),
              groupValue: provider.locale,
              onChanged: (locale) => provider.setLocale(locale!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: provider.locale,
              onChanged: (locale) => provider.setLocale(locale!),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsProvider provider, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightTheme),
              value: ThemeMode.light,
              groupValue: provider.themeMode,
              onChanged: (themeMode) => provider.setThemeMode(themeMode!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkTheme),
              value: ThemeMode.dark,
              groupValue: provider.themeMode,
              onChanged: (themeMode) => provider.setThemeMode(themeMode!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemTheme),
              value: ThemeMode.system,
              groupValue: provider.themeMode,
              onChanged: (themeMode) => provider.setThemeMode(themeMode!),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}