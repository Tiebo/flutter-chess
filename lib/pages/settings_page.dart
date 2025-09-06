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
            ListTile(
              leading: Icon(
                provider.locale.languageCode == 'zh' 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.chinese),
              onTap: () => provider.setLocale(const Locale('zh')),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                provider.locale.languageCode == 'en' 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.english),
              onTap: () => provider.setLocale(const Locale('en')),
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
            ListTile(
              leading: Icon(
                provider.themeMode == ThemeMode.light 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.lightTheme),
              onTap: () => provider.setThemeMode(ThemeMode.light),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                provider.themeMode == ThemeMode.dark 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.darkTheme),
              onTap: () => provider.setThemeMode(ThemeMode.dark),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                provider.themeMode == ThemeMode.system 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.systemTheme),
              onTap: () => provider.setThemeMode(ThemeMode.system),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}